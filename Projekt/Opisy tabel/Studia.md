## Opisy tabel

### Studia

#### Studies
Zawiera podstawowe informacje o studiach.

- **StudiesID** `int` - klucz główny, klucz obcy, identyfikator studiów
- **StudiesName** `nvarchar(128)` - nazwa studiów
- **StudiesDescription** `nvarchar(512)` - opis studiów
- **ClassLimit** `int` - limit miejsc na studiach
    - warunek: `ClassLimit >= 0`
- **EntryFee** `money` - wpisowe na studia
    - warunek: `EntryFee >= 0`

```sql
CREATE TABLE Studies (
   StudiesID int  NOT NULL,
   StudiesName nvarchar(128)  NOT NULL,
   StudiesDescription nvarchar(512)  NOT NULL,
   ClassLimit int  NOT NULL CHECK (ClassLimit >= 0),
   EntryFee money  NOT NULL CHECK (EntryFee >= 0),
   CONSTRAINT Studies_pk PRIMARY KEY  (StudiesID)
);

ALTER TABLE Studies ADD CONSTRAINT Studies_Activities 
 FOREIGN KEY (StudiesID) 
 REFERENCES Activities (ActivityID);
```

#### Subjects
Zawiera podstawowe informacje o przedmiotach na danych studiach.

- **SubjectID** `int` - klucz główny, identyfikator przedmiotu
- **StudiesID** `int` - klucz obcy, identyfikator studiów
- **LecturerID** `int` - klucz obcy, identyfikator prowadzącego zajęcia
- **SubjectName** `nvarchar(64)` - nazwa przedmiotu
- **SubjectDescription** `nvarchar(512)` - opis przedmiotu

```sql
CREATE TABLE Subjects (
   SubjectID int  NOT NULL,
   StudiesID int  NOT NULL,
   LecturerID int  NOT NULL,
   SubjectName nvarchar(64)  NOT NULL,
   SubjectDescription nvarchar(512)  NOT NULL,
   CONSTRAINT Subjects_pk PRIMARY KEY  (SubjectID)
);

ALTER TABLE Subjects ADD CONSTRAINT Subjects_Lecturers 
 FOREIGN KEY (LecturerID) 
 REFERENCES Lecturers (LecturerID);

ALTER TABLE Subjects ADD CONSTRAINT Subjects_Studies 
 FOREIGN KEY (StudiesID) 
 REFERENCES Studies (StudiesID);
```

#### SubjectDetails
Zawiera szczegółowe informacje o przedmiotach na danych studiach.

- **SubjectID** `int` - klucz główny, klucz obcy, identyfikator przedmiotu
- **StudiesID** `int` - klucz główny, klucz obcy, identyfikator studiów
- **isPassed** `bit` - informacja o tym, czy student zdał przedmiot
    - wartość domyślna: `0` (jeszcze się nie odbyły)


```sql
CREATE TABLE SubjectDetails (
   SubjectID int  NOT NULL,
   StudentID int  NOT NULL,
   isPassed bit  NOT NULL DEFAULT 0,
   CONSTRAINT SubjectDetails_pk PRIMARY KEY  (SubjectID,StudentID)
);

ALTER TABLE SubjectDetails ADD CONSTRAINT SubjectDetails_Students 
 FOREIGN KEY (StudentID) 
 REFERENCES Students (StudentID);

ALTER TABLE SubjectDetails ADD CONSTRAINT SubjectDetails_Subjects 
 FOREIGN KEY (SubjectID) 
 REFERENCES Subjects (SubjectID);
```

#### StudiesMeetings
Zawiera podstawowe informacje o zajęciach na studiach.

- **MeetingID** `int` - klucz główny, identyfikator zajęć
- **ActivityID** `int` - klucz obcy, identyfikator aktywności
- **SubjectID** `int` - klucz obcy, identyfikator przedmiotu
- **LanguageID** `int` - klucz obcy, identyfikator języka, w którym będą odbywały się zajęcia
- **MeetingDate** `datetime` - data odbycia się zajęć
    - warunek: `MeetingDate >= ‘2000-01-01’`
- **TranslatorID** `int` - klucz obcy, identyfikator tłumacza
    - `null` jeśli nie jest potrzebne tłumaczenie
- **DiscountPrice** `money` - cena po zniżce dla uczestników studiów
    - warunek: `DiscountPrice >= 0`


```sql
CREATE TABLE StudiesMeetings (
   MeetingID int  NOT NULL,
   ActivityID int  NOT NULL,
   SubjectID int  NOT NULL,
   LanguageID int  NOT NULL,
   MeetingDate datetime  NOT NULL CHECK (MeetingDate >= '2000-01-01'),
   TranslatorID int  NULL,
   DiscountPrice money  NULL DEFAULT NULL CHECK (DiscountPrice >= 0),
   CONSTRAINT StudiesMeetings_pk PRIMARY KEY  (MeetingID)
);

ALTER TABLE StudiesMeetings ADD CONSTRAINT StudiesMeetings_Activities 
 FOREIGN KEY (ActivityID) 
 REFERENCES Activities (ActivityID);

ALTER TABLE StudiesMeetings ADD CONSTRAINT StudiesMeetings_AvailableLanguages 
 FOREIGN KEY (LanguageID) 
 REFERENCES AvailableLanguages (LanguageID);

ALTER TABLE StudiesMeetings ADD CONSTRAINT StudiesMeetings_Subjects 
 FOREIGN KEY (SubjectID) 
 REFERENCES Subjects (SubjectID);

ALTER TABLE StudiesMeetings ADD CONSTRAINT StudiesMeetings_Translators 
 FOREIGN KEY (TranslatorID) 
 REFERENCES Translators (TranslatorID);
```

#### StudiesMeetingsDetails
Zawiera szczegółowe informacje o zajęciach na studiach.

- **MeetingID** `int` - klucz główny, klucz obcy, identyfikator zajęć
- **StudentID** `int` - klucz główny, klucz obcy, identyfikator studenta
- **PassedDate** `datetime` - data zaliczenia spotkania
    - `null` jeśli użytkownik jeszcze nie zaliczył zajęć
    - warunek: `PassedDate >= ‘2000-01-01’`

```sql
CREATE TABLE StudiesMeetingsDetails (
   MeetingID int  NOT NULL,
   StudentID int  NOT NULL,
   PassedDate datetime  NULL CHECK (PassedDate >= '2000-01-01'),
   CONSTRAINT StudiesMeetingsDetails_pk PRIMARY KEY  (MeetingID,StudentID)
);

ALTER TABLE StudiesMeetingsDetails ADD CONSTRAINT StudiesMeetingsDetails_Students 
 FOREIGN KEY (StudentID) 
 REFERENCES Students (StudentID);

ALTER TABLE StudiesMeetingsDetails ADD CONSTRAINT StudiesMeetingsDetails_StudiesMeetings 
 FOREIGN KEY (MeetingID) 
 REFERENCES StudiesMeetings (MeetingID);
```

#### OnlineAsyncMeetings
Zawiera szczegółowe informacje o zdalnych, asynchronicznie prowadzonych zajęciach.

- **MeetingID** `int` - klucz główny, klucz obcy, identyfikator zajęć
- **RecordingLink** `varchar(128)` - link do nagrania spotkania

```sql
CREATE TABLE OnlineAsyncMeetings (
   MeetingID int  NOT NULL,
   RecordingLink varchar(128)  NOT NULL,
   CONSTRAINT OnlineAsyncMeetings_pk PRIMARY KEY  (MeetingID)
);

ALTER TABLE OnlineAsyncMeetings ADD CONSTRAINT OnlineAsyncMeeting_StudiesMeetings
	FOREIGN KEY (MeetingID)
	REFERENCES StudiesMeetings (MeetingID);
```

#### OnlineSyncMeetings
Zawiera szczegółowe informacje o zdalnych, synchronicznie prowadzonych zajęciach.

- **MeetingID** `int` - klucz główny, klucz obcy, identyfikator zajęć
- **MeetingLink** `varchar(128)` - link do spotkania na żywo

```sql
CREATE TABLE OnlineSyncMeetings (
   MeetingID int  NOT NULL,
   MeetingLink varchar(128)  NOT NULL,
   CONSTRAINT OnlineSyncMeetings_pk PRIMARY KEY  (MeetingID)
);

ALTER TABLE OnlineSyncMeetings ADD CONSTRAINT OnlineSyncMeeting_StudiesMeetings
	FOREIGN KEY (MeetingID)
	REFERENCES StudiesMeetings (MeetingID);
```

#### OnsiteMeetings
Zawiera szczegółowe informacje o stacjonarnie prowadzonych zajęciach.

- **MeetingID** `int` - klucz główny, klucz obcy, identyfikator modułu
- **ClassLimit** `int` - limit osób, które mogą uczestniczyć w zajęciach
    - warunek: `ClassLimit >= 0`
- **RoomID** `int` - klucz obcy, identyfikator pomieszczenia, w którym odbędą się zajęcia

```sql
CREATE TABLE OnsiteMeetings (
   MeetingID int  NOT NULL,
   ClassLimit int  NOT NULL CHECK (ClassLimit >= 0),
   RoomID int  NOT NULL,
   CONSTRAINT OnsiteMeetings_pk PRIMARY KEY  (MeetingID)
);

ALTER TABLE OnsiteMeetings ADD CONSTRAINT StationaryMeeting_Rooms
	FOREIGN KEY (RoomID)
	REFERENCES Rooms (RoomID);

ALTER TABLE OnsiteMeetings ADD CONSTRAINT StationaryMeeting_StudiesMeetings
	FOREIGN KEY (MeetingID)
	REFERENCES StudiesMeetings (MeetingID);
```

#### Internships
Zawiera podstawowe informacje o praktykach.

- **InternshipID** `int` - klucz główny, identyfikator praktyk
- **SupervisorID** `int` - klucz obcy, identyfikator prowadzącego praktyki
- **StudiesID** `int` - klucz obcy, identyfikator studiów
- **StartDate** `date` - data rozpoczęcia praktyk
    - warunek: `StartDate >= ‘2000-01-01’`

```sql
CREATE TABLE Internships (
   InternshipID int  NOT NULL,
   SupervisorID int  NOT NULL,
   StudiesID int  NOT NULL,
   StartDate date  NOT NULL CHECK (StartDate >= '2000-01-01'),
   CONSTRAINT Internships_pk PRIMARY KEY  (InternshipID)
);

ALTER TABLE Internships ADD CONSTRAINT Internships_InternshipSupervisors
	FOREIGN KEY (SupervisorID)
	REFERENCES InternshipSupervisors (SupervisorID);

ALTER TABLE Internships ADD CONSTRAINT Internships_Studies
	FOREIGN KEY (StudiesID)
	REFERENCES Studies (StudiesID);
```

#### InternshipDetails
Zawiera szczegółowe informacje o praktykach.

- **InternshipID** `int` - klucz główny, klucz obcy, identyfikator praktyk
- **StudentID** `int` - klucz główny, klucz obcy, identyfikator studenta
- **isPassed** `bit` - informacja o tym, czy student zdał praktyki
    - wartość domyślna: `0` (jeszcze się nie odbyły)

```sql
CREATE TABLE InternshipDetails (
   InternshipID int  NOT NULL,
   StudentID int  NOT NULL,
   isPassed bit  NOT NULL DEFAULT 0,
   CONSTRAINT InternshipDetails_pk PRIMARY KEY  (InternshipID,StudentID)
);

ALTER TABLE InternshipDetails ADD CONSTRAINT InternshipDetails_Internships
	FOREIGN KEY (InternshipID)
	REFERENCES Internships (InternshipID);

ALTER TABLE InternshipDetails ADD CONSTRAINT InternshipDetails_Students
	FOREIGN KEY (StudentID)
	REFERENCES Students (StudentID);
```