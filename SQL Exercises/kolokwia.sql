--Zad.1. Wyświetl produkt, który przyniósł najmniejszy, ale niezerowy, przychód w 1996 roku
use Northwind;

SELECT TOP 1 ProductName FROM Products P
INNER JOIN [Order Details] OD ON P.ProductID=OD.ProductID
INNER JOIN Orders O ON O.OrderID=OD.OrderID
WHERE YEAR(OrderDate)=1996
GROUP BY P.ProductID, ProductName
HAVING ROUND(SUM(Quantity*P.UnitPrice*(1-Discount)),2) > 0
ORDER BY ROUND(SUM(Quantity*P.UnitPrice*(1-Discount)),2);

/*Zad.2. Wyświetl wszystkich członków biblioteki (imię i nazwisko, adres) 
rozróżniając dorosłych i dzieci (dla dorosłych podaj liczbę dzieci),
którzy nigdy nie wypożyczyli książki*/
use library;

SELECT a.member_no, m1.FirstName+' '+m1.LastName AS 'name', street+' '+city+' '+state+' '+zip AS 'address', 'Adult', 
COUNT(j.adult_member_no) AS 'Liczba dzieci' FROM member m1
INNER JOIN adult a ON a.member_no=m1.member_no
LEFT JOIN juvenile j ON j.adult_member_no=a.member_no
WHERE m1.member_no NOT IN (SELECT member_no FROM loanhist) AND m1.member_no NOT IN (SELECT member_no FROM loan)
GROUP BY a.member_no, m1.FirstName+' '+m1.LastName, street+' '+city+' '+state+' '+zip
UNION
SELECT m2.member_no, m2.FirstName+' '+m2.LastName AS 'name', street+' '+city+' '+state+' '+zip AS 'address', 'Child', null FROM member m2
INNER JOIN juvenile j ON j.member_no=m2.member_no
INNER JOIN adult a ON j.adult_member_no=a.member_no
WHERE m2.member_no NOT IN (SELECT member_no FROM loanhist) AND m2.member_no NOT IN (SELECT member_no FROM loan);

/*Zad.3. Wyświetl podsumowanie zamówień (całkowita cena + fracht) obsłużonych 
przez pracowników w lutym 1997 roku, uwzględnij wszystkich, nawet jeśli suma 
wyniosła 0.*/
use Northwind;

SELECT E.EmployeeID, E.FirstName, E.LastName,
ISNULL((SELECT COUNT(O.OrderID) FROM Orders O
WHERE O.EmployeeID=E.EmployeeID AND YEAR(OrderDate)=1997 AND MONTH(OrderDate)=2), 0) AS 'liczba zamówień',
ISNULL((SELECT ROUND(SUM(UnitPrice*Quantity*(1-Discount)),2) FROM [Order Details] OD
INNER JOIN Orders O ON O.OrderID=OD.OrderID
WHERE O.EmployeeID=E.EmployeeID AND YEAR(OrderDate)=1997 AND MONTH(OrderDate)=2)+
(SELECT SUM(Freight) FROM Orders O2 
WHERE O2.EmployeeID=E.EmployeeID AND YEAR(OrderDate)=1997 AND MONTH(OrderDate)=2), 0) AS 'Suma sprzedaży'
FROM Employees E
ORDER BY 4 DESC;

--ZAD 2, Podaj imiona, nazwiska i tytuły książek poozyczone przez wiecej niz 1 czytelnika, ktorzy mają dzieci.
use library;

SELECT FirstName, LastName, title FROM member m
INNER JOIN juvenile j ON m.member_no=j.adult_member_no
INNER JOIN loanhist lh ON lh.member_no=m.member_no
INNER JOIN title t ON t.title_no=lh.title_no
GROUP BY m.member_no, FirstName, LastName, title
ORDER BY title, LastName, FirstName;

--ZAD 3, Podaj wszystkie zamówienia dla których opłata za przesyłke > od sredniej w danym roku
use Northwind;

SELECT OrderID, Freight FROM Orders O
WHERE Freight > 
(SELECT AVG(Freight) FROM Orders O2
WHERE YEAR(O.OrderDate)=YEAR(O2.OrderDate));

/*1. Wypisz wszystkich członków biblioteki z adresami i info czy jest dzieckiem czy nie i
ilość wypożyczeń w poszczególnych latach i miesiącach.*/
use library;

SELECT m.member_no, FirstName+' '+LastName AS 'name', street+' '+city+' '+state+' '+zip AS 'address', 'Adult',
YEAR(out_date) AS 'rok', MONTH(out_date) AS 'miesiac', COUNT(out_date) AS 'ilość wypożyczeń' FROM member m
INNER JOIN adult a ON a.member_no=m.member_no
INNER JOIN loanhist lh ON lh.member_no=m.member_no
GROUP BY m.member_no, FirstName+' '+LastName, street+' '+city+' '+state+' '+zip, YEAR(out_date), MONTH(out_date)
UNION
SELECT m.member_no, FirstName+' '+LastName AS 'name', street+' '+city+' '+state+' '+zip AS 'address', 'Child',
YEAR(out_date) AS 'rok', MONTH(out_date) AS 'miesiac', COUNT(out_date) AS 'ilość wypożyczeń' FROM member m
INNER JOIN juvenile j ON j.member_no=m.member_no
INNER JOIN adult a ON a.member_no=j.adult_member_no
INNER JOIN loanhist lh ON lh.member_no=m.member_no
GROUP BY m.member_no, FirstName+' '+LastName, street+' '+city+' '+state+' '+zip, YEAR(out_date), MONTH(out_date);

--3. Klienci, którzy nie zamówili nigdy nic z kategorii 'Seafood' w trzech wersjach.
use Northwind;

SELECT C.CustomerID, C.CompanyName FROM Customers C
LEFT JOIN Orders O ON O.CustomerID=C.CustomerID
LEFT JOIN [Order Details] OD ON OD.OrderID=O.OrderID
LEFT JOIN Products P ON P.ProductID=OD.ProductID
LEFT JOIN Categories Cat ON Cat.CategoryID=P.CategoryID
GROUP BY C.CustomerID, C.CompanyName
HAVING COUNT(CASE WHEN Cat.CategoryName = 'Seafood' THEN 1 END)=0
ORDER BY CustomerID;

SELECT C.CustomerID, C.CompanyName FROM Customers C
LEFT JOIN Orders O ON O.CustomerID=C.CustomerID
LEFT JOIN [Order Details] OD ON OD.OrderID=O.OrderID
LEFT JOIN Products P ON P.ProductID=OD.ProductID
LEFT JOIN Categories Cat ON Cat.CategoryID=P.CategoryID AND Cat.CategoryName ='Seafood'
GROUP BY C.CustomerID, C.CompanyName
HAVING COUNT(Cat.CategoryID)=0
ORDER BY CustomerID;

SELECT C.CustomerID, C.CompanyName FROM Customers C
WHERE C.CustomerID NOT IN
(SELECT DISTINCT O.CustomerID FROM Orders O
INNER JOIN [Order Details] OD ON O.OrderID=OD.OrderID
INNER JOIN Products P ON P.ProductID=OD.ProductID
INNER JOIN Categories Cat ON Cat.CategoryID=P.CategoryID
WHERE CategoryName='Seafood');

--4. Dla każdego klienta podaj najczęściej zamawianą kategorię w dwóch wersjach.

SELECT C.CustomerID, C.CompanyName, 
(SELECT TOP 1 Cat.CategoryName FROM Categories Cat
INNER JOIN Products P ON P.CategoryID=Cat.CategoryID
INNER JOIN [Order Details] OD ON OD.ProductID=P.ProductID
INNER JOIN Orders O ON O.OrderID=OD.OrderID
WHERE O.CustomerID=C.CustomerID
GROUP BY Cat.CategoryID, Cat.CategoryName
ORDER BY COUNT(*) DESC) AS 'Favorite Category' FROM Customers C;

SELECT C.CustomerID, C.CompanyName, Cat.CategoryName, COUNT(O.OrderID) FROM Customers C
INNER JOIN Orders O ON O.CustomerID=C.CustomerID
INNER JOIN [Order Details] OD ON O.OrderID=OD.OrderID
INNER JOIN Products P ON P.ProductID=OD.ProductID
INNER JOIN Categories Cat ON Cat.CategoryID=P.CategoryID
GROUP BY C.CustomerID, C.CompanyName, Cat.CategoryName
HAVING COUNT(O.OrderID) =
(SELECT MAX(OrderCount) FROM
(SELECT COUNT(O2.OrderID) AS OrderCount FROM Orders O2
INNER JOIN [Order Details] OD2 ON OD2.OrderID=O2.OrderID
INNER JOIN Products P2 ON P2.ProductID=OD2.ProductID
INNER JOIN Categories Cat2 ON Cat2.CategoryID=P2.CategoryID
WHERE O2.CustomerID=C.CustomerID
GROUP BY Cat2.CategoryID, Cat2.CategoryName) AS SubQuery)
ORDER BY C.CustomerID, COUNT(O.OrderID) DESC;

--1. Podział na company, year month i suma freight
SELECT C.CompanyName, YEAR(OrderDate), MONTH(OrderDate), SUM(Freight) FROM Customers C
INNER JOIN Orders O ON O.CustomerID=C.CustomerID
GROUP BY C.CustomerID, C.CompanyName, YEAR(OrderDate), MONTH(OrderDate);

/*2. Wypisać wszystkich czytelników, którzy nigdy nie wypożyczyli książki dane
adresowe i podział czy ta osoba jest dzieckiem (joiny, in, exists)*/
use library;

SELECT m.member_no, FirstName, LastName, street+' '+city+' '+state+' '+zip AS 'address', 'Adult' FROM member m
INNER JOIN adult a ON a.member_no=m.member_no
LEFT JOIN loanhist lh ON lh.member_no=m.member_no
WHERE lh.member_no IS NULL
UNION
SELECT m.member_no, FirstName, LastName, street+' '+city+' '+state+' '+zip AS 'address', 'Child' FROM member m
INNER JOIN juvenile j ON j.member_no=m.member_no
INNER JOIN adult a ON j.adult_member_no=a.member_no
LEFT JOIN loanhist lh ON lh.member_no=m.member_no
WHERE lh.member_no IS NULL;

SELECT m.member_no, FirstName, LastName, street+' '+city+' '+state+' '+zip AS 'address', 'Adult' FROM member m
INNER JOIN adult a ON a.member_no=m.member_no
WHERE m.member_no NOT IN
(SELECT member_no FROM loanhist)
UNION
SELECT m.member_no, FirstName, LastName, street+' '+city+' '+state+' '+zip AS 'address', 'Child' FROM member m
INNER JOIN juvenile j ON j.member_no=m.member_no
INNER JOIN adult a ON j.adult_member_no=a.member_no
WHERE m.member_no NOT IN
(SELECT member_no FROM loanhist);

SELECT m.member_no, FirstName, LastName, street+' '+city+' '+state+' '+zip AS 'address', 'Adult' FROM member m
INNER JOIN adult a ON a.member_no=m.member_no
WHERE NOT EXISTS
(SELECT member_no FROM loanhist lh
WHERE lh.member_no=m.member_no)
UNION
SELECT m.member_no, FirstName, LastName, street+' '+city+' '+state+' '+zip AS 'address', 'Child' FROM member m
INNER JOIN juvenile j ON j.member_no=m.member_no
INNER JOIN adult a ON j.adult_member_no=a.member_no
WHERE NOT EXISTS
(SELECT member_no FROM loanhist lh
WHERE lh.member_no=m.member_no);

--3. Najczęściej wybierana kategoria w 1997 dla każdego klienta
use Northwind;

SELECT C.CustomerID, C.CompanyName, 
(SELECT TOP 1 Cat.CategoryName FROM Categories Cat
INNER JOIN Products P ON P.CategoryID=Cat.CategoryID
INNER JOIN [Order Details] OD ON OD.ProductID=P.ProductID
INNER JOIN Orders O ON O.OrderID=OD.OrderID
WHERE O.CustomerID=C.CustomerID AND YEAR(OrderDate)=1997
GROUP BY Cat.CategoryID, Cat.CategoryName
ORDER BY COUNT(*) DESC) AS 'Favorite Category' FROM Customers C;

/*4. Dla każdego czytelnika imię nazwisko, suma książek wypożyczony przez tą osobę i
jej dzieci, który żyje w Arizona ma mieć więcej niż 2 dzieci lub kto żyje w Kalifornii
ma mieć więcej niż 3 dzieci*/
use library;

SELECT m.member_no, FirstName, LastName, 
(SELECT COUNT(*) FROM loanhist lh
WHERE lh.member_no=m.member_no)+
(SELECT COUNT(*) FROM loan l
WHERE l.member_no=m.member_no) AS 'Loan amount', 
COUNT(j.adult_member_no) AS 'Liczba dzieci' FROM member m
INNER JOIN adult a ON a.member_no=m.member_no
INNER JOIN juvenile j ON j.adult_member_no=a.member_no
WHERE state='AZ'
GROUP BY m.member_no, m.firstname, m.lastname
HAVING COUNT(j.adult_member_no)>2
UNION
SELECT m.member_no, FirstName, LastName, 
(SELECT COUNT(*) FROM loanhist lh
WHERE lh.member_no=m.member_no)+
(SELECT COUNT(*) FROM loan l
WHERE l.member_no=m.member_no) AS 'Loan amount', 
COUNT(j.adult_member_no) AS 'Liczba dzieci' FROM member m
INNER JOIN adult a ON a.member_no=m.member_no
INNER JOIN juvenile j ON j.adult_member_no=a.member_no
WHERE state='CA'
GROUP BY m.member_no, m.firstname, m.lastname
HAVING COUNT(j.adult_member_no)>3;

--1. Jaki był najpopularniejszy autor wśród dzieci w Arizonie w 2001
use library;

SELECT TOP 1 author FROM title t
INNER JOIN loanhist lh ON lh.title_no=t.title_no
INNER JOIN juvenile j ON j.member_no=lh.member_no
INNER JOIN adult a ON a.member_no=j.adult_member_no
WHERE YEAR(out_date)=2001 AND state='AZ'
GROUP BY author
ORDER BY COUNT(j.member_no) DESC;

/*2. Dla każdego dziecka wybierz jego imię nazwisko, adres, imię i nazwisko rodzica i
ilość książek, które oboje przeczytali w 2001*/

SELECT m1.FirstName+' '+m1.LastName AS 'name', street+' '+city+' '+state+' '+zip AS 'address', m2.FirstName+' '+m2.LastName AS 'Parent name',
(SELECT COUNT(*) FROM loanhist lh
WHERE YEAR(out_date)=2001 AND lh.member_no=m1.member_no)+
(SELECT COUNT(*) FROM loan l
WHERE YEAR(out_date)=2001 AND l.member_no=m1.member_no)+
(SELECT COUNT(*) FROM loanhist lh
WHERE YEAR(out_date)=2001 AND lh.member_no=m2.member_no)+
(SELECT COUNT(*) FROM loan l
WHERE YEAR(out_date)=2001 AND l.member_no=m2.member_no) FROM juvenile j
INNER JOIN member m1 ON m1.member_no=j.member_no
INNER JOIN adult a ON a.member_no=j.adult_member_no
INNER JOIN member m2 ON a.member_no=m2.member_no;

--3. Kategorie które w roku 1997 grudzień były obsłużone wyłącznie przez ‘United Package’
use Northwind;

SELECT CategoryName FROM Categories Cat
INNER JOIN Products P ON P.CategoryID=Cat.CategoryID
INNER JOIN [Order Details] OD ON OD.ProductID=P.ProductID
INNER JOIN Orders O ON O.OrderID=OD.OrderID
INNER JOIN Shippers S ON S.ShipperID=O.ShipVia
WHERE S.CompanyName='United Package' AND YEAR(ShippedDate)=1997 AND MONTH(ShippedDate)=12
AND CategoryName NOT IN 
(SELECT CategoryName FROM Categories Cat
INNER JOIN Products P ON P.CategoryID=Cat.CategoryID
INNER JOIN [Order Details] OD ON OD.ProductID=P.ProductID
INNER JOIN Orders O ON O.OrderID=OD.OrderID
INNER JOIN Shippers S ON S.ShipperID=O.ShipVia
WHERE S.CompanyName NOT LIKE 'United Package' AND YEAR(ShippedDate)=1997 AND MONTH(ShippedDate)=12);

/*4. Wybierz klientów, którzy kupili przedmioty wyłącznie z jednej kategorii w marcu
1997 i wypisz nazwę tej kategorii*/

SELECT C.CustomerID, C.CompanyName, Cat.CategoryName, COUNT(*) FROM Customers C
INNER JOIN Orders O ON O.CustomerID=C.CustomerID
INNER JOIN [Order Details] OD ON OD.OrderID=O.OrderID
INNER JOIN Products P ON P.ProductID=OD.ProductID
INNER JOIN Categories Cat ON Cat.CategoryID=P.CategoryID
WHERE YEAR(OrderDate)=1997 AND MONTH(OrderDate)=3
GROUP BY C.CustomerID, C.CompanyName, Cat.CategoryName
HAVING COUNT(*)=1;

/*1. Wybierz dzieci wraz z adresem, które nie wypożyczyły książek w lipcu 2001
autorstwa ‘Jane Austin’*/
use library;

SELECT FirstName, LastName, street+' '+city+' '+state+' '+zip AS 'address' FROM juvenile j
INNER JOIN member m ON m.member_no=j.member_no
INNER JOIN adult a ON a.member_no=j.adult_member_no
WHERE j.member_no NOT IN
(SELECT member_no FROM loanhist lh
INNER JOIN title t ON lh.title_no=t.title_no
WHERE YEAR(out_date)=2001 AND MONTH(out_date)=7 AND author='Jane Austin');

--2. Wybierz kategorię, która w danym roku 1997 najwięcej zarobiła, podział na miesiące
use Northwind;

WITH T1 AS
(SELECT MONTH(OrderDate) AS 'Month', Cat.CategoryName, ROUND(SUM(OD.UnitPrice*Quantity*(1-Discount)), 2) AS SalesAmount FROM Orders O
INNER JOIN [Order Details] OD ON OD.OrderID=O.OrderID
INNER JOIN Products P ON P.ProductID=OD.ProductID
INNER JOIN Categories Cat ON Cat.CategoryID=P.CategoryID
WHERE YEAR(OrderDate)=1997 
GROUP BY MONTH(OrderDate), Cat.CategoryName)

SELECT Month, CategoryName, SalesAmount FROM T1
WHERE SalesAmount = (SELECT MAX(SalesAmount) FROM T1 AS T2
WHERE T1.Month=T2.Month);

--3. Dane pracownika i najczęstszy dostawca pracowników bez podwładnych

WITH T1 AS
(SELECT E.EmployeeID, FirstName, LastName, S.CompanyName, COUNT(*) AS OrderCount FROM Employees E
INNER JOIN Orders O ON O.EmployeeID=E.EmployeeID
INNER JOIN Shippers S ON S.ShipperID=O.ShipVia
GROUP BY E.EmployeeID, E.FirstName, E.LastName, S.CompanyName)

SELECT FirstName, LastName, CompanyName, OrderCount FROM T1
WHERE OrderCount = (SELECT MAX(OrderCount) FROM T1 AS T2
WHERE T1.EmployeeID=T2.EmployeeID
GROUP BY EmployeeID) AND T1.EmployeeID NOT IN
(SELECT E1.EmployeeID FROM Employees E1
INNER JOIN Employees E2 ON E1.EmployeeID=E2.ReportsTo);

/*4. Wybierz tytuły książek, gdzie ilość wypożyczeń książki jest większa od średniej ilości
wypożyczeń książek tego samego autora.*/
use library;

WITH T1 AS
(SELECT author, title, COUNT(*) AS 'quantity' FROM title t
INNER JOIN loanhist lh ON lh.title_no=t.title_no
GROUP BY author, title),
Average AS
(SELECT author, AVG(quantity) AS 'average' FROM T1
GROUP BY author)

SELECT author, title, quantity FROM T1
WHERE quantity > (SELECT average FROM Average
WHERE Average.author=T1.author);
