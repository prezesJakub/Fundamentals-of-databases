--Zad. 1 Dla każdego dorosłego członka biblioteki podaj jego imię, nazwisko, liczbę jego dzieci, liczbę
--zarezerwowanych książek oraz liczbę wypożyczonych książek.
use library;

SELECT a.member_no, FirstName, LastName, COUNT(j.adult_member_no) AS 'Liczba dzieci',
ISNULL((SELECT COUNT(*) FROM reservation r
WHERE r.member_no=a.member_no
GROUP BY r.member_no), 0) AS 'Liczba zarezerwowanych książek',
ISNULL((SELECT COUNT(*) FROM loan l
WHERE l.member_no=a.member_no
GROUP BY l.member_no)+
(SELECT COUNT(*) FROM loanhist lh
WHERE lh.member_no=a.member_no
GROUP BY lh.member_no), 0) AS 'Liczba wypożyczonych książek' FROM adult a
INNER JOIN member m ON m.member_no=a.member_no
LEFT JOIN juvenile j ON a.member_no=j.adult_member_no
GROUP BY a.member_no, FirstName, LastName;

--Zad. 2 Który z tytułów był najczęściej wypożyczany w 2001? Podaj ten tytuł wraz z datą ostatniego zwrotu

SELECT TOP 1 WITH TIES t.title_no, title, count(*) AS 'liczba wypożyczeń', 
(SELECT MAX(in_date) FROM loanhist lh2
WHERE lh2.title_no=t.title_no) AS 'Data ostatniego zwrotu'
FROM title t
INNER JOIN loanhist lh ON lh.title_no=t.title_no
WHERE YEAR(out_date)=2001
GROUP BY t.title_no, title
ORDER BY COUNT(*) DESC;

--Zad. 3 Podaj wszystkie zamówienia (numer zamówienia), dla których opłata za przesyłkę
--była większa od średniej opłaty za przesyłkę zamówień złożonych w tym samym roku.
--Dla każdego wyświetl tę opłatę oraz średnią opłatę za przesyłkę zamówień złożonych w tym samym roku
use Northwind;

SELECT O.OrderID, Freight, 
(SELECT AVG(Freight) FROM Orders O2
WHERE YEAR(O2.OrderDate)=YEAR(O.OrderDate)) AS 'średnia opłata za przesyłkę w tym samym roku' FROM Orders O
WHERE Freight > (SELECT AVG(Freight) FROM Orders O2
WHERE YEAR(O2.OrderDate)=YEAR(O.OrderDate));

