/*
1. Podaj liczbę produktów o cenach mniejszych niż 10$ lub większych niż 20$
*/
SELECT COUNT(ProductID) FROM Products
WHERE UnitPrice<10 OR UnitPrice>20
/*
2. Podaj maksymalną cenę produktu dla produktów o cenach poniżej 20$
*/
SELECT MAX(UnitPrice) FROM Products
WHERE UnitPrice<20
/*
3. Podaj maksymalną i minimalną i średnią cenę produktu dla produktów o
produktach sprzedawanych w butelkach ('bottle')
*/
SELECT MAX(UnitPrice) as maximum, MIN(UnitPrice) as minimum, AVG(UnitPrice) as average FROM Products
WHERE QuantityPerUnit LIKE '%bottle%'

/*
4. Wypisz informację o wszystkich produktach o cenie powyżej średniej
*/
SELECT * FROM Products
WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM Products)

/*
5. Podaj wartość zamówienia o numerze 10250
*/
SELECT ROUND(SUM(UnitPrice*Quantity*(1-Discount)),2) FROM [Order Details]
WHERE OrderID=10250

/*
1. Podaj maksymalną cenę zamawianego produktu dla każdego zamówienia
*/
SELECT OrderID, MAX(UnitPrice) FROM [Order Details]
GROUP BY OrderID

/*
2. Posortuj zamówienia wg maksymalnej ceny produktu
*/
SELECT OrderID, MAX(UnitPrice) FROM [Order Details]
GROUP BY OrderID
ORDER BY 2 DESC

/*
3. Podaj maksymalną i minimalną cenę zamawianego produktu dla każdego
zamówienia
*/
SELECT OrderID, MAX(UnitPrice) AS maximum, MIN(UnitPrice) AS minimum FROM [Order Details]
GROUP BY OrderID

/*
4. Podaj liczbę zamówień dostarczanych przez poszczególnych spedytorów (przewoźników)
*/
SELECT ShipVia, COUNT(OrderID) FROM Orders
GROUP BY ShipVia

/*
5. Który z spedytorów był najaktywniejszy w 1997 roku
*/
SELECT TOP 1 ShipVia, COUNT(OrderID) FROM Orders
WHERE YEAR(ShippedDate)=1997
GROUP BY ShipVia
ORDER BY COUNT(OrderID) DESC

/*
1. Wyświetl zamówienia dla których liczba pozycji zamówienia jest większa niż 5
*/
SELECT OrderID, COUNT(OrderID) FROM [Order Details]
GROUP BY OrderID
HAVING COUNT(*)>5

/*
2. Wyświetl klientów dla których w 1998 roku zrealizowano więcej niż 8 zamówień
(wyniki posortuj malejąco wg łącznej kwoty za dostarczenie zamówień dla każdego z klientów)
*/
SELECT CustomerID, COUNT(OrderID) FROM Orders
WHERE YEAR(OrderDate)=1998
GROUP BY CustomerID
HAVING COUNT(OrderID)>8