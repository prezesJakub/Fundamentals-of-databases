## Opisy tabel

### Użytkownicy

#### Users
Zawiera podstawowe informacje o wszystkich użytkownikach bazy danych.

- **UserID** `int` - klucz główny, identyfikator użytkownika
- **FirstName** `nvarchar(64)` - imię użytkownika
- **LastName** `nvarchar(64)` - nazwisko użytkownika
- **CityID** `int` - klucz obcy, identyfikator miasta, z którego pochodzi użytkownik
- **Address** `nvarchar(256)` - adres użytkownika zawierający nazwę ulicy, numer domu i kod pocztowy
- **Phone** `nvarchar(64)` - numer telefonu użytkownika
- **Email** `nvarchar(64)` unique - adres e-mail użytkownika
    - warunek: `Email LIKE '%_@_%._%'`

```sql
CREATE TABLE Users (
   UserID int  NOT NULL,
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

ALTER TABLE Users ADD CONSTRAINT Users_Cities 
 FOREIGN KEY (CityID) 
 REFERENCES Cities (CityID);
```

#### Students
Przechowuje wszystkich użytkowników będących studentami.

- **StudentID** `int` - klucz główny, identyfikator studenta

```sql
CREATE TABLE Students (
   StudentID int  NOT NULL,
   CONSTRAINT Students_pk PRIMARY KEY  (StudentID)
);

ALTER TABLE Students ADD CONSTRAINT Students_Users 
 FOREIGN KEY (StudentID) 
 REFERENCES Users (UserID);
```

#### Lecturers
Przechowuje wszystkich użytkowników będących wykładowcami.

- **LecturerID** `int` - klucz główny, klucz obcy, identyfikator wykładowcy

```sql
CREATE TABLE Lecturers (
   LecturerID int  NOT NULL,
   CONSTRAINT Lecturers_pk PRIMARY KEY  (LecturerID)
);

ALTER TABLE Lecturers ADD CONSTRAINT Lecturers_Users 
 FOREIGN KEY (LecturerID) 
 REFERENCES Users (UserID);
```

#### Administrators
Przechowuje wszystkich użytkowników będących administratorami.

- **AdministratorID** `int` - klucz główny, klucz obcy, identyfikator administratora

```sql
CREATE TABLE Administrators (
   AdministratorID int  NOT NULL,
   CONSTRAINT Administrators_pk PRIMARY KEY  (AdministratorID)
);

ALTER TABLE Administrators ADD CONSTRAINT Administrators_Users 
 FOREIGN KEY (AdministratorID) 
 REFERENCES Users (UserID);
```

#### SecretaryWorkers
Przechowuje wszystkich użytkowników będących pracownikami sekretariatu.

- **SecretaryID** `int` - klucz główny, klucz obcy, identyfikator pracownika sekretariatu

```sql
CREATE TABLE SecretaryWorkers (
   SecretaryID int  NOT NULL,
   CONSTRAINT SecretaryWorkers_pk PRIMARY KEY  (SecretaryID)
);

ALTER TABLE SecretaryWorkers ADD CONSTRAINT SecretaryWorkers_Users 
 FOREIGN KEY (SecretaryID) 
 REFERENCES Users (UserID);
```

#### Directors
Przechowuje wszystkich użytkowników będących dyrektorami.

- **DirectorID** `int` - klucz główny, klucz obcy, identyfikator dyrektora

```sql
CREATE TABLE Directors (
   DirectorID int  NOT NULL,
   CONSTRAINT Directors_pk PRIMARY KEY  (DirectorID)
);

ALTER TABLE Directors ADD CONSTRAINT Directors_Users 
 FOREIGN KEY (DirectorID) 
 REFERENCES Users (UserID);
```

#### InternshipSupervisors
Przechowuje wszystkich użytkowników będących prowadzącymi praktyki.

- **SupervisorID** `int` - klucz główny, klucz obcy, identyfikator prowadzącego praktyki

```sql
CREATE TABLE InternshipSupervisors (
   SupervisorID int  NOT NULL,
   CONSTRAINT InternshipSupervisors_pk PRIMARY KEY  (SupervisorID)
);

ALTER TABLE InternshipSupervisors ADD CONSTRAINT 
InternshipSupervisors_Users 
 FOREIGN KEY (SupervisorID) 
 REFERENCES Users (UserID);
```

#### Translators
Przechowuje wszystkich użytkowników będących tłumaczami.

- **TranslatorID** `int` - klucz główny, klucz obcy, identyfikator tłumacza

```sql
CREATE TABLE Translators (
   TranslatorID int  NOT NULL,
   CONSTRAINT Translators_pk PRIMARY KEY  (TranslatorID)
);

ALTER TABLE Translators ADD CONSTRAINT Translators_Users 
 FOREIGN KEY (TranslatorID) 
 REFERENCES Users (UserID);
```

#### TranslatorLanguages
Zawiera informacje o tłumaczach i językach, które potrafią tłumaczyć.

- **TranslatorID** `int` - klucz główny, klucz obcy, identyfikator tłumacza
- **LanguageID** `int` - klucz główny, klucz obcy, identyfikator języka

```sql
CREATE TABLE TranslatorLanguages (
   TranslatorID int  NOT NULL,
   LanguageID int  NOT NULL,
   CONSTRAINT TranslatorLanguages_pk PRIMARY KEY  (TranslatorID,LanguageID)
);

ALTER TABLE TranslatorLanguages ADD CONSTRAINT 
TranslatorLanguages_AvailableLanguages 
 FOREIGN KEY (LanguageID) 
 REFERENCES AvailableLanguages (LanguageID);

ALTER TABLE TranslatorLanguages ADD CONSTRAINT 
TranslatorLanguages_Translators 
 FOREIGN KEY (TranslatorID) 
 REFERENCES Translators (TranslatorID);
```

#### AvailableLanguages
Zawiera informacje o tłumaczonych językach.

- **LanguageID** `int` - klucz główny, identyfikator języka
- **LanguageName** `nvarchar(64)` - nazwa języka

```sql
CREATE TABLE AvailableLanguages (
   LanguageID int  NOT NULL,
   LanguageName nvarchar(64)  NOT NULL,
   CONSTRAINT AvailableLanguages_pk PRIMARY KEY  (LanguageID)
);
```

#### Countries
Zawiera informacje o państwach.

- **CountryID** `int` - klucz główny, identyfikator kraju
- **Country** `nvarchar(128)` - nazwa kraju

```sql
CREATE TABLE Countries (
   CountryID int  NOT NULL,
   Country nvarchar(128)  NOT NULL,
   CONSTRAINT Countries_pk PRIMARY KEY  (CountryID)
);
```

#### Cities
Zawiera informacje o miastach.

- **CityID** `int` - klucz główny, identyfikator miasta
- **CountryID** `int` - klucz obcy, identyfikator kraju
- **City** `nvarchar(128)` - nazwa miasta, z którego pochodzi użytkownik

```sql
CREATE TABLE Cities (
   CityID int  NOT NULL,
   CountryID int  NOT NULL,
   City nvarchar(128)  NOT NULL,
   CONSTRAINT Cities_pk PRIMARY KEY  (CityID,CountryID)
);

ALTER TABLE Cities ADD CONSTRAINT Cities_Countries 
 FOREIGN KEY (CountryID) 
 REFERENCES Countries (CountryID);
```