/*
1. Wybierz nazwy i adresy wszystkich klientów
2. Wybierz nazwiska i numery telefonów pracowników
3. Wybierz nazwy i ceny produktów
4. Pokaż wszystkie kategorie produktów (nazwy i opisy)
5. Pokaż nazwy i adresy stron www dostawców
*/
SELECT CompanyName, address, city, country FROM Customers

SELECT LastName, HomePhone FROM Employees

SELECT ProductName, UnitPrice FROM Products

SELECT CategoryName, Description FROM Categories

SELECT CompanyName, HomePage FROM Suppliers

/*
1. Wybierz nazwy i adresy wszystkich klientów mających siedziby w Londynie
2. Wybierz nazwy i adresy wszystkich klientów mających siedziby we Francji lub w
Hiszpanii
3. Wybierz nazwy i ceny produktów o cenie jednostkowej pomiędzy 20.00 a 30.00
4. Wybierz nazwy i ceny produktów z kategorii 'meat'
5. Wybierz nazwy produktów oraz inf. o stanie magazynu dla produktów
dostarczanych przez firmę 'Tokyo Traders'
6. Wybierz nazwy produktów których nie ma w magazynie
*/
SELECT CompanyName, Address, City, Country FROM Customers
WHERE City = 'London'

SELECT CompanyName, Address, City, Country FROM Customers
WHERE Country IN ('France', 'Spain')

SELECT ProductName, UnitPrice FROM Products
WHERE UnitPrice BETWEEN 20 AND 30

SELECT ProductName, UnitPrice FROM Products P
INNER JOIN Categories Cat ON P.CategoryID=Cat.CategoryID
WHERE CategoryName LIKE '%meat%'

SELECT ProductName, UnitsInStock FROM Products P
INNER JOIN Suppliers S ON P.SupplierID=S.SupplierID
WHERE CompanyName = 'Tokyo Traders'

SELECT ProductName, UnitsInStock FROM Products P
INNER JOIN Suppliers S ON P.SupplierID=S.SupplierID
WHERE UnitsInStock = 0

/*
1. Szukamy informacji o produktach sprzedawanych w butelkach ('bottle')
2. Wyszukaj informacje o stanowisku pracowników, których nazwiska zaczynają się
na literę z zakresu od B do L
3. Wyszukaj informacje o stanowisku pracowników, których nazwiska zaczynają się
na literę B lub L
4. Znajdź nazwy kategorii, które w opisie zawierają przecinek
5. Znajdź klientów, którzy w swojej nazwie mają w którymś miejscu słowo 'Store'
*/
SELECT * FROM Products
WHERE QuantityPerUnit LIKE '%bottle%'

SELECT FirstName, LastName, Title FROM Employees
WHERE LastName LIKE '[B-L]%'
ORDER BY LastName

SELECT FirstName, LastName, Title FROM Employees
WHERE LastName LIKE 'B%' OR LastName LIKE 'L%'
ORDER BY LastName

SELECT CategoryName, Description FROM Categories
WHERE Description LIKE '%,%'

SELECT CompanyName FROM Customers
WHERE CompanyName LIKE '%Store%'

/*
1. Szukamy informacji o produktach o cenach mniejszych niż 10 lub większych niż 20
2. Wybierz nazwy i ceny produktów o cenie jednostkowej pomiędzy 20.00 a 30.00
*/
SELECT * FROM Products
WHERE UnitPrice < 10 OR UnitPrice > 20

SELECT ProductName, UnitPrice FROM Products
WHERE UnitPrice BETWEEN 20 AND 30

/*
1. Wybierz nazwy i kraje wszystkich klientów mających siedziby w Japonii (Japan)
lub we Włoszech (Italy)
*/
SELECT CompanyName, Country FROM Customers
WHERE Country IN ('Japan', 'Italy')

/*
Napisz instrukcję select tak aby wybrać numer zlecenia, datę zamówienia, numer
klienta dla wszystkich niezrealizowanych jeszcze zleceń, dla których krajem
odbiorcy jest Argentyna
*/
SELECT OrderID, OrderDate, CustomerID FROM Orders
WHERE ShipCountry = 'Argentina' AND ShippedDate IS NULL

/*
1. Wybierz nazwy i kraje wszystkich klientów, wyniki posortuj według kraju, w
ramach danego kraju nazwy firm posortuj alfabetycznie
2. Wybierz informację o produktach (grupa, nazwa, cena), produkty posortuj wg
grup a w grupach malejąco wg ceny
3. Wybierz nazwy i kraje wszystkich klientów mających siedziby w Japonii (Japan)
lub we Włoszech (Italy), wyniki posortuj tak jak w pkt 1
*/
SELECT CompanyName, Country FROM Customers
ORDER BY Country, CompanyName

SELECT CategoryID, ProductName, UnitPrice FROM Products
ORDER BY CategoryID, UnitPrice DESC

SELECT CompanyName, Country FROM Customers
WHERE Country IN ('Japan', 'Italy')
ORDER BY Country, CompanyName

/*
1. Napisz polecenie, które oblicza wartość każdej pozycji zamówienia o numerze
10250
*/
SELECT ROUND(UnitPrice*Quantity*(1-Discount),2) FROM [Order Details]
WHERE OrderID=10250

/*
1. Napisz polecenie które dla każdego dostawcy pokaże pojedynczą kolumnę
zawierającą nr telefonu i nr faksu w formacie (numer telefonu i faksu mają być oddzielone przecinkiem)
*/
SELECT CompanyName, ISNULL(Phone, '') + ISNULL(', '+ Fax,'') AS 'Telefon i Fax'  FROM Suppliers