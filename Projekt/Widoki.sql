--Zestawienie przychodów dla każdego wydarzenia
CREATE VIEW FINANCIAL_REPORT AS
SELECT W.WebinarID AS 'ID', W.WebinarName AS 'Name', 'Webinar' AS 'Type',
FullPrice*(SELECT COUNT(*) FROM OrderDetails OD
WHERE OD.ActivityID=W.WebinarID) AS 'Total Income'
FROM Webinars W
INNER JOIN Activities A ON A.ActivityID=W.WebinarID
UNION
SELECT C.CourseID AS 'ID', C.CourseName AS 'Name', 'Course' AS 'Type',
FullPrice*(SELECT COUNT(*) FROM OrderDetails OD
WHERE OD.ActivityID=C.CourseID) AS 'Total Income'
FROM Courses C
INNER JOIN Activities A ON A.ActivityID=C.CourseID
UNION
SELECT S.StudiesID AS 'ID', S.StudiesName AS 'Name', 'Study' AS 'Type',
ISNULL((A.FullPrice+EntryFee)*(SELECT COUNT(*) FROM OrderDetails OD
WHERE OD.ActivityID=S.StudiesID) +
(SELECT TOP 1 A2.FullPrice*(SELECT TOP 1 COUNT(*) FROM OrderDetails OD2 
     WHERE OD2.ActivityID=SM.ActivityID)
     FROM StudiesMeetings SM
     INNER JOIN Subjects Sub ON SM.SubjectID = Sub.SubjectID
     INNER JOIN Activities A2 ON A2.ActivityID = SM.ActivityID
     INNER JOIN OrderDetails OD ON OD.ActivityID = SM.ActivityID
     WHERE Sub.StudiesID = S.StudiesID), 0) AS 'Total Income'
FROM Studies S
INNER JOIN Activities A ON A.ActivityID=S.StudiesID

--Zestawienie przychodów dla każdego kursu
CREATE VIEW COURSES_FINANCIAL_REPORT AS
SELECT C.CourseID AS 'ID', C.CourseName AS 'Course Name',
FullPrice*(SELECT COUNT(*) FROM OrderDetails OD
WHERE OD.ActivityID=C.CourseID) AS 'Total Income'
FROM Courses C
INNER JOIN Activities A ON A.ActivityID=C.CourseID

--Zestawienie przychodów dla każdego studium
CREATE VIEW STUDIES_FINANCIAL_REPORT AS
SELECT S.StudiesID AS 'ID', S.StudiesName AS 'Name', 'Study' AS 'Type',
ISNULL((A.FullPrice+EntryFee)*(SELECT COUNT(*) FROM OrderDetails OD
WHERE OD.ActivityID=S.StudiesID) +
(SELECT A2.FullPrice*(SELECT COUNT(*) FROM OrderDetails OD2 WHERE OD2.ActivityID=SM.ActivityID)
     FROM StudiesMeetings SM
     INNER JOIN Subjects Sub ON SM.SubjectID = Sub.SubjectID
     INNER JOIN Activities A2 ON A2.ActivityID = SM.ActivityID
     INNER JOIN OrderDetails OD ON OD.ActivityID = SM.ActivityID
     WHERE Sub.StudiesID = S.StudiesID), 0) AS 'Total Income'
FROM Studies S
INNER JOIN Activities A ON A.ActivityID=S.StudiesID

--Zestawienie przychodów dla każdego webinaru
CREATE VIEW WEBINARS_FINANCIAL_REPORT AS
SELECT W.WebinarID AS 'ID', W.WebinarName AS 'Webinar Name',
FullPrice*(SELECT COUNT(*) FROM OrderDetails OD
WHERE OD.ActivityID=W.WebinarID) AS 'Total Income'
FROM Webinars W
INNER JOIN Activities A ON A.ActivityID=W.WebinarID

--Zestawienie osób zalegających z płatnościami
CREATE VIEW LIST_OF_DEBTORS AS
SELECT StudentID AS 'ID', FirstName, LastName, Address, City, Country, Phone, Email, 
ISNULL((SELECT SUM(FullPrice-AmountPaid) FROM Orders O2
INNER JOIN OrderDetails OD2 ON OD2.OrderID=O2.OrderID
INNER JOIN Activities A ON A.ActivityID=OD2.ActivityID
INNER JOIN Webinars W ON W.WebinarID=A.ActivityID
WHERE O2.StudentID=S.StudentID AND mustPayInTime=0), 0) +
ISNULL((SELECT SUM(FullPrice-AmountPaid) FROM Orders O2
INNER JOIN OrderDetails OD2 ON OD2.OrderID=O2.OrderID
INNER JOIN Activities A ON A.ActivityID=OD2.ActivityID
INNER JOIN Courses C ON C.CourseID=A.ActivityID
WHERE O2.StudentID=S.StudentID AND mustPayInTime=0), 0) + 
ISNULL((SELECT SUM(FullPrice+EntryFee-AmountPaid) FROM Orders O2
INNER JOIN OrderDetails OD2 ON OD2.OrderID=O2.OrderID
INNER JOIN Activities A ON A.ActivityID=OD2.ActivityID
INNER JOIN Studies St ON St.StudiesID=A.ActivityID
WHERE O2.StudentID=S.StudentID AND mustPayInTime=0), 0) +
ISNULL((SELECT SUM(FullPrice-AmountPaid) FROM Orders O2
INNER JOIN OrderDetails OD2 ON OD2.OrderID=O2.OrderID
INNER JOIN Activities A ON A.ActivityID=OD2.ActivityID
INNER JOIN StudiesMeetings SM ON SM.ActivityID=A.ActivityID
WHERE O2.StudentID=S.StudentID AND mustPayInTime=0), 0) AS 'Total debt'
FROM Students S
INNER JOIN Users U ON U.UserID=S.StudentID
INNER JOIN Cities Cit ON U.CityID=Cit.CityID
INNER JOIN Countries Co ON Co.CountryID=Cit.CountryID
WHERE StudentID IN
(SELECT StudentID FROM Orders O
INNER JOIN OrderDetails OD ON OD.OrderID=O.OrderID
INNER JOIN Activities A ON A.ActivityID=OD.ActivityID
INNER JOIN Webinars W ON W.WebinarID=A.ActivityID
WHERE AmountPaid<FullPrice AND WebinarDate < GETDATE() AND mustPayInTime=0
UNION
SELECT StudentID FROM Orders O
INNER JOIN OrderDetails OD ON OD.OrderID=O.OrderID
INNER JOIN Activities A ON A.ActivityID=OD.ActivityID
INNER JOIN Courses C ON C.CourseID=A.ActivityID
WHERE AmountPaid<FullPrice AND 
(SELECT MIN(CM.Date) FROM CourseModules CM
WHERE C.CourseID=CM.CourseID) < GETDATE() AND mustPayInTime=0
UNION
SELECT StudentID FROM Orders O
INNER JOIN OrderDetails OD ON OD.OrderID=O.OrderID
INNER JOIN Activities A ON A.ActivityID=OD.ActivityID
INNER JOIN Studies St ON St.StudiesID=A.ActivityID
WHERE AmountPaid<FullPrice+EntryFee AND 
(SELECT MIN(SM.MeetingDate) FROM StudiesMeetings SM
INNER JOIN Subjects Sub ON Sub.SubjectID=SM.SubjectID
WHERE St.StudiesID=Sub.StudiesID) < GETDATE() AND mustPayInTime=0
UNION 
SELECT StudentID FROM Orders O
INNER JOIN OrderDetails OD ON OD.OrderID=O.OrderID
INNER JOIN Activities A ON A.ActivityID=OD.ActivityID
INNER JOIN StudiesMeetings SM ON SM.ActivityID=A.ActivityID
WHERE AmountPaid<FullPrice AND MeetingDate < GETDATE() AND mustPayInTime=0)

--Zestawienie osób spóźnionych z płatnościami za studia
CREATE VIEW STUDENTS_LATE_WITH_PAYMENTS_FOR_STUDIES AS
SELECT StudentID AS 'ID', FirstName, LastName, Address, City, Country, Phone, Email, 
ISNULL((SELECT 
(SELECT SUM(DiscountPrice) FROM StudiesMeetings SM
INNER JOIN Subjects Sub ON Sub.SubjectID=SM.SubjectID 
WHERE Sub.StudiesID=A.ActivityID AND MeetingDate < DATEADD(DAY, 3, GETDATE()))
+EntryFee-AmountPaid FROM Orders O2
INNER JOIN OrderDetails OD2 ON OD2.OrderID=O2.OrderID
INNER JOIN Activities A ON A.ActivityID=OD2.ActivityID
INNER JOIN Studies St ON St.StudiesID=A.ActivityID
WHERE O2.StudentID=S.StudentID), 0) AS 'Total debt'
FROM Students S
INNER JOIN Users U ON U.UserID=S.StudentID
INNER JOIN Cities Cit ON U.CityID=Cit.CityID
INNER JOIN Countries Co ON Co.CountryID=Cit.CountryID
WHERE StudentID IN
(SELECT StudentID FROM Orders O
INNER JOIN OrderDetails OD ON OD.OrderID=O.OrderID
INNER JOIN Activities A ON A.ActivityID=OD.ActivityID
INNER JOIN Studies St ON St.StudiesID=A.ActivityID
WHERE AmountPaid<FullPrice+EntryFee AND 
(SELECT MIN(SM.MeetingDate) FROM StudiesMeetings SM
INNER JOIN Subjects Sub ON Sub.SubjectID=SM.SubjectID
WHERE St.StudiesID=Sub.StudiesID) < GETDATE())

--Widok koszyka wraz z kosztami aktywności
CREATE VIEW SHOPPING_CART_VIEW AS
SELECT StudentID, SC.ActivityID, FullPrice+ISNULL(EntryFee, 0) AS 'Price' FROM ShoppingCart SC
INNER JOIN Activities A ON A.ActivityID=SC.ActivityID
LEFT JOIN Studies S ON S.StudiesID=A.ActivityID

--Zestawienie liczby osób zapisanych na przyszłe wydarzenia
CREATE view PeopleSignedForUpcomingEvents as
	SELECT *
	FROM PeopleSignedForUpcomingCourses
	UNION
	SELECT *
	FROM PeopleSignedForUpcomingStudiesMeetings
	UNION
	SELECT *
	FROM PeopleSignedForUpcomingWebinars

--Zestawienie liczby osób zapisanych na przyszłe spotkania studyjne
CREATE view PeopleSignedForUpcomingStudiesMeetings as
	SELECT sm.MeetingID                                                                     
	AS ActivityID,
       	s.SubjectName                                                                      	
		AS Name,
       	Studies.StudiesName                                                                	
		AS "Course/ Major Name",
       	sm.MeetingDate                                                                     	
		AS DATE,
       	COUNT(*)                                                                           	
		AS NumberOfStudents,
       	'Study Meeting'                                                                    	
		AS TYPE,
       	IIF(sm.MeetingID IN (SELECT om.MeetingID FROM OnsiteMeetings om), 'Offline', 'Online') AS OnlineOrOffline
	FROM StudiesMeetings sm
         	INNER JOIN Subjects s ON sm.SubjectID = s.SubjectID
         	INNER JOIN StudiesMeetingsDetails smd ON sm.MeetingID = smd.MeetingID
         	INNER JOIN Studies ON s.StudiesID = Studies.StudiesID
	WHERE MeetingDate > GETDATE()
	GROUP BY sm.MeetingID, s.SubjectName, Studies.StudiesName, sm.MeetingDate, sm.MeetingID

--Zestawienie liczby osób zapisanych na przyszłe moduły kursów
CREATE view PeopleSignedForUpcomingCourses as
	SELECT cm.CourseID                                                                     	
	AS ActivityID,
       	cm.ModuleName                                                                   	
		AS Name,
       	c.CourseName                                                                    	
		AS "Course/ Major Name",
       	cm.Date                                                                         	
		AS Date,
       	COUNT(*)                                                                        	
		AS NumberOfStudents,
       	'Course'                                                                        	
		AS Type,
       	IIF(cm.ModuleID IN (SELECT om.ModuleID FROM OnsiteModules om), 'Offline', 'Online') 
		AS OnlineOrOffline
	FROM CourseModules cm
         	INNER JOIN CourseModulesDetails cmd ON cm.ModuleID = cmd.ModuleID
         	INNER JOIN Courses c ON cm.CourseID = c.CourseID
	WHERE cm.Date > GETDATE()
	GROUP BY cm.CourseID, cm.ModuleName, c.CourseName, cm.Date, cm.ModuleID

--Zestawienie liczby osób zapisanych na przyszłe webinary
CREATE view PeopleSignedForUpcomingWebinars as
	SELECT w.WebinarID   AS ActivityID,
       	w.WebinarName AS Name,
       	'-'       	AS "Course/ Major Name",
       	w.WebinarDate AS Date,
       	COUNT(*)  	AS NumberOfStudents,
       	'Webinar' 	AS Type,
       	'Online'  	AS OnlineOrOffline
	FROM Webinars w
         	INNER JOIN WebinarDetails wd ON w.WebinarID = wd.WebinarID
	WHERE WebinarDate > GETDATE()
	GROUP BY w.WebinarID, w.WebinarName, w.WebinarDate

--Zestawienie frekwencji na zakończonych wydarzeniach
CREATE view EventsAttendanceSummary as
	SELECT *
	FROM CoursesAttendanceSummary
	UNION
	SELECT *
	FROM StudiesMeetingAttendanceSummary

--Zestawienie frekwencji na zakończonych spotkaniach studyjnych
CREATE view StudiesMeetingAttendanceSummary as
	SELECT smd.MeetingID                                       	
	AS ID,
       	Subjects.SubjectName                                	
		AS "Module/ Subject Name",
       	Studies.StudiesName                                 	
		AS "Course/ Major Name",
       	100 * COUNT(*) / (SELECT COUNT(*)
                         	FROM Students s
                                  	INNER JOIN StudiesMeetingsDetails smd2 ON s.StudentID = smd2.StudentID
                         	WHERE smd.MeetingID = smd2.MeetingID) 
							AS 'Attendance [%]',
       	'Study Meeting'                                     	
		AS Type
	FROM StudiesMeetingsDetails smd
         	INNER JOIN StudiesMeetings sm ON sm.MeetingID = smd.MeetingID
         	INNER JOIN Subjects ON sm.SubjectID = Subjects.SubjectID
         	INNER JOIN Studies ON Studies.StudiesID = Subjects.StudiesID
	WHERE sm.MeetingDate < GETDATE()
  	AND NOT smd.PassedDate IS NULL
	GROUP BY smd.MeetingID, Subjects.SubjectName, Studies.StudiesName

--Zestawienie frekwencji na zakończonych modułach kursów
CREATE view CoursesAttendanceSummary as
	SELECT cmd.ModuleID                                      	
	AS ID,
       	cm.ModuleName                                     	
		AS "Module/ Subject Name",
       	c.CourseName                                      	
		AS "Course/ Major Name",
       	100 * COUNT(*) / (SELECT COUNT(*)
                         	FROM Students s
                                  	INNER JOIN CourseModulesDetails cmd2 ON s.StudentID = cmd2.StudentID
                         	WHERE cmd.ModuleID = cmd2.ModuleID) 
							AS 'Attendance [%]',
       	'Course'                                          	
		AS Type
	FROM CourseModulesDetails cmd
         	INNER JOIN CourseModules cm ON cm.ModuleID = cmd.ModuleID
         	INNER JOIN Courses c ON C.CourseID = cm.CourseID
	WHERE cm.Date < GETDATE()
  	AND NOT cmd.PassedDate IS NULL
	GROUP BY cmd.ModuleID, cm.ModuleName, c.CourseName

--Pokaż dane wszystkich studentów
CREATE VIEW STUDENTS_DATA AS
SELECT UserID, FirstName, LastName, City, Country, Address, Phone, Email FROM Users U
INNER JOIN Cities Cit ON Cit.CityID=U.CityID
INNER JOIN Countries Co ON Co.CountryID=Cit.CountryID
WHERE UserID IN
(SELECT StudentID FROM Students)

--Pokaż dane wszystkich wykładowców
CREATE VIEW LECTURERS_DATA AS
SELECT UserID, FirstName, LastName, City, Country, Address, Phone, Email FROM Users U
INNER JOIN Cities Cit ON Cit.CityID=U.CityID
INNER JOIN Countries Co ON Co.CountryID=Cit.CountryID
WHERE UserID IN
(SELECT LecturerID FROM Lecturers)

--Pokaż dane wszystkich tłumaczy
CREATE VIEW TRANSLATORS_DATA AS
SELECT UserID, FirstName, LastName, City, Country, Address, Phone, Email, STRING_AGG(AL.LanguageName, ', ') AS Languages FROM Users U
INNER JOIN Cities Cit ON Cit.CityID=U.CityID
INNER JOIN Countries Co ON Co.CountryID=Cit.CountryID
INNER JOIN Translators T ON T.TranslatorID = U.UserID
LEFT JOIN TranslatorLanguages TL ON TL.TranslatorID = T.TranslatorID
LEFT JOIN AvailableLanguages AL ON AL.LanguageID = TL.LanguageID
GROUP BY U.UserID, U.FirstName, U.LastName, Cit.City, Co.Country, U.Address, U.Phone, U.Email;

--Pokaż dane wszystkich administratorów
CREATE VIEW ADMINISTRATORS_DATA AS
SELECT UserID, FirstName, LastName, City, Country, Address, Phone, Email FROM Users U
INNER JOIN Cities Cit ON Cit.CityID=U.CityID
INNER JOIN Countries Co ON Co.CountryID=Cit.CountryID
WHERE UserID IN
(SELECT AdministratorID FROM Administrators)

--Pokaż dane wszystkich dyrektorów
CREATE VIEW DIRECTORS_DATA AS
SELECT UserID, FirstName, LastName, City, Country, Address, Phone, Email FROM Users U
INNER JOIN Cities Cit ON Cit.CityID=U.CityID
INNER JOIN Countries Co ON Co.CountryID=Cit.CountryID
WHERE UserID IN
(SELECT DirectorID FROM Directors)

--Pokaż dane wszystkich pracowników sekretariatu
CREATE VIEW SECRETARY_WORKERS_DATA AS
SELECT UserID, FirstName, LastName, City, Country, Address, Phone, Email FROM Users U
INNER JOIN Cities Cit ON Cit.CityID=U.CityID
INNER JOIN Countries Co ON Co.CountryID=Cit.CountryID
WHERE UserID IN
(SELECT SecretaryID FROM SecretaryWorkers)

--Pokaż dane wszystkich prowadzących praktyki
CREATE VIEW INTERNSHIP_SUPERVISORS_DATA AS
SELECT UserID, FirstName, LastName, City, Country, Address, Phone, Email FROM Users U
INNER JOIN Cities Cit ON Cit.CityID=U.CityID
INNER JOIN Countries Co ON Co.CountryID=Cit.CountryID
WHERE UserID IN
(SELECT SupervisorID FROM InternshipSupervisors)

--Lista obecności na każdym wydarzeniu
CREATE view AttendanceListAllEvents as
	SELECT CourseName                         	AS Name,
       	ModuleName                         	AS Subject,
       	Users.LastName + ' ' + Users.FirstName AS 'Full Name',
       	'Course'                           	as [Activity type]
	FROM CourseModulesDetails
         	INNER JOIN Students ON CourseModulesDetails.StudentID = Students.StudentID
         	INNER JOIN Users ON Students.StudentID = Users.UserID
         	INNER JOIN CourseModules ON CourseModulesDetails.ModuleID = CourseModules.ModuleID
         	INNER JOIN Courses ON CourseModules.CourseID = Courses.CourseID

	UNION

	SELECT StudiesName                        	AS Name,
       	SubjectName                        	AS Subject,
       	Users.LastName + ' ' + Users.FirstName AS 'Full Name',
       	'Studies'                          	as [Activity type]
	FROM StudiesMeetingsDetails
         	INNER JOIN Students ON StudiesMeetingsDetails.StudentID = Students.StudentID
         	INNER JOIN Users ON Students.StudentID = Users.UserID
         	INNER JOIN StudiesMeetings ON StudiesMeetingsDetails.MeetingID = StudiesMeetings.MeetingID
         	INNER JOIN Subjects ON StudiesMeetings.SubjectID = Subjects.SubjectID
         	INNER JOIN Studies ON Subjects.StudiesID = Studies.StudiesID

	UNION

	SELECT WebinarName                        	AS Name,
       	''                                 	as Subject,
       	Users.LastName + ' ' + Users.FirstName AS 'Full Name',
       	'Webinar'                          	as [Activity type]
	FROM WebinarDetails
         	INNER JOIN Students ON WebinarDetails.StudentID = Students.StudentID
         	INNER JOIN Users ON Students.StudentID = Users.UserID
         	INNER JOIN Webinars ON WebinarDetails.WebinarID = Webinars.WebinarID

--Lista obecności na każdym spotkaniu studyjnym
CREATE view AttendanceListStudiesMeetings as
	SELECT StudiesName                        	AS Name,
       	SubjectName                        	AS Subject,
       	Users.LastName + ' ' + Users.FirstName AS 'Full Name',
       	'Studies'                          	as [Activity type]
	FROM StudiesMeetingsDetails
         	INNER JOIN Students ON StudiesMeetingsDetails.StudentID = Students.StudentID
         	INNER JOIN Users ON Students.StudentID = Users.UserID
         	INNER JOIN StudiesMeetings ON StudiesMeetingsDetails.MeetingID = StudiesMeetings.MeetingID
         	INNER JOIN Subjects ON StudiesMeetings.SubjectID = Subjects.SubjectID
         	INNER JOIN Studies ON Subjects.StudiesID = Studies.StudiesID

--Lista obecności na każdym module kursu
CREATE view AttendanceListCourseModules as
	SELECT CourseName                         	AS Name,
       	ModuleName                         	AS Subject,
       	Users.LastName + ' ' + Users.FirstName AS 'Full Name',
       	'Course'                           	as [Activity type]
	FROM CourseModulesDetails
         	INNER JOIN Students ON CourseModulesDetails.StudentID = Students.StudentID
         	INNER JOIN Users ON Students.StudentID = Users.UserID
         	INNER JOIN CourseModules ON CourseModulesDetails.ModuleID = CourseModules.ModuleID
         	INNER JOIN Courses ON CourseModules.CourseID = Courses.CourseID

--Lista obecności na każdym webinarze
CREATE view AttendanceListWebinars as
	SELECT WebinarName                        	AS Name,
       	''                                 	as Subject,
       	Users.LastName + ' ' + Users.FirstName AS 'Full Name',
       	'Webinar'                          	as [Activity type]
	FROM WebinarDetails
         	INNER JOIN Students ON WebinarDetails.StudentID = Students.StudentID
         	INNER JOIN Users ON Students.StudentID = Users.UserID
         	INNER JOIN Webinars ON WebinarDetails.WebinarID = Webinars.WebinarID

--Lista osób z kolizjami w przyszłym planie zajęć
CREATE VIEW PEOPLE_WITH_COLLISIONS_IN_FUTURE_PLAN AS
SELECT S.StudentID AS 'ID', FirstName, LastName, Address, City, Phone, Email, AFE.FirstID, AFE.FirstEventID, AFE.FirstDate, AFE2.SecondID, AFE2.SecondEventID, AFE2.SecondDate FROM Students S
INNER JOIN Users U ON U.UserID=S.StudentID
INNER JOIN Cities Cit ON Cit.CityID=U.CityID
INNER JOIN Orders O ON O.StudentID=S.StudentID
INNER JOIN OrderDetails OD ON OD.OrderID=O.OrderID
INNER JOIN OrderDetails OD2 ON OD2.OrderID=O.OrderID
INNER JOIN (
SELECT WebinarID AS 'FirstID', WebinarID AS 'FirstEventID', WebinarDate AS 'FirstDate' FROM Webinars W
WHERE WebinarDate > GETDATE()
UNION
SELECT Sub.StudiesID AS 'FirstID', ActivityID AS 'FirstEventID', MeetingDate AS 'FirstDate' FROM StudiesMeetings SM
INNER JOIN Subjects Sub ON SM.SubjectID=Sub.SubjectID
WHERE MeetingDate > GETDATE()
UNION
SELECT CourseID AS 'FirstID', ModuleID AS 'FirstEventID', Date AS 'FirstDate' FROM CourseModules CM
WHERE CM.Date > GETDATE()
UNION
SELECT ActivityID AS 'FirstID', null AS 'FirstEventID', MeetingDate AS 'FirstDate' FROM StudiesMeetings SM2
WHERE MeetingDate > GETDATE()) AFE ON AFE.FirstID=OD.ActivityID
INNER JOIN (
SELECT WebinarID AS 'SecondID', WebinarID AS 'SecondEventID', WebinarDate AS 'SecondDate' FROM Webinars W
WHERE WebinarDate > GETDATE()
UNION
SELECT Sub.StudiesID AS 'SecondID', ActivityID AS 'SecondEventID', MeetingDate AS 'SecondDate' FROM StudiesMeetings SM
INNER JOIN Subjects Sub ON SM.SubjectID=Sub.SubjectID
WHERE MeetingDate > GETDATE()
UNION
SELECT CourseID AS 'SecondID', ModuleID AS 'SecondEventID', Date AS 'SecondDate' FROM CourseModules CM
WHERE CM.Date > GETDATE()
UNION
SELECT ActivityID AS 'SecondID', null AS 'SecondEventID', MeetingDate AS 'SecondDate' FROM StudiesMeetings SM2
WHERE MeetingDate > GETDATE()) AFE2 ON AFE2.SecondID=OD2.ActivityID
WHERE NOT(AFE.FirstID=AFE2.SecondID AND AFE.FirstEventID=AFE2.SecondEventID) 
	AND DATEDIFF(MINUTE, AFE.FirstDate, AFE2.SecondDate)<90 AND DATEDIFF(MINUTE, AFE.FirstDate, AFE2.SecondDate)>0

--Lista wszystkich przyszłych wydarzeń
create view UpcomingEvents as
select MeetingDate                 	as Date,
       	'Studies Meeting'           	as EventType,
       	MeetingID                   	as EventID,
       	Subjects.SubjectName        	as Subject,
       	AvailableLanguages.LanguageName as Language
	from StudiesMeetings
         	inner join Subjects on StudiesMeetings.SubjectID = Subjects.SubjectID
         	inner join AvailableLanguages on StudiesMeetings.LanguageID = AvailableLanguages.LanguageID
	where MeetingDate > getdate()

	UNION

	select Date                        	as Date,
       	'Course Module'             	as EventType,
       	ModuleID                    	as EventID,
       	ModuleName                  	as Subject,
       	AvailableLanguages.LanguageName as Language
	from CourseModules
         	inner join AvailableLanguages on CourseModules.LanguageID = AvailableLanguages.LanguageID
         	inner join Courses ON CourseModules.CourseID = Courses.CourseID
	where Date > getdate()

	UNION
	select WebinarDate                 	as Date,
       	'Webinar'                   	as EventType,
       	WebinarID                   	as EventID,
       	WebinarName                 	as Subject,
       	AvailableLanguages.LanguageName as Language
	from Webinars
         	inner join AvailableLanguages on Webinars.LanguageID = AvailableLanguages.LanguageID
	where WebinarDate > getdate()

--Lista wszystkich przyszłych spotkań studyjnych
create view UpcomingStudiesMeetings as
select MeetingDate, MeetingID, Subjects.SubjectName, AvailableLanguages.LanguageName
	from StudiesMeetings
         	inner join Subjects on StudiesMeetings.SubjectID = Subjects.SubjectID
         	inner join AvailableLanguages on StudiesMeetings.LanguageID = AvailableLanguages.LanguageID
	where MeetingDate > getdate()

--Lista wszystkich przyszłych modułów kursów
create view UpcomingCourseModules as
select Date, ModuleID, Courses.CourseName, ModuleName, AvailableLanguages.LanguageName
	from CourseModules
         	inner join AvailableLanguages on CourseModules.LanguageID = AvailableLanguages.LanguageID
         	inner join Courses ON CourseModules.CourseID = Courses.CourseID
	where Date > getdate()

--Lista wszystkich przyszłych webinarów
create view UpcomingWebinars as
select WebinarDate, WebinarID, WebinarName, AvailableLanguages.LanguageName
	from Webinars
         	inner join AvailableLanguages on Webinars.LanguageID = AvailableLanguages.LanguageID
	where WebinarDate > getdate()