## Opisy tabel

### Kursy

#### Courses
Zawiera podstawowe informacje o kursach.

- **CourseID** `int` - klucz główny, identyfikator kursu
- **CourseName** `nvarchar(128)` - nazwa kursu
- **CourseDescription** `nvarchar(512)` - opis kursu
- **CourseTypeID** `int` - klucz obcy, identyfikator typu kursu
- **AdvancePrice** `money` - kwota wymaganej zaliczki przy zakupie kursu
  - `null` jeśli nie jest wymagana zaliczka
  - warunek: `AdvancePrice >= 0`

```sql
CREATE TABLE Courses (
   CourseID int NOT NULL,
   CourseName nvarchar(128) NOT NULL,
   CourseDescription nvarchar(512) NOT NULL,
   CourseTypeID int NOT NULL,
   AdvancePrice money NULL CHECK (AdvancePrice >= 0),
   CONSTRAINT Courses_pk PRIMARY KEY (CourseID)
);

ALTER TABLE Courses ADD CONSTRAINT Courses_Activities 
 FOREIGN KEY (CourseID) 
 REFERENCES Activities (ActivityID);

ALTER TABLE Courses ADD CONSTRAINT Courses_CourseTypes 
 FOREIGN KEY (CourseTypeID) 
 REFERENCES CourseTypes (CourseTypeID);
```

#### CourseTypes
Przechowuje dostępne typy kursów.

- **CourseTypeID** `int` - klucz główny, identyfikator typu kursu
- **CourseType** `nvarchar(64)` - nazwa typu kursu

```sql
CREATE TABLE CourseTypes (
   CourseTypeID int NOT NULL,
   CourseType nvarchar(64) NOT NULL,
   CONSTRAINT CourseTypes_pk PRIMARY KEY (CourseTypeID)
);
```

#### CourseModules
Zawiera podstawowe informacje o modułach kursów.

- **ModuleID** `int` - klucz główny, identyfikator modułu
- **ModuleName** `nvarchar(128)` - nazwa modułu
- **Date** `datetime` - data odbycia się modułu
  - warunek: `Date >= '2000-01-01'`
- **CourseID** `int` - klucz obcy, identyfikator kursu, w ramach którego odbywa się moduł
- **LecturerID** `int` - klucz obcy, identyfikator prowadzącego moduł
- **LanguageID** `int` - klucz obcy, identyfikator języka, w którym będzie odbywał się moduł
- **TranslatorID** `int` nullable - klucz obcy, identyfikator tłumacza
  - `null` jeśli nie jest potrzebne tłumaczenie

```sql
CREATE TABLE CourseModules (
   ModuleID int NOT NULL,
   ModuleName nvarchar(128) NOT NULL,
   Date datetime NOT NULL CHECK (Date >= '2000-01-01'),
   CourseID int NOT NULL,
   LecturerID int NOT NULL,
   LanguageID int NOT NULL,
   TranslatorID int NULL,
   CONSTRAINT CourseModules_pk PRIMARY KEY (ModuleID)
);

ALTER TABLE CourseModules ADD CONSTRAINT CourseModules_AvailableLanguages 
 FOREIGN KEY (LanguageID) 
 REFERENCES AvailableLanguages (LanguageID);

ALTER TABLE CourseModules ADD CONSTRAINT CourseModules_Courses 
 FOREIGN KEY (CourseID) 
 REFERENCES Courses (CourseID);

ALTER TABLE CourseModules ADD CONSTRAINT CourseModules_Lecturers 
 FOREIGN KEY (LecturerID) 
 REFERENCES Lecturers (LecturerID);

ALTER TABLE CourseModules ADD CONSTRAINT CourseModules_Translators 
 FOREIGN KEY (TranslatorID) 
 REFERENCES Translators (TranslatorID);
```

#### CourseModuleDetails
Zawiera szczegółowe informacje na temat uczestnictwa w modułach.

- **ModuleID** `int` - klucz główny, klucz obcy, identyfikator modułu
- **StudentID** `int` - klucz główny, klucz obcy, użytkownik, który ma dostęp do modułu
- **PassedDate** `datetime` - data zaliczenia modułu
  - `null` jeśli użytkownik jeszcze nie zaliczył modułu
  - warunek: `PassedDate >= '2000-01-01'`

```sql
CREATE TABLE CourseModulesDetails (
   ModuleID int NOT NULL,
   StudentID int NOT NULL,
   PassedDate datetime NULL CHECK (PassedDate >= '2000-01-01'),
   CONSTRAINT CourseModulesDetails_pk PRIMARY KEY (ModuleID, StudentID)
);

ALTER TABLE CourseModulesDetails ADD CONSTRAINT CourseModulesDetails_CourseModules 
 FOREIGN KEY (ModuleID) 
 REFERENCES CourseModules (ModuleID);

ALTER TABLE CourseModulesDetails ADD CONSTRAINT CourseModulesDetails_Students 
 FOREIGN KEY (StudentID) 
 REFERENCES Students (StudentID);
```

#### OnlineAsyncModules
Zawiera szczegółowe informacje o zdalnych, asynchronicznie prowadzonych modułach.

- **ModuleID** `int` - klucz główny, klucz obcy, identyfikator modułu
- **RecordingLink** `varchar(128)` - link do nagrania spotkania

```sql
CREATE TABLE OnlineAsyncModule (
   ModuleID int  NOT NULL,
   RecordingLink varchar(128)  NOT NULL,
   CONSTRAINT OnlineAsyncModule_pk PRIMARY KEY  (ModuleID)
);

ALTER TABLE OnlineAsyncModules ADD CONSTRAINT OnlineAsyncModule_CourseModules
	FOREIGN KEY (ModuleID)
	REFERENCES CourseModules (ModuleID);
```

#### OnlineSyncModules
Zawiera szczegółowe informacje o zdalnych, synchronicznie prowadzonych modułach.

- **ModuleID** `int` - klucz główny, klucz obcy, identyfikator modułu
- **MeetingLink** `varchar(128)` - link do spotkania na żywo

```sql
CREATE TABLE OnlineSyncModule (
   ModuleID int  NOT NULL,
   MeetingLink varchar(128)  NOT NULL,
   CONSTRAINT OnlineSyncModule_pk PRIMARY KEY  (ModuleID)
);

ALTER TABLE OnlineSyncModules ADD CONSTRAINT OnlineSyncModule_CourseModules
	FOREIGN KEY (ModuleID)
	REFERENCES CourseModules (ModuleID);
```

#### OnsiteModules
Zawiera szczegółowe informacje o stacjonarnie prowadzonych modułach.

- **ModuleID** `int` - klucz klucz obcy, główny, identyfikator modułu
- **ClassLimit** `int` - limit osób, które mogą uczestniczyć w module
    - warunek: `ClassLimit >= 0`
- **RoomID** `int` - klucz obcy, identyfikator pomieszczenia, w którym odbędzie się spotkanie

```sql
CREATE TABLE OnsiteModules (
   ModuleID int  NOT NULL,
   ClassLimit int  NOT NULL CHECK (ClassLimit >= 0),
   RoomID int  NOT NULL,
   CONSTRAINT OnsiteModules_pk PRIMARY KEY  (ModuleID)
);

ALTER TABLE OnsiteModules ADD CONSTRAINT StationaryModule_CourseModules
	FOREIGN KEY (ModuleID)
	REFERENCES CourseModules (ModuleID);

ALTER TABLE OnsiteModules ADD CONSTRAINT StationaryModule_Rooms
	FOREIGN KEY (RoomID)
	REFERENCES Rooms (RoomID);
```