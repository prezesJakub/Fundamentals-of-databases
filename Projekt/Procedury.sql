--Dodanie nowego zamówienia
CREATE PROCEDURE AddOrder
@StudentID INT
AS
BEGIN
	DECLARE @OrderID INT;

	INSERT INTO Orders (StudentID, OrderDate)
	VALUES (@StudentID, GETDATE());

	SET @OrderID = SCOPE_IDENTITY();

	INSERT INTO OrderDetails (OrderID, ActivityID)
	SELECT @OrderID, ActivityID FROM ShoppingCart
	WHERE StudentID = @StudentID;

	DELETE FROM ShoppingCart
	WHERE StudentID = @StudentID;

END;

--Dodanie przedmiotu do koszyka
CREATE PROCEDURE AddToShoppingCart
@StudentID INT,
@ActivityID INT
AS
BEGIN
	IF NOT EXISTS (
	SELECT 1 FROM ShoppingCart
	WHERE StudentID = @StudentID AND ActivityID = @ActivityID
	)
	BEGIN
		INSERT INTO ShoppingCart(StudentID, ActivityID)
		VALUES (@StudentID, @ActivityID);
	END
END;

--Dodanie nowego webinaru
CREATE PROCEDURE AddWebinar
   @WebinarName NVARCHAR(128),
   @WebinarDate DATETIME,
   @LecturerID INT,
   @TranslatorID INT,
   @LanguageID INT,
   @Link NVARCHAR(128),
   @FullPrice MONEY
AS
BEGIN
   INSERT INTO Activities(FullPrice, isAvailable)
   VALUES (@FullPrice, 1)

   DECLARE @ActivityID INT;
   SET @ActivityID = SCOPE_IDENTITY();

   INSERT INTO Webinars (WebinarID,WebinarName, WebinarDate, LecturerID, TranslatorID, LanguageID, Link)
   VALUES (@ActivityID,@WebinarName, @WebinarDate, @LecturerID, @TranslatorID, @LanguageID, @Link);
END;

--Dodanie nowego kursu
CREATE PROCEDURE AddCourse
   @CourseName NVARCHAR(128),
   @CourseDescription NVARCHAR(512),
   @CourseTypeID INT,
   @AdvancePrice MONEY,
   @FullPrice MONEY
AS
BEGIN
   INSERT INTO Activities(FullPrice, isAvailable)
   VALUES (@FullPrice, 1)

   DECLARE @ActivityID INT;
   SET @ActivityID = SCOPE_IDENTITY();

   INSERT INTO Courses (CourseID,CourseName,CourseDescription,CourseTypeID,AdvancePrice)
   VALUES (@ActivityID,@CourseName, @CourseDescription, @CourseTypeID, @AdvancePrice);
END;

--Dodanie nowego modułu zdalnego do kursu
CREATE PROCEDURE AddCourseModuleOnlineAsync
	@ModuleName NVARCHAR(128),
	@Date DATETIME,
	@CourseID INT,
	@LecturerID INT,
	@LanguageID INT,
	@TranslatorID INT,
	@RecordingLink NVARCHAR(128)
AS
BEGIN
	INSERT INTO CourseModules (ModuleName, Date, CourseID, LecturerID, LanguageID, TranslatorID)
	VALUES (@ModuleName, @Date, @CourseID, @LecturerID, @LanguageID, @TranslatorID);

	DECLARE @LastCourseModuleID INT;
	SET @LastCourseModuleID = SCOPE_IDENTITY();

	INSERT INTO OnlineAsyncModules (ModuleID, RecordingLink)
	VALUES (@LastCourseModuleID, @RecordingLink);
END;

--Dodanie nowego modułu hybrydowego do kursu
CREATE PROCEDURE AddCourseModuleOnlineSync
	@ModuleName NVARCHAR(128),
	@Date DATETIME,
	@CourseID INT,
	@LecturerID INT,
	@LanguageID INT,
	@TranslatorID INT,
	@MeetingLink VARCHAR(128)
AS
BEGIN
	INSERT INTO CourseModules (ModuleName, Date, CourseID, LecturerID, LanguageID, TranslatorID)
	VALUES (@ModuleName, @Date, @CourseID, @LecturerID, @LanguageID, @TranslatorID);

	DECLARE @LastCourseModuleID INT;
	SET @LastCourseModuleID = SCOPE_IDENTITY();

	INSERT INTO OnlineSyncModules (ModuleID, MeetingLink)
	VALUES (@LastCourseModuleID, @MeetingLink);
END;

--Dodanie nowego modułu stacjonarnego do kursu
CREATE PROCEDURE AddCourseModuleOnsite
   @ModuleName NVARCHAR(128),
   @Date DATETIME,
   @CourseID INT,
   @LecturerID INT,
   @LanguageID INT,
   @TranslatorID INT,
   @ClassLimit INT,
   @RoomID INT
AS
BEGIN
   INSERT INTO CourseModules (ModuleName, Date, CourseID, LecturerID, LanguageID, TranslatorID)
   VALUES (@ModuleName, @Date, @CourseID, @LecturerID, @LanguageID, @TranslatorID);

   DECLARE @LastCourseModuleID INT;
   SET @LastCourseModuleID = SCOPE_IDENTITY();

   INSERT INTO OnsiteModules (ModuleID, ClassLimit, RoomID)
   VALUES (@LastCourseModuleID, @ClassLimit, @RoomID);
END;

--Dodanie nowych studiów
CREATE PROCEDURE AddStudies @StudiesName NVARCHAR(128),
                       	@StudiesDescription NVARCHAR(512),
                       	@ClassLimit INT,
                       	@EntryFee MONEY,
                       	@FullPrice MONEY
AS
BEGIN
	INSERT INTO Activities(FullPrice, isAvailable)
	VALUES (@FullPrice, 1)

	DECLARE @ActivityID INT;
	SET @ActivityID = SCOPE_IDENTITY();

	INSERT INTO Studies (StudiesID, StudiesName, StudiesDescription, ClassLimit, EntryFee)
	VALUES (@ActivityID, @StudiesName, @StudiesDescription, @ClassLimit, @EntryFee);
END;

--Dodanie nowego przedmiotu do studiów
CREATE PROCEDURE AddSubject @StudiesID INT,
                        	@LecturerID INT,
                        	@SubjectName NVARCHAR(64),
                        	@SubjectDescription NVARCHAR(512)
AS
BEGIN
	INSERT INTO Subjects (StudiesID, LecturerID, SubjectName, SubjectDescription)
	VALUES (@StudiesID, @LecturerID, @SubjectName, @SubjectDescription);
END;

--Dodanie nowego spotkania do przedmiotu
CREATE PROCEDURE AddStudyMeeting @SubjectID INT,
                             	@LanguageID INT,
                             	@MeetingDate DATETIME,
                             	@TranslatorID INT,
                             	@FullPrice MONEY,
                             	@DiscountPrice MONEY
AS
BEGIN
	INSERT INTO Activities(FullPrice, isAvailable)
	VALUES (@FullPrice, 1)

	DECLARE @MeetingActivityID INT = SCOPE_IDENTITY()

	INSERT INTO StudiesMeetings (ActivityID, SubjectID, LanguageID, MeetingDate, TranslatorID, DiscountPrice)
	VALUES (@MeetingActivityID, @SubjectID, @LanguageID, @MeetingDate, @TranslatorID, @DiscountPrice)

	DECLARE @StudyActivityID INT
	SELECT @StudyActivityID = a.ActivityID
	FROM Activities a
         	INNER JOIN Subjects s ON s.StudiesID = a.ActivityID
	WHERE s.SubjectID = @SubjectID

	UPDATE Activities
	SET FullPrice = FullPrice + @DiscountPrice
	WHERE ActivityID = @StudyActivityID
END
GO

--Dodanie nowego stażu
CREATE PROCEDURE AddInternship @SupervisorID INT,
                             	@StudiesID INT,
                             	@StartDate DATETIME
AS
BEGIN
	INSERT INTO Internships (SupervisorID, StudiesID, StartDate)
	VALUES (@SupervisorID, @StudiesID, @StartDate);
END;

--Dodanie nowego studenta
CREATE PROCEDURE AddNewStudent
@FirstName NVARCHAR(64),
@LastName NVARCHAR(64),
@Country NVARCHAR(128),
@City NVARCHAR(128),
@Address NVARCHAR(256),
@Phone NVARCHAR(64),
@Email NVARCHAR(64)
AS
BEGIN
	DECLARE @CountryID INT, @CityID INT, @UserID INT;

	SELECT @CountryID = CountryID FROM Countries WHERE Country = @Country;

	IF @CountryID IS NULL
	BEGIN
		INSERT INTO Countries(Country)
		VALUES (@Country);

		SET @CountryID = SCOPE_IDENTITY();
	END

	SELECT @CityID = CityID FROM Cities WHERE City = @City AND CountryID = @CountryID;

	IF @CityID IS NULL
	BEGIN
		INSERT INTO Cities(CountryID, City)
		VALUES (@CountryID, @City);

		SET @CityID = SCOPE_IDENTITY();
	END

	INSERT INTO Users(FirstName, LastName, CityID, Address, Phone, Email)
	VALUES (@FirstName, @LastName, @CityID, @Address, @Phone, @Email);

	SET @UserID = SCOPE_IDENTITY();

	INSERT INTO Students (StudentID)
	VALUES(@UserID);
END;

--Dodanie nowego wykładowcy
CREATE PROCEDURE AddNewLecturer
@FirstName NVARCHAR(64),
@LastName NVARCHAR(64),
@Country NVARCHAR(128),
@City NVARCHAR(128),
@Address NVARCHAR(256),
@Phone NVARCHAR(64),
@Email NVARCHAR(64)
AS
BEGIN
	DECLARE @CountryID INT, @CityID INT, @UserID INT;

	SELECT @CountryID = CountryID FROM Countries WHERE Country = @Country;

	IF @CountryID IS NULL
	BEGIN
		INSERT INTO Countries(Country)
		VALUES (@Country);

		SET @CountryID = SCOPE_IDENTITY();
	END

	SELECT @CityID = CityID FROM Cities WHERE City = @City AND CountryID = @CountryID;

	IF @CityID IS NULL
	BEGIN
		INSERT INTO Cities(CountryID, City)
		VALUES (@CountryID, @City);

		SET @CityID = SCOPE_IDENTITY();
	END

	INSERT INTO Users(FirstName, LastName, CityID, Address, Phone, Email)
	VALUES (@FirstName, @LastName, @CityID, @Address, @Phone, @Email);

	SET @UserID = SCOPE_IDENTITY();

	INSERT INTO Lecturers (LecturerID)
	VALUES(@UserID);
END;

--Dodanie nowego tłumacza
CREATE PROCEDURE AddNewTranslator
@FirstName NVARCHAR(64),
@LastName NVARCHAR(64),
@Country NVARCHAR(128),
@City NVARCHAR(128),
@Address NVARCHAR(256),
@Phone NVARCHAR(64),
@Email NVARCHAR(64)
AS
BEGIN
	DECLARE @CountryID INT, @CityID INT, @UserID INT;

	SELECT @CountryID = CountryID FROM Countries WHERE Country = @Country;

	IF @CountryID IS NULL
	BEGIN
		INSERT INTO Countries(Country)
		VALUES (@Country);

		SET @CountryID = SCOPE_IDENTITY();
	END

	SELECT @CityID = CityID FROM Cities WHERE City = @City AND CountryID = @CountryID;

	IF @CityID IS NULL
	BEGIN
		INSERT INTO Cities(CountryID, City)
		VALUES (@CountryID, @City);

		SET @CityID = SCOPE_IDENTITY();
	END

	INSERT INTO Users(FirstName, LastName, CityID, Address, Phone, Email)
	VALUES (@FirstName, @LastName, @CityID, @Address, @Phone, @Email);

	SET @UserID = SCOPE_IDENTITY();

	INSERT INTO Translators(TranslatorID)
	VALUES(@UserID);
END;

--Dodanie nowego języka do danego tłumacza
CREATE PROCEDURE AddLanguageToTranslator
@TranslatorID INT,
@Language NVARCHAR(64)
AS
BEGIN
	DECLARE @LanguageID INT;

	IF NOT EXISTS(SELECT 1 FROM Translators WHERE TranslatorID = @TranslatorID)
	BEGIN
		RETURN;
	END

	SELECT @LanguageID = LanguageID FROM AvailableLanguages
	WHERE LanguageName = @Language;

	IF @LanguageID IS NULL
	BEGIN
		INSERT INTO AvailableLanguages(LanguageName)
		VALUES (@Language);

		SET @LanguageID = SCOPE_IDENTITY();
	END

	INSERT INTO TranslatorLanguages(TranslatorID, LanguageID)
	VALUES (@TranslatorID, @LanguageID);
END;

--Dodanie nowego administratora
CREATE PROCEDURE AddNewAdministrator
@FirstName NVARCHAR(64),
@LastName NVARCHAR(64),
@Country NVARCHAR(128),
@City NVARCHAR(128),
@Address NVARCHAR(256),
@Phone NVARCHAR(64),
@Email NVARCHAR(64)
AS
BEGIN
	DECLARE @CountryID INT, @CityID INT, @UserID INT;

	SELECT @CountryID = CountryID FROM Countries WHERE Country = @Country;

	IF @CountryID IS NULL
	BEGIN
		INSERT INTO Countries(Country)
		VALUES (@Country);

		SET @CountryID = SCOPE_IDENTITY();
	END

	SELECT @CityID = CityID FROM Cities WHERE City = @City AND CountryID = @CountryID;

	IF @CityID IS NULL
	BEGIN
		INSERT INTO Cities(CountryID, City)
		VALUES (@CountryID, @City);

		SET @CityID = SCOPE_IDENTITY();
	END

	INSERT INTO Users(FirstName, LastName, CityID, Address, Phone, Email)
	VALUES (@FirstName, @LastName, @CityID, @Address, @Phone, @Email);

	SET @UserID = SCOPE_IDENTITY();

	INSERT INTO Administrators(AdministratorID)
	VALUES(@UserID);
END;

--Dodanie nowego dyrektora
CREATE PROCEDURE AddNewDirector
@FirstName NVARCHAR(64),
@LastName NVARCHAR(64),
@Country NVARCHAR(128),
@City NVARCHAR(128),
@Address NVARCHAR(256),
@Phone NVARCHAR(64),
@Email NVARCHAR(64)
AS
BEGIN
	DECLARE @CountryID INT, @CityID INT, @UserID INT;

	SELECT @CountryID = CountryID FROM Countries WHERE Country = @Country;

	IF @CountryID IS NULL
	BEGIN
		INSERT INTO Countries(Country)
		VALUES (@Country);

		SET @CountryID = SCOPE_IDENTITY();
	END

	SELECT @CityID = CityID FROM Cities WHERE City = @City AND CountryID = @CountryID;

	IF @CityID IS NULL
	BEGIN
		INSERT INTO Cities(CountryID, City)
		VALUES (@CountryID, @City);

		SET @CityID = SCOPE_IDENTITY();
	END

	INSERT INTO Users(FirstName, LastName, CityID, Address, Phone, Email)
	VALUES (@FirstName, @LastName, @CityID, @Address, @Phone, @Email);

	SET @UserID = SCOPE_IDENTITY();

	INSERT INTO Directors(DirectorID)
	VALUES(@UserID);
END;

--Dodanie nowego pracownika sekretariatu
CREATE PROCEDURE AddNewSecretaryWorker
@FirstName NVARCHAR(64),
@LastName NVARCHAR(64),
@Country NVARCHAR(128),
@City NVARCHAR(128),
@Address NVARCHAR(256),
@Phone NVARCHAR(64),
@Email NVARCHAR(64)
AS
BEGIN
	DECLARE @CountryID INT, @CityID INT, @UserID INT;

	SELECT @CountryID = CountryID FROM Countries WHERE Country = @Country;

	IF @CountryID IS NULL
	BEGIN
		INSERT INTO Countries(Country)
		VALUES (@Country);

		SET @CountryID = SCOPE_IDENTITY();
	END

	SELECT @CityID = CityID FROM Cities WHERE City = @City AND CountryID = @CountryID;

	IF @CityID IS NULL
	BEGIN
		INSERT INTO Cities(CountryID, City)
		VALUES (@CountryID, @City);

		SET @CityID = SCOPE_IDENTITY();
	END

	INSERT INTO Users(FirstName, LastName, CityID, Address, Phone, Email)
	VALUES (@FirstName, @LastName, @CityID, @Address, @Phone, @Email);

	SET @UserID = SCOPE_IDENTITY();

	INSERT INTO SecretaryWorkers(SecretaryID)
	VALUES(@UserID);
END;

--Dodanie nowego prowadzącego praktyki
CREATE PROCEDURE AddNewInternshipSupervisor
@FirstName NVARCHAR(64),
@LastName NVARCHAR(64),
@Country NVARCHAR(128),
@City NVARCHAR(128),
@Address NVARCHAR(256),
@Phone NVARCHAR(64),
@Email NVARCHAR(64)
AS
BEGIN
	DECLARE @CountryID INT, @CityID INT, @UserID INT;

	SELECT @CountryID = CountryID FROM Countries WHERE Country = @Country;

	IF @CountryID IS NULL
	BEGIN
		INSERT INTO Countries(Country)
		VALUES (@Country);

		SET @CountryID = SCOPE_IDENTITY();
	END

	SELECT @CityID = CityID FROM Cities WHERE City = @City AND CountryID = @CountryID;

	IF @CityID IS NULL
	BEGIN
		INSERT INTO Cities(CountryID, City)
		VALUES (@CountryID, @City);

		SET @CityID = SCOPE_IDENTITY();
	END

	INSERT INTO Users(FirstName, LastName, CityID, Address, Phone, Email)
	VALUES (@FirstName, @LastName, @CityID, @Address, @Phone, @Email);

	SET @UserID = SCOPE_IDENTITY();

	INSERT INTO InternshipSupervisors(SupervisorID)
	VALUES(@UserID);
END;