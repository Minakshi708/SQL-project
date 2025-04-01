SHOW DATABASES;
--  Creating Database

CREATE DATABASE Book_store;
-- Selecting Database to use
USE  book_store;

-- Creating Books Table
CREATE TABLE Books (
	Book_id serial Primary key,
    Title VARCHAR(100) UNIQUE,
    Author VARCHAR(50),
    Genre VARCHAR(50),
    Published_Year int,
    Price numeric(10,2),
    Stock int
    
);
DROP TABLE Books;
-- Creating Customer Table
CREATE TABLE Customers(
	Customer_id Serial Primary key,
    Name VARCHAR(50),
    Email VARCHAR(100),
    Phone int,
    City VARCHAR(100),
    Country VARCHAR(100)
);

DROP TABLE Customers;
-- Creating order Table
CREATE TABLE Orders(
	Order_ID SERIAL PRIMARY KEY,
    CUSTOMER_ID INT REFERENCES Customers(Customer_id),
    Book_id INT REFERENCES Books(Book_id),
    Order_date DATE,
    Quantity int,
    Total_Amount Decimal (10.2)
);

Drop Table Orders;
 -- Viewing Tables   
SELECT*FROM books;
SELECT*FROM customers;
SELECT*FROM orders;

-- Imported Data into Tables through import wizard


-- 1) Retrive all the books in the "Fiction"Genre

SELECT TITLE as 'Books with Fiction Genre' 
FROM books
Where Genre = 'Fiction';

-- 2) Find Books published after the year 1950

SELECT Title as ' Book Published after 1950'
FROM books
where Published_Year >1950;

-- 3) List All the customers from Canada

SELECT * FROM
Customers WHERE Country = 'Canada';

-- 4) show ordered place in november 2023

SELECT * FROM Orders
WHERE (Select month(Orders.Order_date)) = 11
And (Select Year(Orders.Order_date)) = 2023;

-- or
SELECT * FROM Orders
WHERE Order_date BETWEEN '2023-11-01' AND '2023-11-30';

 -- 5) Retrive the Total Stock of books available
 
SELECT SUM(Stock) as Total_Stock
FROM Books;


-- 6) Find the detail of Most expensive books

SELECT * 
FROM Books
Where Price = (Select max(Price) from Books) ;

-- or 

SELECT * FROM Books
Order by Price DESC LIMIT  1;

-- 7) Show all customers who ordered more than 1 quantity of a book

SELECT * FROM Orders
Where Quantity > 1;

-- 8) Show all the orders where the total amount exceeds $20;

SELECT* FROM Orders
Where Total_Amount > 20;

-- 9) List all the genres available in the Books table:

SELECT distinct(genre) as "All the Genres "
From Books;

-- 10) Find the book with the lowest stock

SELECT*FROM BOOKS ORDER BY STOCK LIMIT 1;

-- 11) Calculate the total revenue generated from all orders

SELECT SUM(Total_Amount) as Total_Revenue 
From Orders;


-- Advance

-- 1)Retrive the total number of books sold for each genre

SELECT b.genre, sum(o.Quantity) as Total_books_sold
FROM Orders o
Join Books b ON o.book_id = b.book_id
Group by b.genre; 

-- 2) Find the average price of books in the "Fantasy" genre
SELECT genre, AVG(price) as average_price
From Books
Where genre = 'Fantasy';

-- 3) List the customers who have places at least 2 orders:

Select c.customer_id , c.name , count(o.Order_id) as Order_Count
from Orders o
join Customers c on c.customer_id = o.customer_id
Group by  o.customer_id , c.name
Having  count(order_id) >2;

-- 4) Find the most frequently ordered book

SELECT o.Book_id , b.Title , COUNT(o.order_id) as Order_count
FROM orders o
join Books b ON o.book_id = b.book_id
GROUP BY Book_id
ORDER BY order_count DESC LIMIT 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre

SELECT book_id, Title, Price
FROM books 
WHERE Genre = 'Fantasy'
ORDER BY Price DESC
LIMIT 3;

-- 6) Retrive the total quantity of books sold by each author:

SELECT b. Author, SUM(o.Quantity) as Book_sold
FROM Books b
JOIN Orders o ON b.book_id = o.book_id
GROUP BY Author
Order by Book_sold DESC;


-- 7) List the cities where customers who spent over 30 are located

SELECT distinct(c.City) ,SUM(o.Total_Amount) as Money_spent
from customers c
join orders o ON o.customer_id = c.customer_id
GROUP BY City
HAVING  Money_spent > 30;

-- 8) Find customer who spent the most on orders

SELECT c.customer_id, c.name, SUM(o.Total_Amount) as Total
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY Customer_id
ORDER BY Total DESC LIMIT 1;

-- 9) Calculate the stock remaining after fulfilling all orders

SELECT b.Book_id, b.Title, b.stock , COALESCE(sum(o.quantity),0)  AS Order_quantity ,  
b.stock -COALESCE(sum(o.quantity),0)  AS Remaining_quantity
from books b
left join orders o on b.book_id = o.book_id
GROUP BY b.book_id;







