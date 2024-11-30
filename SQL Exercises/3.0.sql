use Northwind;
/*
1. Wybierz nazwy i ceny produktów (baza northwind) o cenie jednostkowej
pomiędzy 20.00 a 30.00, dla każdego produktu podaj dane adresowe dostawcy,
interesują nas tylko produkty z kategorii 'Meat/Poultry'
*/
SELECT ProductName, UnitPrice, S.Country, S.City, S.Address FROM Products P
INNER JOIN Suppliers S ON P.SupplierID=S.SupplierID
INNER JOIN Categories Cat ON P.CategoryID=Cat.CategoryID
WHERE UnitPrice BETWEEN 20 AND 30 AND Cat.CategoryName='Meat/Poultry';

/*
2. Wybierz nazwy i ceny produktów z kategorii 'Confections' dla każdego produktu
podaj nazwę dostawcy.
*/
SELECT ProductName, UnitPrice, S.CompanyName FROM Products P
INNER JOIN Suppliers S ON P.SupplierID=S.SupplierID
INNER JOIN Categories Cat ON P.CategoryID=Cat.CategoryID
WHERE Cat.CategoryName='Confections';

/*
3. Wybierz nazwy i numery telefonów klientów , którym w 1997 roku przesyłki
dostarczała firma 'United Package'
*/
SELECT DISTINCT C.CustomerID, C.CompanyName, C.Phone FROM Customers C
INNER JOIN Orders O ON O.CustomerID=C.CustomerID
INNER JOIN Shippers S ON S.ShipperID=O.ShipVia
WHERE YEAR(ShippedDate)=1997 AND S.CompanyName='United Package';

/*
4. Wybierz nazwy i numery telefonów klientów, którzy kupowali produkty z kategorii
'Confections'
*/
SELECT DISTINCT C.CustomerID, C.CompanyName, C.Phone FROM Customers C
INNER JOIN Orders O ON C.CustomerID=O.CustomerID
INNER JOIN [Order Details] OD ON OD.OrderID=O.OrderID
INNER JOIN Products P ON OD.ProductID=P.ProductID
INNER JOIN Categories Cat ON P.CategoryID=Cat.CategoryID
WHERE Cat.CategoryName='Confections';

use library;

/*
1. Napisz polecenie, które wyświetla listę dzieci będących członkami biblioteki (baza
library). Interesuje nas imię, nazwisko, data urodzenia dziecka i adres
zamieszkania dziecka.
*/
SELECT firstname, lastname, birth_date, street+', '+city+', '+state AS address FROM member
INNER JOIN juvenile ON juvenile.member_no=member.member_no
INNER JOIN adult a ON a.member_no=juvenile.adult_member_no;

/*
2. Napisz polecenie, które wyświetla listę dzieci będących członkami biblioteki (baza
library). Interesuje nas imię, nazwisko, data urodzenia dziecka, adres
zamieszkania dziecka oraz imię i nazwisko rodzica.
*/
SELECT m1.firstname, m1.lastname, birth_date, street+', '+city+', '+state AS address, m2.firstname, m2.lastname FROM member m1
INNER JOIN juvenile ON juvenile.member_no=m1.member_no
INNER JOIN adult a ON a.member_no=juvenile.adult_member_no
INNER JOIN member m2 ON m2.member_no=a.member_no;

use Northwind;

/*
1. Napisz polecenie, które wyświetla pracowników oraz ich podwładnych (baza northwind)
*/
SELECT E2.FirstName, E2.LastName, E1.FirstName, E1.LastName FROM Employees E1
INNER JOIN Employees E2 ON E1.ReportsTo=E2.EmployeeID;

/*
2. Napisz polecenie, które wyświetla pracowników, którzy nie mają podwładnych (baza northwind)
*/
SELECT E1.FirstName, E1.LastName FROM Employees E1
LEFT JOIN Employees E2 ON E2.ReportsTo=E1.EmployeeID
WHERE E2.ReportsTo IS NULL;

/*
3. Napisz polecenie, które wyświetla adresy członków biblioteki, którzy mają dzieci urodzone przed 1 stycznia 1996
*/
use library;

SELECT DISTINCT m.firstname, m.lastname, street+', '+city+', '+state AS address FROM adult a
INNER JOIN member m ON m.member_no=a.member_no
INNER JOIN juvenile j ON j.adult_member_no=m.member_no
WHERE birth_date<'1-1-1996';

/*
4. Napisz polecenie, które wyświetla adresy członków biblioteki, którzy mają dzieci
urodzone przed 1 stycznia 1996. Interesują nas tylko adresy takich członków
biblioteki, którzy aktualnie nie przetrzymują książek.
*/
SELECT DISTINCT m.firstname, m.lastname, street+', '+city+', '+state AS address FROM adult a
INNER JOIN member m ON m.member_no=a.member_no
INNER JOIN juvenile j ON j.adult_member_no=m.member_no
LEFT JOIN loan l ON a.member_no=l.member_no
WHERE birth_date<'1-1-1996' 
AND (l.isbn IS NULL or l.due_date< GETDATE());

/*
1. Napisz polecenie które zwraca imię i nazwisko (jako pojedynczą kolumnę
name), oraz informacje o adresie: ulica, miasto, stan kod (jako pojedynczą
kolumnę address) dla wszystkich dorosłych członków biblioteki
*/
SELECT firstname+' '+lastname AS 'name', street+', '+city+', '+state+', '+zip FROM adult a
INNER JOIN member m ON m.member_no=a.member_no;

/*
2. Napisz polecenie, które zwraca: isbn, copy_no, on_loan, title, translation, cover,
dla książek o isbn 1, 500 i 1000. Wynik posortuj wg ISBN
*/
SELECT c.isbn, c.copy_no, c.on_loan, title, translation, cover FROM copy c
INNER JOIN title t ON t.title_no=c.title_no
INNER JOIN item i ON i.isbn=c.isbn
WHERE c.isbn IN (1, 500, 1000)
ORDER BY c.isbn;

/*
3. Napisz polecenie które zwraca o użytkownikach biblioteki o nr 256, 358, i 1684
(dla każdego użytkownika: nr, imię i nazwisko członka biblioteki), oraz informację
o zarezerwowanych książkach (isbn, data) 
*/
SELECT m.member_no, firstname, lastname, r.isbn, r.log_date FROM member m
INNER JOIN reservation r ON r.member_no=m.member_no
WHERE m.member_no IN (256, 358, 1684);

/*
4. Podaj listę członków biblioteki mieszkających w Arizonie (AZ) mających więcej niż
dwoje dzieci zapisanych do biblioteki 
*/
SELECT adult_member_no, firstname, lastname, COUNT(j.member_no) AS 'L_DZIECI' FROM adult AS a
INNER JOIN member AS m ON m.member_no=a.member_no
INNER JOIN juvenile AS j ON j.adult_member_no=a.member_no
WHERE state='AZ'
GROUP BY adult_member_no, firstname, lastname
HAVING COUNT(j.member_no)>2;

/*
5. Podaj listę członków biblioteki mieszkających w Arizonie (AZ) którzy mają więcej
niż dwoje dzieci zapisanych do biblioteki oraz takich którzy mieszkają w Kaliforni
(CA) i mają więcej niż troje dzieci zapisanych do biblioteki
*/
SELECT adult_member_no, firstname, lastname, COUNT(j.member_no) AS 'L_DZIECI' FROM adult AS a
INNER JOIN member AS m ON m.member_no=a.member_no
INNER JOIN juvenile AS j ON j.adult_member_no=a.member_no
WHERE state='AZ'
GROUP BY adult_member_no, firstname, lastname
HAVING COUNT(j.member_no)>2
UNION
SELECT adult_member_no, firstname, lastname, COUNT(j.member_no) AS 'L_DZIECI' FROM adult AS a
INNER JOIN member AS m ON m.member_no=a.member_no
INNER JOIN juvenile AS j ON j.adult_member_no=a.member_no
WHERE state='CA'
GROUP BY adult_member_no, firstname, lastname
HAVING COUNT(j.member_no)>3;