use library

--1.1 
SELECT title, title_no FROM title

--1.2
SELECT title FROM title
WHERE title_no=10

--1.3
SELECT title_no, author FROM title
WHERE author IN ('Charles Dickens', 'Jane Austen')

--2.1
SELECT title_no, title FROM title
WHERE title LIKE '%adventure%'

--2.2
SELECT member_no, ISNULL(SUM(fine_paid), 0) AS kara FROM loanhist
GROUP BY member_no
ORDER BY kara DESC

--2.3
SELECT DISTINCT city, state FROM adult

--2.4
SELECT title FROM title
ORDER BY title

--3.1
SELECT member_no, isbn, fine_assessed, 2*fine_assessed as 'double fine' FROM loanhist
WHERE fine_assessed IS NOT NULL AND fine_assessed!=0

--4.1
SELECT LOWER(firstname+middleinitial+SUBSTRING(lastname, 1, 2)) AS 'email_name' from member
WHERE lastname='Anderson'

--5.1
SELECT 'The title is: '+title+', title number '+CONVERT(varchar, title_no) FROM title

SELECT 'The title is: '+title+', title number '+str(title_no) AS title_title_no FROM title
