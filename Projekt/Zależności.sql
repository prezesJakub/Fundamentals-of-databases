-- Reference: Administrators_Users (table: Administrators)
ALTER TABLE Administrators ADD CONSTRAINT Administrators_Users
    FOREIGN KEY (AdministratorID)
    REFERENCES Users (UserID);

-- Reference: Cities_Countries (table: Cities)
ALTER TABLE Cities ADD CONSTRAINT Cities_Countries
    FOREIGN KEY (CountryID)
    REFERENCES Countries (CountryID);

-- Reference: CourseModulesDetails_CourseModules (table: CourseModulesDetails)
ALTER TABLE CourseModulesDetails ADD CONSTRAINT CourseModulesDetails_CourseModules
    FOREIGN KEY (ModuleID)
    REFERENCES CourseModules (ModuleID);

-- Reference: CourseModulesDetails_Students (table: CourseModulesDetails)
ALTER TABLE CourseModulesDetails ADD CONSTRAINT CourseModulesDetails_Students
    FOREIGN KEY (StudentID)
    REFERENCES Students (StudentID);

-- Reference: CourseModules_AvailableLanguages (table: CourseModules)
ALTER TABLE CourseModules ADD CONSTRAINT CourseModules_AvailableLanguages
    FOREIGN KEY (LanguageID)
    REFERENCES AvailableLanguages (LanguageID);

-- Reference: CourseModules_Courses (table: CourseModules)
ALTER TABLE CourseModules ADD CONSTRAINT CourseModules_Courses
    FOREIGN KEY (CourseID)
    REFERENCES Courses (CourseID);

-- Reference: CourseModules_Lecturers (table: CourseModules)
ALTER TABLE CourseModules ADD CONSTRAINT CourseModules_Lecturers
    FOREIGN KEY (LecturerID)
    REFERENCES Lecturers (LecturerID);

-- Reference: CourseModules_Translators (table: CourseModules)
ALTER TABLE CourseModules ADD CONSTRAINT CourseModules_Translators
    FOREIGN KEY (TranslatorID)
    REFERENCES Translators (TranslatorID);

-- Reference: Courses_Activities (table: Courses)
ALTER TABLE Courses ADD CONSTRAINT Courses_Activities
    FOREIGN KEY (CourseID)
    REFERENCES Activities (ActivityID);

-- Reference: Courses_CourseTypes (table: Courses)
ALTER TABLE Courses ADD CONSTRAINT Courses_CourseTypes
    FOREIGN KEY (CourseTypeID)
    REFERENCES CourseTypes (CourseTypeID);

-- Reference: Directors_Users (table: Directors)
ALTER TABLE Directors ADD CONSTRAINT Directors_Users
    FOREIGN KEY (DirectorID)
    REFERENCES Users (UserID);

-- Reference: InternshipDetails_Internships (table: InternshipDetails)
ALTER TABLE InternshipDetails ADD CONSTRAINT InternshipDetails_Internships
    FOREIGN KEY (InternshipID)
    REFERENCES Internships (InternshipID);

-- Reference: InternshipDetails_Students (table: InternshipDetails)
ALTER TABLE InternshipDetails ADD CONSTRAINT InternshipDetails_Students
    FOREIGN KEY (StudentID)
    REFERENCES Students (StudentID);

-- Reference: InternshipSupervisors_Users (table: InternshipSupervisors)
ALTER TABLE InternshipSupervisors ADD CONSTRAINT InternshipSupervisors_Users
    FOREIGN KEY (SupervisorID)
    REFERENCES Users (UserID);

-- Reference: Internships_InternshipSupervisors (table: Internships)
ALTER TABLE Internships ADD CONSTRAINT Internships_InternshipSupervisors
    FOREIGN KEY (SupervisorID)
    REFERENCES InternshipSupervisors (SupervisorID);

-- Reference: Internships_Studies (table: Internships)
ALTER TABLE Internships ADD CONSTRAINT Internships_Studies
    FOREIGN KEY (StudiesID)
    REFERENCES Studies (StudiesID);

-- Reference: Lecturers_Users (table: Lecturers)
ALTER TABLE Lecturers ADD CONSTRAINT Lecturers_Users
    FOREIGN KEY (LecturerID)
    REFERENCES Users (UserID);

-- Reference: OnlineAsyncMeeting_StudiesMeetings (table: OnlineAsyncMeetings)
ALTER TABLE OnlineAsyncMeetings ADD CONSTRAINT OnlineAsyncMeeting_StudiesMeetings
    FOREIGN KEY (MeetingID)
    REFERENCES StudiesMeetings (MeetingID);

-- Reference: OnlineAsyncModule_CourseModules (table: OnlineAsyncModules)
ALTER TABLE OnlineAsyncModules ADD CONSTRAINT OnlineAsyncModule_CourseModules
    FOREIGN KEY (ModuleID)
    REFERENCES CourseModules (ModuleID);

-- Reference: OnlineSyncMeeting_StudiesMeetings (table: OnlineSyncMeetings)
ALTER TABLE OnlineSyncMeetings ADD CONSTRAINT OnlineSyncMeeting_StudiesMeetings
    FOREIGN KEY (MeetingID)
    REFERENCES StudiesMeetings (MeetingID);

-- Reference: OnlineSyncModule_CourseModules (table: OnlineSyncModules)
ALTER TABLE OnlineSyncModules ADD CONSTRAINT OnlineSyncModule_CourseModules
    FOREIGN KEY (ModuleID)
    REFERENCES CourseModules (ModuleID);

-- Reference: OrderDetails_Activities (table: OrderDetails)
ALTER TABLE OrderDetails ADD CONSTRAINT OrderDetails_Activities
    FOREIGN KEY (ActivityID)
    REFERENCES Activities (ActivityID);

-- Reference: OrderDetails_Orders (table: OrderDetails)
ALTER TABLE OrderDetails ADD CONSTRAINT OrderDetails_Orders
    FOREIGN KEY (OrderID)
    REFERENCES Orders (OrderID);

-- Reference: Orders_Students (table: Orders)
ALTER TABLE Orders ADD CONSTRAINT Orders_Students
    FOREIGN KEY (StudentID)
    REFERENCES Students (StudentID);

-- Reference: SecretaryWorkers_Users (table: SecretaryWorkers)
ALTER TABLE SecretaryWorkers ADD CONSTRAINT SecretaryWorkers_Users
    FOREIGN KEY (SecretaryID)
    REFERENCES Users (UserID);

-- Reference: ShoppingCart_Activities (table: ShoppingCart)
ALTER TABLE ShoppingCart ADD CONSTRAINT ShoppingCart_Activities
    FOREIGN KEY (ActivityID)
    REFERENCES Activities (ActivityID);

-- Reference: ShoppingCart_Students (table: ShoppingCart)
ALTER TABLE ShoppingCart ADD CONSTRAINT ShoppingCart_Students
    FOREIGN KEY (StudentID)
    REFERENCES Students (StudentID);

-- Reference: StationaryMeeting_Rooms (table: OnsiteMeetings)
ALTER TABLE OnsiteMeetings ADD CONSTRAINT StationaryMeeting_Rooms
    FOREIGN KEY (RoomID)
    REFERENCES Rooms (RoomID);

-- Reference: StationaryMeeting_StudiesMeetings (table: OnsiteMeetings)
ALTER TABLE OnsiteMeetings ADD CONSTRAINT StationaryMeeting_StudiesMeetings
    FOREIGN KEY (MeetingID)
    REFERENCES StudiesMeetings (MeetingID);

-- Reference: StationaryModule_CourseModules (table: OnsiteModules)
ALTER TABLE OnsiteModules ADD CONSTRAINT StationaryModule_CourseModules
    FOREIGN KEY (ModuleID)
    REFERENCES CourseModules (ModuleID);

-- Reference: StationaryModule_Rooms (table: OnsiteModules)
ALTER TABLE OnsiteModules ADD CONSTRAINT StationaryModule_Rooms
    FOREIGN KEY (RoomID)
    REFERENCES Rooms (RoomID);

-- Reference: Students_Users (table: Students)
ALTER TABLE Students ADD CONSTRAINT Students_Users
    FOREIGN KEY (StudentID)
    REFERENCES Users (UserID);

-- Reference: StudiesMeetingsDetails_Students (table: StudiesMeetingsDetails)
ALTER TABLE StudiesMeetingsDetails ADD CONSTRAINT StudiesMeetingsDetails_Students
    FOREIGN KEY (StudentID)
    REFERENCES Students (StudentID);

-- Reference: StudiesMeetingsDetails_StudiesMeetings (table: StudiesMeetingsDetails)
ALTER TABLE StudiesMeetingsDetails ADD CONSTRAINT StudiesMeetingsDetails_StudiesMeetings
    FOREIGN KEY (MeetingID)
    REFERENCES StudiesMeetings (MeetingID);

-- Reference: StudiesMeetings_Activities (table: StudiesMeetings)
ALTER TABLE StudiesMeetings ADD CONSTRAINT StudiesMeetings_Activities
    FOREIGN KEY (ActivityID)
    REFERENCES Activities (ActivityID);

-- Reference: StudiesMeetings_AvailableLanguages (table: StudiesMeetings)
ALTER TABLE StudiesMeetings ADD CONSTRAINT StudiesMeetings_AvailableLanguages
    FOREIGN KEY (LanguageID)
    REFERENCES AvailableLanguages (LanguageID);

-- Reference: StudiesMeetings_Subjects (table: StudiesMeetings)
ALTER TABLE StudiesMeetings ADD CONSTRAINT StudiesMeetings_Subjects
    FOREIGN KEY (SubjectID)
    REFERENCES Subjects (SubjectID);

-- Reference: StudiesMeetings_Translators (table: StudiesMeetings)
ALTER TABLE StudiesMeetings ADD CONSTRAINT StudiesMeetings_Translators
    FOREIGN KEY (TranslatorID)
    REFERENCES Translators (TranslatorID);

-- Reference: Studies_Activities (table: Studies)
ALTER TABLE Studies ADD CONSTRAINT Studies_Activities
    FOREIGN KEY (StudiesID)
    REFERENCES Activities (ActivityID);

-- Reference: SubjectDetails_Students (table: SubjectDetails)
ALTER TABLE SubjectDetails ADD CONSTRAINT SubjectDetails_Students
    FOREIGN KEY (StudentID)
    REFERENCES Students (StudentID);

-- Reference: SubjectDetails_Subjects (table: SubjectDetails)
ALTER TABLE SubjectDetails ADD CONSTRAINT SubjectDetails_Subjects
    FOREIGN KEY (SubjectID)
    REFERENCES Subjects (SubjectID);

-- Reference: Subjects_Lecturers (table: Subjects)
ALTER TABLE Subjects ADD CONSTRAINT Subjects_Lecturers
    FOREIGN KEY (LecturerID)
    REFERENCES Lecturers (LecturerID);

-- Reference: Subjects_Studies (table: Subjects)
ALTER TABLE Subjects ADD CONSTRAINT Subjects_Studies
    FOREIGN KEY (StudiesID)
    REFERENCES Studies (StudiesID);

-- Reference: TranslatorLanguages_AvailableLanguages (table: TranslatorLanguages)
ALTER TABLE TranslatorLanguages ADD CONSTRAINT TranslatorLanguages_AvailableLanguages
    FOREIGN KEY (LanguageID)
    REFERENCES AvailableLanguages (LanguageID);

-- Reference: TranslatorLanguages_Translators (table: TranslatorLanguages)
ALTER TABLE TranslatorLanguages ADD CONSTRAINT TranslatorLanguages_Translators
    FOREIGN KEY (TranslatorID)
    REFERENCES Translators (TranslatorID);

-- Reference: Translators_Users (table: Translators)
ALTER TABLE Translators ADD CONSTRAINT Translators_Users
    FOREIGN KEY (TranslatorID)
    REFERENCES Users (UserID);

-- Reference: Users_Cities (table: Users)
ALTER TABLE Users ADD CONSTRAINT Users_Cities
    FOREIGN KEY (CityID)
    REFERENCES Cities (CityID);

-- Reference: WebinarDetails_Students (table: WebinarDetails)
ALTER TABLE WebinarDetails ADD CONSTRAINT WebinarDetails_Students
    FOREIGN KEY (StudentID)
    REFERENCES Students (StudentID);

-- Reference: WebinarDetails_Webinars (table: WebinarDetails)
ALTER TABLE WebinarDetails ADD CONSTRAINT WebinarDetails_Webinars
    FOREIGN KEY (WebinarID)
    REFERENCES Webinars (WebinarID);

-- Reference: Webinars_Activities (table: Webinars)
ALTER TABLE Webinars ADD CONSTRAINT Webinars_Activities
    FOREIGN KEY (WebinarID)
    REFERENCES Activities (ActivityID);

-- Reference: Webinars_AvailableLanguages (table: Webinars)
ALTER TABLE Webinars ADD CONSTRAINT Webinars_AvailableLanguages
    FOREIGN KEY (LanguageID)
    REFERENCES AvailableLanguages (LanguageID);

-- Reference: Webinars_Lecturers (table: Webinars)
ALTER TABLE Webinars ADD CONSTRAINT Webinars_Lecturers
    FOREIGN KEY (LecturerID)
    REFERENCES Lecturers (LecturerID);

-- Reference: Webinars_Translators (table: Webinars)
ALTER TABLE Webinars ADD CONSTRAINT Webinars_Translators
    FOREIGN KEY (TranslatorID)
    REFERENCES Translators (TranslatorID);