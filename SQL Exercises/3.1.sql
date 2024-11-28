use Northwind

--1.1
SELECT OD.OrderID, CustomerID, SUM(Quantity) as quantity FROM [Order Details] AS OD
INNER JOIN Orders AS O ON O.OrderID=OD.OrderID
GROUP BY OD.OrderID, CustomerID

--1.2
SELECT OD.OrderID, CustomerID, SUM(Quantity) as quantity FROM [Order Details] AS OD
INNER JOIN Orders AS O ON O.OrderID=OD.OrderID
GROUP BY OD.OrderID, CustomerID
HAVING SUM(Quantity)>250

--1.3
SELECT OD.OrderID, CustomerID, ROUND(SUM(UnitPrice*Quantity*(1-Discount)),2) FROM [Order Details] AS OD
INNER JOIN Orders AS O ON O.OrderID=OD.OrderID
GROUP BY OD.OrderID, CustomerID

--1.4
SELECT OD.OrderID, CustomerID, ROUND(SUM(UnitPrice*Quantity*(1-Discount)),2) FROM [Order Details] AS OD
INNER JOIN Orders AS O ON O.OrderID=OD.OrderID
GROUP BY OD.OrderID, CustomerID
HAVING SUM(Quantity)>250

--1.5
SELECT OD.OrderID, CustomerID, E.FirstName, E.LastName, ROUND(SUM(UnitPrice*Quantity*(1-Discount)),2) FROM [Order Details] AS OD
INNER JOIN Orders AS O ON O.OrderID=OD.OrderID
INNER JOIN Employees AS E ON E.EmployeeID=O.EmployeeID
GROUP BY OD.OrderID, CustomerID, E.FirstName, E.LastName
HAVING SUM(Quantity)>250
ORDER BY 5 DESC

--2.1
SELECT Cat.CategoryName, SUM(Quantity) From Categories Cat
INNER JOIN Products P ON P.CategoryID=Cat.CategoryID
INNER JOIN [Order Details] OD ON OD.ProductID=P.ProductID
GROUP BY Cat.CategoryID, Cat.CategoryName

--2.2
SELECT Cat.CategoryName, ROUND(SUM(P.UnitPrice*Quantity*(1-Discount)),2) From Categories Cat
INNER JOIN Products P ON P.CategoryID=Cat.CategoryID
INNER JOIN [Order Details] OD ON OD.ProductID=P.ProductID
GROUP BY Cat.CategoryID, Cat.CategoryName

--2.3a
SELECT Cat.CategoryName, ROUND(SUM(P.UnitPrice*Quantity*(1-Discount)),2) From Categories Cat
INNER JOIN Products P ON P.CategoryID=Cat.CategoryID
INNER JOIN [Order Details] OD ON OD.ProductID=P.ProductID
GROUP BY Cat.CategoryID, Cat.CategoryName
ORDER BY 2 DESC

--2.3b
SELECT Cat.CategoryName, ROUND(SUM(P.UnitPrice*Quantity*(1-Discount)),2), SUM(Quantity) From Categories Cat
INNER JOIN Products P ON P.CategoryID=Cat.CategoryID
INNER JOIN [Order Details] OD ON OD.ProductID=P.ProductID
GROUP BY Cat.CategoryID, Cat.CategoryName
ORDER BY SUM(Quantity) DESC

--2.4
SELECT O.OrderID, ROUND(SUM(UnitPrice*Quantity*(1-Discount)),2)+Freight FROM Orders O
INNER JOIN [Order Details] OD ON O.OrderID=OD.OrderID
GROUP BY O.OrderID, Freight

--3.1
SELECT S.CompanyName, COUNT(OrderID) FROM Shippers S
INNER JOIN Orders O ON O.ShipVia=S.ShipperID
WHERE YEAR(ShippedDate)=1997
GROUP BY S.ShipperID, S.CompanyName

--3.2
SELECT TOP 1 S.CompanyName FROM Shippers S
INNER JOIN Orders O ON O.ShipVia=S.ShipperID
WHERE YEAR(ShippedDate)=1997
GROUP BY S.ShipperID, S.CompanyName
ORDER BY COUNT(OrderID) DESC

--3.3
SELECT FirstName, LastName, ROUND(SUM(UnitPrice*Quantity*(1-Discount)),2) FROM Employees E
INNER JOIN Orders O ON O.EmployeeID=E.EmployeeID
INNER JOIN [Order Details] OD ON OD.OrderID=O.OrderID
GROUP BY E.EmployeeID, FirstName, LastName

--3.4
SELECT TOP 1 FirstName, LastName, COUNT(O.OrderID) FROM Employees E
INNER JOIN Orders O ON O.EmployeeID=E.EmployeeID
INNER JOIN [Order Details] OD ON OD.OrderID=O.OrderID
WHERE YEAR(OrderDate)=1997
GROUP BY E.EmployeeID, FirstName, LastName
ORDER BY COUNT(O.OrderID) DESC

--3.5
SELECT TOP 1 FirstName, LastName, ROUND(SUM(UnitPrice*Quantity*(1-Discount)),2) FROM Employees E
INNER JOIN Orders O ON O.EmployeeID=E.EmployeeID
INNER JOIN [Order Details] OD ON OD.OrderID=O.OrderID
WHERE YEAR(OrderDate)=1997
GROUP BY E.EmployeeID, FirstName, LastName
ORDER BY 3 DESC

--4.1
SELECT E.EmployeeID, FirstName, LastName, ROUND(SUM(UnitPrice*Quantity*(1-Discount)),2) AS suma FROM Employees E
INNER JOIN Orders O ON E.EmployeeID=O.EmployeeID
INNER JOIN [Order Details] OD ON O.OrderID=OD.OrderID
GROUP BY E.EmployeeID, FirstName, LastName
ORDER BY suma DESC

--4.1a
SELECT DISTINCT E.EmployeeID, E.FirstName, E.LastName, ROUND(SUM(UnitPrice*Quantity*(1-Discount)),2) AS suma FROM Employees E
INNER JOIN Orders O ON E.EmployeeID=O.EmployeeID
INNER JOIN [Order Details] OD ON O.OrderID=OD.OrderID
INNER JOIN Employees E2 ON E2.ReportsTo=E.EmployeeID
GROUP BY E.EmployeeID, E.FirstName, E.LastName, E2.EmployeeID
ORDER BY suma DESC

--4.1b
SELECT DISTINCT E.EmployeeID, E.FirstName, E.LastName, ROUND(SUM(UnitPrice*Quantity*(1-Discount)),2) AS suma FROM Employees E
INNER JOIN Orders O ON E.EmployeeID=O.EmployeeID
INNER JOIN [Order Details] OD ON O.OrderID=OD.OrderID
LEFT JOIN Employees E2 ON E2.ReportsTo=E.EmployeeID
WHERE E2.EmployeeID IS NULL
GROUP BY E.EmployeeID, E.FirstName, E.LastName, E2.EmployeeID
ORDER BY suma DESC