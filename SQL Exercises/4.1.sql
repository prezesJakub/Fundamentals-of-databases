use Northwind;

--1.1

SELECT DISTINCT C.CustomerID, C.Companyname, C.Phone FROM Orders AS O INNER JOIN Customers AS C ON O.CustomerID=C.CustomerID
INNER JOIN Shippers AS S ON S.ShipperID=O.ShipVia
WHERE YEAR(ShippedDate)=1997 AND S.CompanyName='United Package'
ORDER BY C.CustomerID;

SELECT C.CustomerID, C.CompanyName, C.Phone FROM Customers AS C
WHERE C.CustomerID IN (
	SELECT O.CustomerID FROM Orders O
	INNER JOIN Shippers S ON S.ShipperID=O.ShipVia
	WHERE YEAR(ShippedDate)=1997 AND S.CompanyName='United Package'
);


--1.2
SELECT DISTINCT C.CompanyName, C.Phone FROM Customers AS C
WHERE C.CustomerID IN (
    SELECT O.CustomerID
    FROM Orders AS O
    INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
    INNER JOIN Products AS P ON P.ProductID = OD.ProductID
    INNER JOIN Categories AS Cat ON P.CategoryID = Cat.CategoryID
    WHERE Cat.CategoryName = 'Confections'
);


--1.3
SELECT DISTINCT C.CustomerId, C.CompanyName, C.Phone FROM Customers C
WHERE C.CustomerID NOT IN
(SELECT DISTINCT C.CustomerID FROM Customers AS C 
INNER JOIN Orders AS O ON O.CustomerID=C.CustomerID
INNER JOIN [Order Details] AS OD ON O.OrderID=OD.OrderID
INNER JOIN Products AS P ON P.ProductID=OD.ProductID
INNER JOIN Categories AS Cat ON P.CategoryID=Cat.CategoryID
WHERE CategoryName='Confections');

--2.1
SELECT DISTINCT ProductID, quantity FROM [Order Details] OD
WHERE quantity = (SELECT MAX(quantity) FROM [Order Details] OD2
				WHERE OD.ProductID=OD2.ProductID);

--2.2
SELECT ProductID, UnitPrice FROM Products
WHERE UnitPrice>(SELECT AVG(UnitPrice) FROM Products)
ORDER BY UnitPrice;

--2.3
SELECT ProductID, UnitPrice, P.CategoryID, (SELECT AVG(UnitPrice) FROM Products P2
				WHERE P2.CategoryID=P.CategoryID
				GROUP BY P2.CategoryID) AS średnia FROM Products P
WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM Products P2
				WHERE P2.CategoryID=P.CategoryID
				GROUP BY P2.CategoryID)
ORDER BY ProductID;

--3.1
SELECT ProductName, UnitPrice, (SELECT AVG(UnitPrice) FROM Products) AS average, ABS((SELECT AVG(UnitPrice) FROM Products)-UnitPrice) 
FROM Products;

--3.2
SELECT (SELECT C.CategoryName FROM Categories C
WHERE C.CategoryID=P.CategoryID), 
ProductName, UnitPrice, (SELECT AVG(UnitPrice) FROM Products P2
				WHERE P2.CategoryID=P.CategoryID
				GROUP BY P2.CategoryID) AS average, 
				ABS((SELECT AVG(UnitPrice) FROM Products P2
				WHERE P2.CategoryID=P.CategoryID
				GROUP BY P2.CategoryID)-UnitPrice) 
FROM Products P;

--4.1
SELECT ROUND(SUM(UnitPrice*Quantity*(1-Discount)),2)+(SELECT Freight FROM Orders WHERE OrderID=10250) FROM [Order Details] O
WHERE O.OrderID IN
(SELECT OrderID FROM Orders
WHERE OrderID=10250);

--4.2
SELECT O.OrderID, (SELECT ROUND(SUM(UnitPrice*Quantity*(1-Discount)),2) FROM [Order Details] OD
					WHERE OD.OrderID=O.OrderID) + Freight AS total
FROM Orders O
ORDER BY total DESC;

--4.3
SELECT Address FROM Customers C
WHERE NOT EXISTS (SELECT * FROM Orders O
WHERE c.CustomerID=O.CustomerID AND YEAR(O.OrderDate)=1997);


--4.4
SELECT ProductName FROM Products P
WHERE ProductID IN
(SELECT OD.ProductID FROM [Order Details] OD
INNER JOIN Orders O ON O.OrderID=OD.OrderID
GROUP BY OD.ProductID
HAVING COUNT(DISTINCT O.CustomerID)>1);

--5.1
SELECT FirstName, LastName, (SELECT ROUND(SUM(UnitPrice*Quantity*(1-Discount)),2) FROM [Order Details] OD
					INNER JOIN Orders O ON O.OrderID=OD.OrderID
					WHERE O.EmployeeID=E.EmployeeID) + (SELECT SUM(Freight) FROM Orders O2 
					WHERE O2.EmployeeID=E.EmployeeID ) FROM Employees E;

--5.2
SELECT FirstName, LastName FROM Employees E
WHERE EmployeeID =
(SELECT TOP 1 O.EmployeeID FROM Orders O
INNER JOIN [Order Details] OD ON OD.OrderID=O.OrderID
WHERE YEAR(O.OrderDate)=1997
GROUP BY O.EmployeeID
ORDER BY SUM(UnitPrice*Quantity*(1-Discount)) DESC);

--5.3a
SELECT FirstName, LastName, (SELECT ROUND(SUM(UnitPrice*Quantity*(1-Discount)),2) FROM [Order Details] OD
					INNER JOIN Orders O ON O.OrderID=OD.OrderID
					WHERE O.EmployeeID=E.EmployeeID) + (SELECT SUM(Freight) FROM Orders O2 
					WHERE O2.EmployeeID=E.EmployeeID ) FROM Employees E
WHERE E.EmployeeID IN (SELECT DISTINCT ReportsTo FROM Employees WHERE ReportsTo IS NOT NULL);

--5.3b

SELECT FirstName, LastName, (SELECT ROUND(SUM(UnitPrice*Quantity*(1-Discount)),2) FROM [Order Details] OD
					INNER JOIN Orders O ON O.OrderID=OD.OrderID
					WHERE O.EmployeeID=E.EmployeeID) + (SELECT SUM(Freight) FROM Orders O2 
					WHERE O2.EmployeeID=E.EmployeeID ) FROM Employees E
WHERE E.EmployeeID NOT IN (SELECT DISTINCT ReportsTo FROM Employees WHERE ReportsTo IS NOT NULL);

--5.4a
SELECT FirstName, LastName, (SELECT ROUND(SUM(UnitPrice*Quantity*(1-Discount)),2) FROM [Order Details] OD
					INNER JOIN Orders O ON O.OrderID=OD.OrderID
					WHERE O.EmployeeID=E.EmployeeID) + (SELECT SUM(Freight) FROM Orders O2 
					WHERE O2.EmployeeID=E.EmployeeID ), (SELECT MAX(O.OrderDate) FROM Orders O WHERE O.EmployeeID=E.EmployeeID) 
					FROM Employees E
WHERE E.EmployeeID IN (SELECT DISTINCT ReportsTo FROM Employees WHERE ReportsTo IS NOT NULL);


--5.4b
SELECT FirstName, LastName, (SELECT ROUND(SUM(UnitPrice*Quantity*(1-Discount)),2) FROM [Order Details] OD
					INNER JOIN Orders O ON O.OrderID=OD.OrderID
					WHERE O.EmployeeID=E.EmployeeID) + (SELECT SUM(Freight) FROM Orders O2 
					WHERE O2.EmployeeID=E.EmployeeID ), (SELECT MAX(O.OrderDate) FROM Orders O WHERE O.EmployeeID=E.EmployeeID) 
					FROM Employees E
WHERE E.EmployeeID NOT IN (SELECT DISTINCT ReportsTo FROM Employees WHERE ReportsTo IS NOT NULL);