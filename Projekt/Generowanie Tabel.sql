-- Table: Activities
CREATE TABLE Activities (
    ActivityID int  NOT NULL IDENTITY,
    FullPrice money  NULL,
    isAvailable bit  NOT NULL DEFAULT 1,
    CONSTRAINT Activities_pk PRIMARY KEY  (ActivityID)
);

-- Table: Administrators
CREATE TABLE Administrators (
    AdministratorID int  NOT NULL,
    CONSTRAINT Administrators_pk PRIMARY KEY  (AdministratorID)
);

-- Table: AvailableLanguages
CREATE TABLE AvailableLanguages (
    LanguageID int  NOT NULL IDENTITY,
    LanguageName nvarchar(64)  NOT NULL,
    CONSTRAINT AvailableLanguages_pk PRIMARY KEY  (LanguageID)
);

-- Table: Cities
CREATE TABLE Cities (
    CityID int  NOT NULL IDENTITY,
    CountryID int  NOT NULL,
    City nvarchar(128)  NOT NULL,
    CONSTRAINT Cities_pk PRIMARY KEY  (CityID)
);

-- Table: Countries
CREATE TABLE Countries (
    Country nvarchar(128)  NOT NULL,
    CountryID int  NOT NULL IDENTITY,
    CONSTRAINT Countries_pk PRIMARY KEY  (CountryID)
);

-- Table: CourseModules
CREATE TABLE CourseModules (
    ModuleID int  NOT NULL IDENTITY,
    ModuleName nvarchar(128)  NOT NULL,
    Date datetime  NOT NULL,
    CourseID int  NOT NULL,
    LecturerID int  NOT NULL,
    LanguageID int  NOT NULL,
    TranslatorID int  NULL,
    CONSTRAINT CourseModules_pk PRIMARY KEY  (ModuleID)
);

-- Table: CourseModulesDetails
CREATE TABLE CourseModulesDetails (
    ModuleID int  NOT NULL,
    StudentID int  NOT NULL,
    PassedDate datetime  NULL,
    CONSTRAINT CourseModulesDetails_pk PRIMARY KEY  (ModuleID,StudentID)
);

-- Table: CourseTypes
CREATE TABLE CourseTypes (
    CourseTypeID int  NOT NULL IDENTITY,
    CourseType nvarchar(64)  NOT NULL,
    CONSTRAINT CourseTypes_pk PRIMARY KEY  (CourseTypeID)
);

-- Table: Courses
CREATE TABLE Courses (
    CourseID int  NOT NULL,
    CourseName nvarchar(128)  NOT NULL,
    CourseDescription nvarchar(512)  NOT NULL,
    CourseTypeID int  NOT NULL,
    AdvancePrice money  NULL,
    CONSTRAINT Courses_pk PRIMARY KEY  (CourseID)
);

-- Table: Directors
CREATE TABLE Directors (
    DirectorID int  NOT NULL,
    CONSTRAINT Directors_pk PRIMARY KEY  (DirectorID)
);

-- Table: InternshipDetails
CREATE TABLE InternshipDetails (
    InternshipID int  NOT NULL,
    StudentID int  NOT NULL,
    isPassed bit  NOT NULL DEFAULT 0,
    CONSTRAINT InternshipDetails_pk PRIMARY KEY  (InternshipID,StudentID)
);

-- Table: InternshipSupervisors
CREATE TABLE InternshipSupervisors (
    SupervisorID int  NOT NULL,
    CONSTRAINT InternshipSupervisors_pk PRIMARY KEY  (SupervisorID)
);

-- Table: Internships
CREATE TABLE Internships (
    InternshipID int  NOT NULL IDENTITY,
    SupervisorID int  NOT NULL,
    StudiesID int  NOT NULL,
    StartDate date  NOT NULL,
    CONSTRAINT Internships_pk PRIMARY KEY  (InternshipID)
);

-- Table: Lecturers
CREATE TABLE Lecturers (
    LecturerID int  NOT NULL,
    CONSTRAINT Lecturers_pk PRIMARY KEY  (LecturerID)
);

-- Table: OnlineAsyncMeetings
CREATE TABLE OnlineAsyncMeetings (
    MeetingID int  NOT NULL,
    RecordingLink varchar(128)  NOT NULL,
    CONSTRAINT OnlineAsyncMeetings_pk PRIMARY KEY  (MeetingID)
);

-- Table: OnlineAsyncModules
CREATE TABLE OnlineAsyncModules (
    ModuleID int  NOT NULL,
    RecordingLink varchar(128)  NOT NULL,
    CONSTRAINT OnlineAsyncModules_pk PRIMARY KEY  (ModuleID)
);

-- Table: OnlineSyncMeetings
CREATE TABLE OnlineSyncMeetings (
    MeetingID int  NOT NULL,
    MeetingLink varchar(128)  NOT NULL,
    CONSTRAINT OnlineSyncMeetings_pk PRIMARY KEY  (MeetingID)
);

-- Table: OnlineSyncModules
CREATE TABLE OnlineSyncModules (
    ModuleID int  NOT NULL,
    MeetingLink varchar(128)  NOT NULL,
    CONSTRAINT OnlineSyncModules_pk PRIMARY KEY  (ModuleID)
);

-- Table: OnsiteMeetings
CREATE TABLE OnsiteMeetings (
    MeetingID int  NOT NULL,
    ClassLimit int  NOT NULL,
    RoomID int  NOT NULL,
    CONSTRAINT OnsiteMeetings_pk PRIMARY KEY  (MeetingID)
);

-- Table: OnsiteModules
CREATE TABLE OnsiteModules (
    ModuleID int  NOT NULL,
    ClassLimit int  NOT NULL,
    RoomID int  NOT NULL,
    CONSTRAINT OnsiteModules_pk PRIMARY KEY  (ModuleID)
);

-- Table: OrderDetails
CREATE TABLE OrderDetails (
    OrderID int  NOT NULL,
    ActivityID int  NOT NULL,
    mustPayInTime bit  NOT NULL DEFAULT 1,
    AmountPaid money  NOT NULL DEFAULT 0 CHECK (AmountPaid >= 0),
    PaidDate datetime  NULL DEFAULT NULL,
    CONSTRAINT OrderDetails_pk PRIMARY KEY  (OrderID,ActivityID)
);

-- Table: Orders
CREATE TABLE Orders (
    OrderID int  NOT NULL IDENTITY,
    StudentID int  NOT NULL,
    OrderDate datetime  NOT NULL,
    CONSTRAINT Orders_pk PRIMARY KEY  (OrderID)
);

-- Table: Rooms
CREATE TABLE Rooms (
    RoomID int  NOT NULL IDENTITY,
    Capacity int  NOT NULL,
    CONSTRAINT Rooms_pk PRIMARY KEY  (RoomID)
);

-- Table: SecretaryWorkers
CREATE TABLE SecretaryWorkers (
    SecretaryID int  NOT NULL,
    CONSTRAINT SecretaryWorkers_pk PRIMARY KEY  (SecretaryID)
);

-- Table: ShoppingCart
CREATE TABLE ShoppingCart (
    StudentID int  NOT NULL,
    ActivityID int  NOT NULL,
    CONSTRAINT ShoppingCart_pk PRIMARY KEY  (StudentID)
);

-- Table: Students
CREATE TABLE Students (
    StudentID int  NOT NULL,
    CONSTRAINT Students_pk PRIMARY KEY  (StudentID)
);

-- Table: Studies
CREATE TABLE Studies (
    StudiesID int  NOT NULL,
    StudiesName nvarchar(128)  NOT NULL,
    StudiesDescription nvarchar(512)  NOT NULL,
    ClassLimit int  NOT NULL,
    EntryFee money  NOT NULL CHECK (EntryFee >= 0),
    CONSTRAINT Studies_pk PRIMARY KEY  (StudiesID)
);

-- Table: StudiesMeetings
CREATE TABLE StudiesMeetings (
    MeetingID int  NOT NULL IDENTITY,
    ActivityID int  NOT NULL,
    SubjectID int  NOT NULL,
    LanguageID int  NOT NULL,
    MeetingDate datetime  NOT NULL,
    TranslatorID int  NULL,
    DiscountPrice money  NOT NULL DEFAULT NULL CHECK (DiscountPrice >= 0),
    CONSTRAINT StudiesMeetings_pk PRIMARY KEY  (MeetingID)
);

-- Table: StudiesMeetingsDetails
CREATE TABLE StudiesMeetingsDetails (
    MeetingID int  NOT NULL,
    StudentID int  NOT NULL,
    PassedDate datetime  NULL,
    CONSTRAINT StudiesMeetingsDetails_pk PRIMARY KEY  (MeetingID,StudentID)
);

-- Table: SubjectDetails
CREATE TABLE SubjectDetails (
    SubjectID int  NOT NULL,
    StudentID int  NOT NULL,
    isPassed bit  NOT NULL DEFAULT 0,
    CONSTRAINT SubjectDetails_pk PRIMARY KEY  (SubjectID,StudentID)
);

-- Table: Subjects
CREATE TABLE Subjects (
    SubjectID int  NOT NULL IDENTITY,
    StudiesID int  NOT NULL,
    LecturerID int  NOT NULL,
    SubjectName nvarchar(64)  NOT NULL,
    SubjectDescription nvarchar(512)  NOT NULL,
    Term int  NULL,
    CONSTRAINT Subjects_pk PRIMARY KEY  (SubjectID)
);

-- Table: TranslatorLanguages
CREATE TABLE TranslatorLanguages (
    TranslatorID int  NOT NULL,
    LanguageID int  NOT NULL,
    CONSTRAINT TranslatorLanguages_pk PRIMARY KEY  (TranslatorID,LanguageID)
);

-- Table: Translators
CREATE TABLE Translators (
    TranslatorID int  NOT NULL,
    CONSTRAINT Translators_pk PRIMARY KEY  (TranslatorID)
);

-- Table: Users
CREATE TABLE Users (
    UserID int  NOT NULL IDENTITY,
    FirstName nvarchar(64)  NOT NULL,
    LastName nvarchar(64)  NOT NULL,
    CityID int  NOT NULL,
    Address nvarchar(256)  NOT NULL,
    Phone nvarchar(64)  NOT NULL,
    Email nvarchar(64)  NOT NULL,
    CONSTRAINT uniqueEmail UNIQUE (Email),
    CONSTRAINT emailFormat CHECK ([email] LIKE '%_@_%._%'),
    CONSTRAINT Users_pk PRIMARY KEY  (UserID)
);

-- Table: WebinarDetails
CREATE TABLE WebinarDetails (
    WebinarID int  NOT NULL,
    StudentID int  NOT NULL,
    DueDate datetime  NOT NULL,
    CONSTRAINT WebinarDetails_pk PRIMARY KEY  (WebinarID,StudentID)
);

-- Table: Webinars
CREATE TABLE Webinars (
    WebinarID int  NOT NULL,
    WebinarName nvarchar(128)  NOT NULL,
    WebinarDate datetime  NOT NULL,
    LecturerID int  NOT NULL,
    TranslatorID int  NULL,
    LanguageID int  NOT NULL,
    Link varchar(128)  NOT NULL,
    CONSTRAINT Webinars_pk PRIMARY KEY  (WebinarID)
);