use Northwind;

--1
SELECT OrderID, ROUND(SUM(UnitPrice*Quantity*(1-Discount)),2) AS 'Suma sprzedaży' FROM [Order Details]
GROUP BY OrderID
ORDER BY 'Suma Sprzedaży' DESC;

SELECT TOP 10 OrderID, ROUND(SUM(UnitPrice*Quantity*(1-Discount)),2) AS 'Suma sprzedaży' FROM [Order Details]
GROUP BY OrderID
ORDER BY 'Suma Sprzedaży' DESC;

--2
SELECT ProductID, SUM(Quantity) AS 'Ile' FROM [Order Details]
WHERE ProductID<3
GROUP BY ProductID;

SELECT ProductID, Sum(Quantity) AS 'Ile' FROM [Order Details]
GROUP BY ProductID;

SELECT OrderID, SUM(Quantity) AS 'Ile', ROUND(SUM(UnitPrice*Quantity*(1-Discount)),2) AS 'Suma sprzedaży' FROM [Order Details]
GROUP BY OrderID
HAVING Sum(Quantity)>250;

--3
SELECT EmployeeID, COUNT(*) FROM Orders
GROUP BY EmployeeID
ORDER BY COUNT(*) DESC;

SELECT ShipVia, SUM(Freight) AS 'Opłata za przesyłkę' FROM Orders
GROUP BY ShipVia;

SELECT ShipVia, SUM(Freight) AS 'Opłata za przesyłkę' FROM Orders
WHERE ShippedDate BETWEEN '1996-01-01' AND '1997-12-31'
GROUP BY ShipVia;

--4.1
SELECT EmployeeID, YEAR(ShippedDate) AS 'Rok', MONTH(ShippedDate) AS 'Miesiąc', COUNT(*) AS 'Ile' FROM Orders
GROUP BY EmployeeID, YEAR(ShippedDate), MONTH(ShippedDate);

--4.2
SELECT CategoryID, MAX(UnitPrice) AS 'Maksymalna cena', MIN(UnitPrice) AS 'Minimalna cena' FROM Products
GROUP BY CategoryID;