CREATE DATABASE OnlineBookstore;

use  OnlineBookstore;

CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);

CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);

CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;


-- 1) Retrieve all books in the "Fiction" genre:

select * from Books 
WHERE Genre='Fiction';

-- 2) Find books published after the year 1950:
select * from Books
where Published_Year > 1995;

-- 3) List all customers from the Canada:

select * from Customers
WHERE country='Canada';

-- 4) Show orders placed in November 2023:

select * from Orders
where Order_Date between '2023-11-01' and '2023-11-30';

-- 5) Retrieve the total stock of books available:

select sum(Stock)As Total_Stock
from Books;

-- 6) Find the details of the most expensive book:

select * from Books
order by price desc  limit 1;

-- 7) Show all customers who ordered more than 1 quantity of a book:

select * from Orders
where Quantity >1;

-- 8) Retrieve all orders where the total amount exceeds $20:

select * from Orders
where Total_Amount >20;

-- 9) List all genres available in the Books table:
   
select distinct Genre from Books;


-- 10) Find the book with the lowest stock:

select * from Books
order by Stock limit 1;

-- 11) Calculate the total revenue generated from all orders:

select sum(Total_Amount)as Revenue from Orders;

--  Advance Queries

-- 1) Retrieve the total number of books sold for each genre:

select b.Genre,sum(o.Quantity) as Total_Book_Sold
from Orders o
 join Books b on o.book_id=b.book_id
Group by b.Genre;

-- 2) Find the average price of books in the "Fantasy" genre:

select avg(price) as Avg_price
from Books 
where Genre ="Fantasy";

-- 3) List customers who have placed at least 2 orders:

select o.customer_id,c.name ,count(o.Order_id)as Order_count
from Orders o join customers c on  o.customer_id=c.customer_id
group by o.customer_id,c.name
having count(Order_id) >=2;

-- 4) Find the most frequently ordered book:

select o.book_id ,b.title ,count(o.order_id)as order_count
from orders o
join Books b on o.book_id =b.book_id
 group by o.book_id ,b.title
order by order_count desc limit 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :

select * from Books
where Genre ="Fantasy"
order by price Desc limit 3;

-- 6) Retrieve the total quantity of books sold by each author:

SELECT b.author, SUM(o.quantity) AS Total_Books_Sold
FROM orders o
JOIN books b ON o.book_id=b.book_id
GROUP BY b.Author;

-- 7) List the cities where customers who spent over $30 are located:

SELECT DISTINCT c.city, total_amount
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
WHERE o.total_amount > 30;

-- 8) Find the customer who spent the most on orders:

select c.Customer_Id ,c.name,sum(o.total_amount) as Total_spent 
from orders o
join customers c on o.customer_id=c.customer_id
group by c.customer_id,c.name
order by Total_spent  Desc;

-- 9) Calculate the stock remaining after fulfilling all orders:

SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity,  
	b.stock- COALESCE(SUM(o.quantity),0) AS Remaining_Quantity
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id ORDER BY b.book_id;




