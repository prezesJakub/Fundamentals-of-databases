--Administrator
create role administrator
grant all privileges on u_jzajac.dbo to administrator

--Pracownik sekretariatu
CREATE ROLE SecretaryWorker
GRANT SELECT ON FINANCIAL_REPORT TO SecretaryWorker;
GRANT SELECT ON COURSES_FINANCIAL_REPORT TO SecretaryWorker;
GRANT SELECT ON STUDIES_FINANCIAL_REPORT TO SecretaryWorker;
GRANT SELECT ON WEBINARS_FINANCIAL_REPORT TO SecretaryWorker;
GRANT SELECT ON LIST_OF_DEBTORS TO SecretaryWorker;
GRANT SELECT ON PeopleSignedForUpcomingEvents TO SecretaryWorker;
GRANT SELECT ON PeopleSignedForUpcomingCourses TO SecretaryWorker;
GRANT SELECT ON PeopleSignedForUpcomingStudiesMeetings TO SecretaryWorker;
GRANT SELECT ON PeopleSignedForUpcomingWebinars TO SecretaryWorker;
GRANT SELECT ON STUDENTS_DATA TO SecretaryWorker;
GRANT SELECT ON LECTURERS_DATA TO SecretaryWorker;
GRANT SELECT ON TRANSLATORS_DATA TO SecretaryWorker;
GRANT SELECT ON SECRETARY_WORKERS_DATA TO SecretaryWorker;
GRANT SELECT ON INTERNSHIP_SUPERVISORS_DATA TO SecretaryWorker;
GRANT SELECT ON	DIRECTORS_DATA TO SecretaryWorker;
GRANT SELECT ON	ADMINISTRATORS_DATA TO SecretaryWorker;
GRANT SELECT, UPDATE, INSERT ON Students TO SecretaryWorker;
GRANT SELECT, UPDATE, INSERT ON Orders TO SecretaryWorker;
GRANT SELECT, UPDATE, INSERT ON OrderDetails TO SecretaryWorker;

--Student
CREATE ROLE Student;
GRANT SELECT ON UpcomingCourseModules TO Student;
GRANT SELECT ON UpcomingStudiesMeetings TO Student;
GRANT SELECT ON UpcomingEvents TO Student;
GRANT SELECT ON UpcomingWebinars TO Student;
GRANT EXECUTE ON GetScheduleForStudent TO Student;
GRANT EXECUTE ON GetScheduleForCourse TO Student;
GRANT EXECUTE ON GetScheduleForStudies TO Student;

--Tłumacz
CREATE ROLE Translator
GRANT SELECT ON ALL_FUTURE_EVENTS TO Translator
GRANT SELECT ON Webinars TO Translator
GRANT SELECT ON CourseModules TO Translator
GRANT SELECT ON StudiesMeetings TO Translator

--Wykładowca
CREATE ROLE Lecturer;
GRANT SELECT ON AttendanceListAllEvents TO Lecturer;
GRANT SELECT ON AttendanceListCourseModules TO Lecturer;
GRANT SELECT ON AttendanceListStudiesMeetings TO Lecturer;
GRANT SELECT ON AttendanceListWebinars TO Lecturer;
GRANT SELECT ON CoursesAttendanceSummary TO Lecturer;
GRANT SELECT ON EventsAttendanceSummary TO Lecturer;
GRANT SELECT ON StudiesMeetingAttendanceSummary TO Lecturer;
GRANT SELECT ON UpcomingCourseModules TO Lecturer;
GRANT SELECT ON UpcomingEvents TO Lecturer;
GRANT SELECT ON UpcomingStudiesMeetings TO Lecturer;
GRANT SELECT ON UpcomingWebinars TO Lecturer;

--Prowadzący praktyki
CREATE ROLE InternshipSupervisor
GRANT EXECUTE ON AddInternship TO InternshipSupervisor
GRANT SELECT, INSERT, UPDATE ON Internships TO InternshipSupervisor
GRANT SELECT, INSERT, UPDATE ON InternshipDetails TO InternshipSupervisor
GRANT EXECUTE ON dbo.CheckInternshipPassed TO InternshipSupervisor;