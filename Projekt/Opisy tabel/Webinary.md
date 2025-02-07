## Opisy tabel

### Webinary

#### Webinars
Zawiera podstawowe informacje o webinarach.

- **WebinarID** `int` - klucz główny, identyfikator webinaru
- **WebinarName** `nvarchar(128)` - nazwa webinaru
- **WebinarDate** `datetime` - data odbycia webinaru
  - warunek: `WebinarDate >= '2000-01-01'`
- **LecturerID** `int` - klucz obcy, identyfikator prowadzącego webinar
- **TranslatorID** `int` - klucz obcy, identyfikator tłumacza
  - null jeżeli nie trzeba tłumaczyć webinaru
- **LanguageID** `int` - klucz obcy, identyfikator języka, w którym będzie odbywał się webinar
- **Link** `varchar(128)` - link do webinaru

```sql
CREATE TABLE Webinars (
   WebinarID int NOT NULL,
   WebinarName nvarchar(128) NOT NULL,
   WebinarDate datetime NOT NULL CHECK (WebinarDate >= '2000-01-01'),
   LanguageID int NOT NULL,
   LecturerID int NOT NULL,
   TranslatorID int NULL,
   Link varchar(128) NOT NULL,
   CONSTRAINT Webinars_pk PRIMARY KEY (WebinarID)
);

ALTER TABLE Webinars ADD CONSTRAINT Webinars_Activities 
 FOREIGN KEY (WebinarID) 
 REFERENCES Activities (ActivityID);

ALTER TABLE Webinars ADD CONSTRAINT Webinars_AvailableLanguages 
 FOREIGN KEY (LanguageID) 
 REFERENCES AvailableLanguages (LanguageID);

ALTER TABLE Webinars ADD CONSTRAINT Webinars_Lecturers 
 FOREIGN KEY (LecturerID) 
 REFERENCES Lecturers (LecturerID);

ALTER TABLE Webinars ADD CONSTRAINT Webinars_Translators 
 FOREIGN KEY (TranslatorID) 
 REFERENCES Translators (TranslatorID);
```

#### WebinarDetails
Zawiera szczegółowe informacje na temat uczestnictwa w webinarach.

- **WebinarID** `int` - klucz główny, klucz obcy, identyfikator webinaru
- **StudentID** `int` - klucz główny, klucz obcy, identyfikator użytkownika mającego dostęp do webinaru
- **DueDate** `datetime` - data, do której użytkownik będzie miał dostęp do nagrania webinaru
  - warunek: `DueDate >= '2000-01-01'`

```sql
CREATE TABLE WebinarDetails (
   WebinarID int NOT NULL,
   StudentID int NOT NULL,
   DueDate datetime NOT NULL CHECK (DueDate >= '2000-01-01'),
   CONSTRAINT WebinarDetails_pk PRIMARY KEY (WebinarID, StudentID)
);

ALTER TABLE WebinarDetails ADD CONSTRAINT WebinarDetails_Students 
 FOREIGN KEY (StudentID) 
 REFERENCES Students (StudentID);

ALTER TABLE WebinarDetails ADD CONSTRAINT WebinarDetails_Webinars 
 FOREIGN KEY (WebinarID) 
 REFERENCES Webinars (WebinarID);
```