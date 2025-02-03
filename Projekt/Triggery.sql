--Automatyczne dodanie studenta do webinaru po zakupieniu
CREATE TRIGGER trg_AddStudentToWebinar
	ON OrderDetails
	AFTER INSERT, UPDATE AS
BEGIN
	SET NOCOUNT ON;
	INSERT INTO WebinarDetails (WebinarID, StudentID, DueDate)
	SELECT w.WebinarID, o.StudentID, DATEADD(DAY, 30, GETDATE())
	FROM Webinars w
         	INNER JOIN Inserted i ON w.WebinarID = i.ActivityID
         	INNER JOIN Orders o ON o.OrderID = i.OrderID
	WHERE i.AmountPaid >= (SELECT FullPrice FROM Activities WHERE ActivityID = i.ActivityID)
END;

--Automatyczne dodanie studenta do kursu i jego modułów po zakupieniu
CREATE TRIGGER trg_AddStudentToCourseModules
ON OrderDetails
AFTER INSERT,UPDATE
AS
BEGIN
  SET NOCOUNT ON;

  INSERT INTO CourseModulesDetails (ModuleID, StudentID, PassedDate)
  SELECT
      cm.ModuleID,
      o.StudentID,
      NULL
  FROM
      CourseModules cm
  INNER JOIN
      Inserted i ON cm.CourseID = i.ActivityID
  INNER JOIN
      Orders o ON o.OrderID = i.OrderID
  WHERE i.AmountPaid >= (SELECT FullPrice FROM Activities WHERE ActivityID = i.ActivityID) AND dbo.GetCourseAvailableSeats(CM.CourseID) > 0;

END;

--Automatyczne dodanie studenta do studiów i spotkań studyjnych po zakupieniu
CREATE TRIGGER trg_AddStudentToStudies
ON OrderDetails
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    CREATE TABLE #TempMeetings (
        StudentID INT,
        MeetingID INT,
		StudiesID INT,
        CumulativeCost DECIMAL(10, 2)
    );

    INSERT INTO #TempMeetings (StudentID, MeetingID, StudiesID, CumulativeCost)
    SELECT
        O.StudentID,
        SM.MeetingID,
		S.StudiesID,
        SUM(SM.DiscountPrice) OVER (PARTITION BY O.StudentID ORDER BY SM.MeetingDate ROWS UNBOUNDED PRECEDING) + S.EntryFee AS CumulativeCost
    FROM inserted i
    INNER JOIN Orders O ON O.OrderID = i.OrderID
	INNER JOIN OrderDetails OD ON OD.OrderID=O.OrderID
    INNER JOIN Activities A ON A.ActivityID = i.ActivityID
    INNER JOIN Studies S ON S.StudiesID = A.ActivityID
    INNER JOIN Subjects Sub ON Sub.StudiesID = S.StudiesID
    INNER JOIN StudiesMeetings SM ON Sub.SubjectID = SM.SubjectID
    WHERE
        i.AmountPaid >= S.EntryFee
        AND DATEADD(DAY, 3, OD.PaidDate) <= SM.MeetingDate
    ORDER BY
        SM.MeetingDate;

    INSERT INTO StudiesMeetingsDetails (StudentID, MeetingID)
    SELECT
        TM.StudentID,
        TM.MeetingID
    FROM
        #TempMeetings TM
    INNER JOIN Orders O ON O.StudentID = TM.StudentID
    WHERE TM.CumulativeCost <= (SELECT i.AmountPaid FROM inserted i WHERE i.OrderID = O.OrderID)
        AND NOT EXISTS (
            SELECT 1
            FROM StudiesMeetingsDetails SMD
            WHERE SMD.StudentID = TM.StudentID AND SMD.MeetingID = TM.MeetingID
        )
		AND dbo.GetStudiesAvailableSeats(TM.StudiesID) > 0;

    DROP TABLE #TempMeetings;
END;

--Automatyczne dodanie studenta do pojedynczego spotkania studyjnego po zakupieniu
CREATE TRIGGER trg_AddStudentToStudyMeeting
    	ON OrderDetails
    	AFTER INSERT, UPDATE AS
	BEGIN
    	SET NOCOUNT ON;
    	INSERT INTO StudiesMeetingsDetails (MeetingID, StudentID)
    	SELECT sm.MeetingID, o.StudentID
    	FROM Inserted i
             	INNER JOIN Activities a ON a.ActivityID = i.ActivityID
             	INNER JOIN StudiesMeetings sm ON sm.ActivityID = a.ActivityID
             	INNER JOIN Orders o ON o.OrderID = i.OrderID
    	WHERE i.AmountPaid >= (SELECT FullPrice FROM Activities WHERE ActivityID = i.ActivityID)
	END;