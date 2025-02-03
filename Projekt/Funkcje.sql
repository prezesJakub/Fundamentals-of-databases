--Podliczenie frekwencji użytkownika na danym kursie
CREATE FUNCTION CourseAttendance (
	@StudentID INT,
	@CourseID INT
)
RETURNS DECIMAL(5, 2) -- 5 digits, 2 od which are after the decimal point
AS
BEGIN
	DECLARE @TotalModules INT
	DECLARE @AttendedModules INT

	SELECT @TotalModules = COUNT(*)
	FROM CourseModules
	WHERE CourseID = @CourseID

	SELECT @AttendedModules = COUNT(*)
	FROM CourseModulesDetails cmd
	INNER JOIN CourseModules cm ON cmd.ModuleID = cm.ModuleID
	WHERE cmd.StudentID = @StudentID AND cm.CourseID = @CourseID
      	AND cmd.PassedDate IS NOT NULL

	RETURN IIF(@TotalModules > 0, CAST(@AttendedModules AS DECIMAL(5, 2)) * 100 / @TotalModules, 0)
END;

--Podliczenie frekwencji użytkownika na danym przedmiocie na studiach
CREATE FUNCTION SubjectAttendance (
	@StudentID INT,
	@SubjectID INT
)
RETURNS DECIMAL(5, 2) -- 5 digits, 2 od which are after the decimal point
AS
BEGIN
	DECLARE @TotalMeetings INT
	DECLARE @AttendedMeetings INT

	SELECT @TotalMeetings = COUNT(*)
	FROM StudiesMeetings
	WHERE SubjectID = @SubjectID

	SELECT @AttendedMeetings = COUNT(*)
	FROM StudiesMeetingsDetails smd
	JOIN StudiesMeetings sm ON smd.MeetingID = sm.MeetingID
	WHERE smd.StudentID = @StudentID AND sm.SubjectID = @SubjectID
      	AND smd.PassedDate IS NOT NULL

	RETURN IIF(@TotalMeetings > 0, CAST(@AttendedMeetings AS DECIMAL(5, 2)) * 100 / @TotalMeetings, 0)
END;

--Podliczenie ilości wolnych miejsc na studiach
CREATE FUNCTION GetStudiesAvailableSeats (@StudiesID INT)
RETURNS INT
AS
BEGIN
	DECLARE @ClassLimit INT;
	DECLARE @EnrolledCount INT;
	DECLARE @AvailableSeats INT;

	SELECT @ClassLimit = ClassLimit FROM Studies
	WHERE StudiesID = @StudiesID;

	SELECT @EnrolledCount = COUNT(*) FROM Studies S
	INNER JOIN Activities A ON A.ActivityID=S.StudiesID
	INNER JOIN OrderDetails OD ON OD.ActivityID=A.ActivityID
	INNER JOIN Orders O ON O.OrderID=OD.OrderID
	WHERE S.StudiesID = @StudiesID;

	SET @AvailableSeats = @ClassLimit - @EnrolledCount;

	RETURN @AvailableSeats;
END;

--Podliczenie ilości wolnych miejsc na kursach
CREATE FUNCTION GetCourseAvailableSeats (@CourseID INT)
RETURNS INT
AS
BEGIN
	DECLARE @ClassLimit INT;
	DECLARE @EnrolledCount INT;
	DECLARE @AvailableSeats INT;

	SELECT @ClassLimit = MIN(ClassLimit) FROM OnsiteModules OM
	INNER JOIN CourseModules CM ON CM.ModuleID=OM.ModuleID
	INNER JOIN Courses C ON C.CourseID=CM.CourseID
	WHERE C.CourseID = @CourseID;

	SELECT @EnrolledCount = COUNT(*) FROM Courses C
	INNER JOIN Activities A ON A.ActivityID=C.CourseID
	INNER JOIN OrderDetails OD ON OD.ActivityID=A.ActivityID
	INNER JOIN Orders O ON O.OrderID=OD.OrderID
	WHERE C.CourseID = @CourseID;

	SET @AvailableSeats = @ClassLimit - @EnrolledCount;

	RETURN @AvailableSeats;
END;

--Sprawdzenie czy student zaliczył praktyki
CREATE FUNCTION CheckInternshipPassed (@StudentID INT)
RETURNS BIT
AS
BEGIN
	DECLARE @Result BIT

	SELECT @Result = isPassed
	FROM InternshipDetails
	WHERE StudentID = @StudentID

	RETURN ISNULL(@Result, 0)
END;

--Obliczenie łącznej wartości danego zamówienia
CREATE FUNCTION GetTotalOrderValue (@OrderID INT)
RETURNS MONEY
AS
BEGIN
	DECLARE @TotalValue MONEY;

	SELECT @TotalValue = SUM(
            CASE 
                WHEN S.StudiesID IS NOT NULL THEN (A.FullPrice + S.EntryFee)
                ELSE A.FullPrice
            END
		)
    FROM OrderDetails OD
    INNER JOIN Activities A ON OD.ActivityID = A.ActivityID
    LEFT JOIN Studies S ON A.ActivityID = S.StudiesID
    WHERE OD.OrderID = @OrderID;

	RETURN @TotalValue
END;

--Obliczenie łącznej wartości koszyka
CREATE FUNCTION GetTotalCartValue (@StudentID INT)
RETURNS MONEY
AS
BEGIN
	DECLARE @TotalValue MONEY;

	SELECT @TotalValue = SUM(Price)
    FROM SHOPPING_CART_VIEW SC
    WHERE SC.StudentID = @StudentID;

	RETURN @TotalValue
END;

--Zwrócenie harmonogramu danego kierunku studiów
CREATE FUNCTION GetScheduleForStudies (@StudiesID INT)
RETURNS TABLE
AS
RETURN
(
   SELECT
       s.StudiesName,
       sub.SubjectName,
       sm.MeetingDate,
       l.LanguageName AS Language,
       CONCAT(u.FirstName, ' ', u.LastName) AS Lecturer,
       sm.MeetingID
   FROM
       Studies AS s
   JOIN
       Subjects AS sub ON s.StudiesID = sub.StudiesID
   JOIN
       StudiesMeetings AS sm ON sub.SubjectID = sm.SubjectID
   JOIN
       AvailableLanguages AS l ON sm.LanguageID = l.LanguageID
   JOIN
       Lecturers AS lec ON sub.LecturerID = lec.LecturerID
   JOIN
       Users AS u ON lec.LecturerID = u.UserID
   WHERE
       s.StudiesID = @StudiesID
);

--Zwrócenie harmonogramu danego kierunku studiów w konkretnym semestrze
CREATE FUNCTION GetStudyMeetingsByTerm (
	@StudiesID INT,
	@Term INT
)
RETURNS TABLE
AS
RETURN
(
	SELECT
    	s.StudiesName,
    	sub.SubjectName,
    	sm.MeetingDate,
    	l.LanguageName,
    	CONCAT(u.FirstName, ' ', u.LastName) AS LecturerName,
    	sub.Term
	FROM StudiesMeetings sm
	INNER JOIN Subjects sub ON sm.SubjectID = sub.SubjectID
	INNER JOIN Studies s ON sub.StudiesID = s.StudiesID
	INNER JOIN AvailableLanguages l ON sm.LanguageID = l.LanguageID
	INNER JOIN Lecturers lec ON sub.LecturerID = lec.LecturerID
	INNER JOIN Users u ON lec.LecturerID = u.UserID
	WHERE
    	s.StudiesID = @StudiesID
    	AND sub.Term = @Term
);

--Zwrócenie harmonogramu danego kursu
CREATE FUNCTION GetScheduleForCourse (@CourseID INT)
RETURNS TABLE
AS
RETURN
(
   SELECT
       c.CourseName,
       sm.Date,
       l.LanguageName AS Language,
       CONCAT(u.FirstName, ' ', u.LastName) AS Lecturer,
       sm.ModuleID
   FROM
       Courses AS c
   JOIN
       CourseModules AS sm ON c.CourseID = sm.CourseID
   JOIN
       AvailableLanguages AS l ON sm.LanguageID = l.LanguageID
   JOIN
       Lecturers AS lec ON sm.LecturerID = lec.LecturerID
   JOIN
       Users AS u ON lec.LecturerID = u.UserID
   WHERE
       c.CourseID = @CourseID
);

--Zwrócenie harmonogramu zajęć danego studenta
CREATE FUNCTION GetScheduleForStudent (@StudentID INT)
RETURNS TABLE
AS
RETURN
(
   SELECT
       Students.StudentID,
       CONCAT(su.FirstName, ' ', su.LastName) AS Student,
       'Studies' AS [Activity Type],
       CONCAT(StudiesName, ': ', SubjectName) AS [Activity Name],
       MeetingDate AS Date,
       CONCAT(lu.FirstName, ' ', lu.LastName) AS Lecturer
   FROM
       Students
   INNER JOIN
           Users AS su ON Students.StudentID = su.UserID
   INNER JOIN
           StudiesMeetingsDetails ON Students.StudentID = StudiesMeetingsDetails.StudentID
   INNER JOIN
           StudiesMeetings ON StudiesMeetingsDetails.MeetingID = StudiesMeetings.MeetingID
   INNER JOIN
           Subjects ON StudiesMeetings.SubjectID = Subjects.SubjectID
   INNER JOIN
           Studies ON Subjects.StudiesID = Studies.StudiesID
   INNER JOIN
           Lecturers ON Subjects.LecturerID = Lecturers.LecturerID
   INNER JOIN
           Users AS lu ON Lecturers.LecturerID = lu.UserID
   WHERE
       Students.StudentID = @StudentID

   UNION

   SELECT
       Students.StudentID,
       CONCAT(su.FirstName, ' ', su.LastName) AS Student,
       'Course' AS [Activity Type],
       CONCAT(CourseName, ': ', ModuleName),
       Date,
       CONCAT(lu.FirstName, ' ', lu.LastName) AS Lecturer
   FROM
       Students
   INNER JOIN
           Users AS su ON Students.StudentID = su.UserID
   INNER JOIN
           CourseModulesDetails ON Students.StudentID = CourseModulesDetails.StudentID
   INNER JOIN
           CourseModules ON CourseModulesDetails.ModuleID = CourseModules.ModuleID
   INNER JOIN
           Courses ON CourseModules.CourseID = Courses.CourseID
   INNER JOIN
           Lecturers ON CourseModules.LecturerID = Lecturers.LecturerID
   INNER JOIN
           Users AS lu ON Lecturers.LecturerID = lu.UserID
   WHERE
       Students.StudentID = @StudentID

   UNION

   SELECT
       Students.StudentID,
       CONCAT(su.FirstName, ' ', su.LastName) AS Student,
       'Webinar' AS [Activity Type],
       WebinarName,
       WebinarDate,
       CONCAT(lu.FirstName, ' ', lu.LastName) AS Lecturer
   FROM
       Students
   INNER JOIN
           Users AS su ON Students.StudentID = su.UserID
   INNER JOIN
           WebinarDetails ON Students.StudentID = WebinarDetails.StudentID
   INNER JOIN
           Webinars ON WebinarDetails.WebinarID = Webinars.WebinarID
   INNER JOIN
           Lecturers ON su.UserID = Lecturers.LecturerID
   INNER JOIN
           Users AS lu ON Lecturers.LecturerID = lu.UserID
   WHERE
       Students.StudentID = @StudentID
);