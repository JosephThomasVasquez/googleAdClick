-- PostgreSQL

-- CLEAR TABLES =========================================================
-- DROP TABLE
-- country,
-- author,
-- book,
-- bookdetails
-- CASCADE;

-- TRUNCATE
-- country,
-- author,
-- book,
-- bookdetails
-- RESTART IDENTITY
-- CASCADE;


-- CREATE TABLES =========================================================
-- Create the country table
CREATE TABLE country (
id INTEGER PRIMARY KEY generated by default as identity,
country_name VARCHAR(255),
code VARCHAR(3)
);

-- Create the author table
CREATE TABLE author (
id INTEGER PRIMARY KEY generated by default as identity,
firstname VARCHAR(100),
lastname VARCHAR(100),
country_id INTEGER,
FOREIGN KEY (country_id) REFERENCES country(id)
);

-- Create the book table
CREATE TABLE book (
id INTEGER PRIMARY KEY generated by default as identity,
author_id INTEGER,
FOREIGN KEY (author_id) REFERENCES author(id),
title VARCHAR(255),
isbn BIGINT
);

-- Create the bookdetails table
CREATE TABLE bookdetails (
  id INTEGER PRIMARY KEY generated by default as identity,
  book_id INTEGER,
  FOREIGN KEY (book_id) REFERENCES book(id),
  price DECIMAL(10, 2),
  discount DECIMAL(10, 2),
  is_hard_copy BOOLEAN
);

-- Insert data into rows in this order =========================================================================
INSERT INTO country
(country_name, code)
VALUES
('United States of America', 'USA'),
('Canada', 'CAN'),
('Nepal', 'NPL'),
('Mexico', 'MEX');

INSERT INTO author (id, firstname, lastname, country_id)
VALUES
(1, 'Geraldine', 'Wilkins', 1),
(2, 'Bryce', 'Macak', 1),
(3, 'Padraig', 'Broadbere', 2),
(4, 'Heinrick', 'Aucott', 4),
(5, 'Isador', 'Cavil', 4),
(6, 'Agnola', 'Ong', 3),
(7, 'Unknown Author', 'No Books', 1);


INSERT INTO book (id, author_id, title, isbn)
VALUES
(1, 1, 'Wishmaster', 093193286),
(2, 2, 'Clean', 022946044),
(3, 6, 'Mon Oncle (My Uncle)', 342837349),
(4, 4, 'Miss Sweden (Fröken Sverige)', 630908026),
(5, 5, 'Snowbeast', 042469989),
(6, 6, 'The Hire: Ambush', 043200239),
(7, 1, 'Riddle of the Sands, The', 573732528),
(8, 1, 'Outsiders (Ceddo)', 708102344),
(9, 3, 'Married Couple, A', 508122466),
(10, 4, 'Swan Princess: The Mystery of the Enchanted Treasure, The', 441861659),
(11, 2, 'Cake Eaters, The', 874209131),
(12, 1, 'Edmond', 552134775),
(13, 5, 'Berta''s Motives (Los motivos de Berta: Fantasía de Pubertad)', 303103332),
(14, 3, 'Our Family Wedding', 881204454),
(15, 4, 'Right Stuff, The', 460925084),
(16, 6, 'Impudent Girl (L''effrontée)', 977858087),
(17, 2, 'Moonlight and Valentino', 050138728),
(18, 3, 'Dealing: Or the Berkeley-to-Boston Forty-Brick Lost-Bag Blues', 316887712),
(19, 6, 'Running Scared', 535446616),
(20, 5, 'Revenge for Jolly!', 669872414);


insert into bookdetails (id, book_id, price, discount, is_hard_copy)
values
(1, 1, 20.88, 25, true),
(2, 2, 40.63, 25, true),
(3, 3, 43.47, 20, true),
(4, 4, 22.67, 60, false),
(5, 5, 79.87, 35, false),
(6, 6, 74.15, 40, false),
(7, 7, 58.56, 45, true),
(8, 8, 26.17, 50, false),
(9, 9, 41.31, 20, true),
(10, 10, 78.95, 40, false),
(11, 11, 73.78, 30, true),
(12, 12, 86.19, 10, false),
(13, 13, 93.69, 46, true),
(14, 14, 79.78, 20,true),
(15, 15, 79.55, 20, false),
(16, 16, 16.57, 50, true),
(17, 17, 3.99, 75, true),
(18, 18, 48.68, 75, true),
(19, 19, 92.76, 75, true),
(20, 20, 62.07, 20, false);

-- QUERIES ==================================================================================================
-- 1. List authors(id, first_name, last_name, country_name), book name, ISBN, price,
-- discount, is_hard_copy - if they have books, or null if they don't.
-- Order by author last_name, first_name.

select distinct a.id, a.firstname, a.lastname, c.country_name, b.title, b.isbn, bd.price, bd.discount, bd.is_hard_copy
FROM author as a, country as c, book as b, bookdetails as bd
WHERE a.id = b.author_id
and b.id = bd.book_id
and c.id = a.country_id
group by a.id, a.firstname, a.lastname, c.country_name, b.title, b.isbn, bd.price, bd.discount, bd.is_hard_copy
ORDER BY a.lastname, a.firstname;

--  OR -----------------------------------------------------------------
-- select distinct author.lastname, author.firstname, book, bookdetails
-- FROM author, book, bookdetails
-- WHERE author.id = book.author_id
-- and book.id = bookdetails.book_id
-- group by author.lastname, author.firstname, book, bookdetails
-- ORDER BY author.lastname, author.firstname;

-- 2. List authors (id, first_name, last_name, country_name) where country code is the USA.
SELECT author, c.country_name
FROM author, country as c
WHERE author.country_id = c.id
and c.code ILIKE 'USA'
GROUP BY author, c.country_name;

-- 3. List authors(id, first_name, last_name, country_name) with books.
-- Order by the number of books descending.
SELECT a.id, firstname, lastname, c.country_name, b.title
FROM author as a, country as c, book as b
where a.id = b.author_id
and a.country_id = c.id
GROUP BY a.id, firstname, lastname, c.country_name, b.title
order by b.title DESC;

-- 4. Select how many books are from USA authors.
select c.country_name, count(*)
FROM author as a, country as c, book as b
where a.id = b.author_id
and c.id = a.country_id
and c.code = 'USA'
GROUP BY c.country_name;

-- 5. Select books (title, isbn, discount, price) where 20 <= discount <=30, order by price
-- increasing.
select title, isbn, discount, price
from book as b, bookdetails as bd
where b.id = bd.book_id
and bd.discount between 20 and 30
ORDER by bd.price asc;

-- 6. List the cheapest book (price) of every author (first_name, last_name).
-- If an author does not have books, display -1 as the price.
select firstname, lastname, price
from book as b, bookdetails as bd, author as a
-- Subquery to filter min price of book matching bookdetails matching author
where bd.price = (
select min(price)
from bookdetails
where a.id = b.author_id
and b.id = bd.book_id
)
group by firstname, lastname, price;