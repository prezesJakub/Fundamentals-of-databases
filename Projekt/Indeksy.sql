CREATE INDEX Users_CityID ON Users (CityID)

CREATE INDEX Cities_CountryID ON Cities (CountryID)

CREATE INDEX TranslatorLanguages_TranslatorID ON TranslatorLanguages (TranslatorID)
CREATE INDEX TranslatorLanguages_LanguageID ON TranslatorLanguages (LanguageID)

CREATE INDEX Webinars_LecturerID ON Webinars (LecturerID)
CREATE INDEX Webinars_TranslatorID ON Webinars (TranslatorID)	
CREATE INDEX Webinars_LanguageID ON Webinars (LanguageID)

CREATE INDEX WebinarDetails_WebinarID ON WebinarDetails (WebinarID)	
CREATE INDEX WebinarDetails_StudentID ON WebinarDetails (StudentID)

CREATE INDEX Courses_CourseTypeID ON Courses (CourseTypeID)

CREATE INDEX CourseModules_CourseID ON CourseModules (CourseID)
CREATE INDEX CourseModules_LecturerID ON CourseModules (LecturerID)
CREATE INDEX CourseModules_LanguageID ON CourseModules (LanguageID)
CREATE INDEX CourseModules_TranslatorID ON CourseModules (TranslatorID)

CREATE INDEX CourseModulesDetails_ModuleID ON CourseModulesDetails (ModuleID)
CREATE INDEX CourseModulesDetails_StudentID ON CourseModulesDetails (StudentID)

CREATE INDEX OnlineAsyncModules_ModuleID ON OnlineAsyncModules (ModuleID)

CREATE INDEX OnlineSyncModules_ModuleID ON OnlineSyncModules (ModuleID)

CREATE INDEX OnsiteModules_ModuleID ON OnsiteModules (ModuleID)
CREATE INDEX OnsiteModules_RoomID ON OnsiteModules (RoomID)

CREATE INDEX Orders_StudentID ON Orders (StudentID)

CREATE INDEX OrderDetails_OrderID ON OrderDetails (OrderID)
CREATE INDEX OrderDetails_ActivityID ON OrderDetails (ActivityID)

CREATE INDEX ShoppingCart_StudentID ON ShoppingCart (StudentID)
CREATE INDEX ShoppingCart_ActivityID ON ShoppingCart (ActivityID)

CREATE INDEX Subjects_StudiesID ON Subjects (StudiesID)
CREATE INDEX Subjects_LecturerID ON Subjects (LecturerID)

CREATE INDEX Internships_SupervisorID ON Internships (SupervisorID)
CREATE INDEX Internships_StudiesID ON Internships (StudiesID)

CREATE INDEX StudiesMeetings_ActivityID ON StudiesMeetings (ActivityID)
CREATE INDEX StudiesMeetings_SubjectID ON StudiesMeetings (SubjectID)
CREATE INDEX StudiesMeetings_LanguageID ON StudiesMeetings (LanguageID)
CREATE INDEX StudiesMeetings_TranslatorID ON StudiesMeetings (TranslatorID)

CREATE INDEX OnlineAsyncMeetings_MeetingID ON OnlineAsyncMeetings (MeetingID)

CREATE INDEX OnlineSyncMeetings_MeetingID ON OnlineSyncMeetings (MeetingID)

CREATE INDEX OnsiteMeetings_MeetingID ON OnsiteMeetings (MeetingID)
CREATE INDEX OnsiteMeetings_RoomID ON OnsiteMeetings (RoomID)