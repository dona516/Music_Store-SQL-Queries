USE Music_Store
--Who is the senior most employee based on jon title
SELECT * FROM employee
ORDER BY levels desc;

--Which countries have the most invoices?
SELECT Count(*) as c,billing_country
FROM invoice
GROUP BY billing_country
ORDER BY c desc;

--TOP 3 values of total invoice
SELECT TOP 3 total 
FROM invoice
Order By total 

--Which city has best customers? we would like to throw a promotional music festival in the city we made the most money.write query that returns one city that has the highest sum of invoice totals.Return both city name and sum of all invoice totals
SELECT * FROM customer
SELECT * FROM invoice
SELECT * FROM invoice_line
SELECT * FROM track
SELECT * FROM genre
SELECT * from artist
SELECT * FROM media_type
SELECT * FROM playlist
SELECT * FROM album
SELECT * from playlist_track

SELECT TOP 1 billing_city,sum(total) as invoice_total
FROM invoice
GROUP BY billing_city
ORDER BY invoice_total desc

--who is the best customer? the customer who has spent the most money will be declared the best customer.Write a query that returns the person who has spend the most money
SELECT TOP 1 c.customer_id, c.first_name,c.last_name , SUM (i.total ) as total
FROM customer c
INNER JOIN invoice i
ON c.customer_id=i.customer_id
GROUP BY c.customer_id,c.first_name,c.last_name
ORDER BY total desc

--write query to return email,first_name,last_name and genre of all rock music listeners.Return list ordered alphabetically by email starting with A
SELECT * FROM genre
SELECT DISTINCT c.email,c.first_name,c.last_name
FROM customer c
JOIN invoice ON c.customer_id=invoice.customer_id
JOIN invoice_line ON invoice.invoice_id=invoice_line.invoice_id
WHERE track_id IN(
    SELECT track_id FROM track
	JOIN genre ON track.genre_id=genre.genre_id
    WHERE genre.name LIKE 'ROCK'
)
ORDER BY email;

--Invite the artists who have written the most rock music in our dataset.Write a query that returns the Artist name and total count of the top 10 rock bands
SELECT TOP 10 artist.artist_id,artist.name,COUNT(artist.artist_id) AS number_of_songs
FROM track
JOIN album ON album.album_id=track.album_id
JOIN artist ON artist.artist_id=album.artist_id
JOIN genre ON genre.genre_id=track.genre_id
WHERE genre.name LIKE 'ROCK'
GROUP BY artist.artist_id,artist.name
ORDER BY number_of_songs DESC

--Return all the track names that have a song length longer than the average song length.Return the name and miliseconds for each track .Order by the song length with the longest songs listed first
SELECT milliseconds,name
FROM track
WHERE milliseconds >(SELECT AVG(milliseconds) FROM track)
GROUP BY name,milliseconds
ORDER BY milliseconds DESC


--Recursive CTE- It references itself and stop when it returns all the result
-- Consist of 3 elements 
--Non-recursive term : Its a CTE query definition that forms base result set of CTE structure
--Recursive : One or more CTE query definitions joined with non-recursive term using Union and UNion akk operator 
--Termination check : The recursion stops when no rows are returned from previous iteration


-- Sub queries

SELECT * FROM customer
SELECT * FROM invoice

--Customer who made highest purchase
SELECT customer_id,full_name,company 
FROM customer 
WHERE customer_id IN(
SELECT TOP 1customer_id 
from (
SELECT customer_id, SUM(total) AS total_amount
        FROM invoice
        GROUP BY customer_id
    ) AS CustomerTotal
    ORDER BY total_amount DESC
);

--RCTE
WITH CustomerTotal AS (
    SELECT customer_id, SUM(total) AS total_amount
    FROM invoice
    GROUP BY customer_id
)

SELECT c.*
FROM customer c
JOIN CustomerTotal ct ON c.customer_id = ct.customer_id
WHERE ct.total_amount = (
    SELECT MAX(total_amount)
    FROM CustomerTotal
);


SELECT customer_id,first_name,last_name
FROM customer
WHERE customer_id IN (SELECT customer_id from invoice
WHERE total>9.9
);

SELECT track_id,name
FROM track
WHERE album_id IN (SELECT album_id FROM album WHERE title='Big Ones');


--WINDOW FUNCTION
--Window functions applies aggregrate,ranking and amnalytical functions over a particular window
--OVER clause is used 
--Aggregrate functions(1)
SELECT * FROM customer;

SELECT customer_id,first_name,support_rep_id,
SUM(support_rep_id) OVER(PARTITION BY customer_id ORDER BY first_name) AS 'TOTAL_REP_ID',
COUNT(support_rep_id) OVER(PARTITION BY customer_id ORDER BY first_name) AS 'TOTAL_REP_ID',
MIN(support_rep_id) OVER(PARTITION BY customer_id ORDER BY first_name) AS 'TOTAL_REP_ID',
MAX(support_rep_id) OVER(PARTITION BY customer_id ORDER BY first_name) AS 'TOTAL_REP_ID',
AVG(support_rep_id) OVER(PARTITION BY customer_id ORDER BY first_name) AS 'TOTAL_REP_ID'
FROM customer

--ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
SELECT customer_id,first_name,support_rep_id,
SUM(support_rep_id) OVER(ORDER BY customer_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS 'TOTAL_REP_ID'
FROM customer

--ROW AND RANK FUNCTION
SELECT customer_id,first_name,support_rep_id,
ROW_NUMBER() OVER(ORDER BY customer_id) AS 'ROW NUMBER',
RANK() OVER (ORDER BY customer_id) AS 'RANK',
DENSE_RANK() OVER(ORDER BY customer_id) AS 'DENSE_Rank',
PERCENT_RANK() OVER(ORDER BY customer_id) AS 'Percent_Rank'
FROM customer

--ANALYTIC functions
SELECT customer_id,first_name,support_rep_id,
FIRST_VALUE(support_rep_id) OVER(ORDER BY first_name) AS 'FIRST_VALUE',
LAST_VALUE(support_rep_id) OVER(ORDER BY first_name) AS 'LAST_VALUE',
LEAD(support_rep_id) OVER(ORDER BY first_name) AS 'LEAD',
LAG(support_rep_id) OVER(ORDER BY first_name) AS 'LAG'
FROM customer







































































