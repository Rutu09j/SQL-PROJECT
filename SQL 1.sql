# Online Book store
CREATE DATABASE OnlineBookstore;
DROP TABLE  IF EXISTS Books; 
CREATE TABLE Books(
Book_ID SERIAL PRIMARY KEY,
Title VARCHAR(255),	
Author VARCHAR(255),	
Genre VARCHAR(255),	
Published_Year INT,
Price NUMERIC(10 ,2),
Stock INT
);
DROP TABLE  IF EXISTS Customers;
CREATE TABLE Customers(
Customer_ID	SERIAL PRIMARY KEY,
Name VARCHAR(100),
Email VARCHAR(100),
Phone VARCHAR(15),
City VARCHAR(50),	
Country VARCHAR(150)
);
DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders(
Order_ID SERIAL PRIMARY KEY,
Customer_ID	INT REFERENCES Customers(Customer_ID),
Book_ID	INT REFERENCES Books(Book_ID),
Order_Date DATE,	
Quantity INT,	
Total_Amount NUMERIC(10,2)
);
SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;
#IMPORT DATA INTO TABLE
select * from Books;
SELECT * FROM Customers;
SELECT * FROM Orders;
-- 1) Retrive all books in the 'Fiction' genre:
SELECT * FROM Books
WHERE Genre = 'Fiction';
-- 2) find books published after the year 1950:
SELECT * FROM Books
WHERE Published_Year >1950;
-- 3) list all customers from canada:
SELECT * FROM Customers
WHERE Country='Canada';
-- 4) show orders placed in november 2023:
SELECT * FROM Orders
WHERE order_date BETWEEN '2023-11-01' AND
'2023-11-30';
-- 5) Retrive the total stock of books available:
select * from Books;
SELECT SUM(Stock) AS Total_Stock
FROM Books;
-- 6) find the details of the most expensive book
SELECT MAX(Price) AS expensive FROM Books;
SELECT * FROM Books
ORDER BY PRICE DESC
LIMIT 1;
-- 7) show all customers who ordered more than 1 quantity:
SELECT * FROM Orders
WHERE quantity>1;
-- 8) Retrive all orders where the total amount exceeds $20:
SELECT * FROM Orders
where Total_Amount>20; 
-- 9) list all genres available in the Books table
SELECT DISTINCT Genre FROM Books;
-- 10) find the book with the lowest stock:
SELECT * FROM Books 
ORDER BY Stock
LIMIT 1;
-- 11) calculate the total revenue generated from all orders:
SELECT SUM(total_amount) AS Revenue FROM Orders;
#ADVANCE
-- 1)Retrive the total number of books sold for each genre: 
SELECT * FROM Orders;
select books.Genre, sum(orders.Quantity) as Total_book_sold
from books 
join orders on 
books.Book_ID = orders.Book_ID
group by books.Genre;
-- 2) Find the average price of books in the "Fantasy" genre.
select  Genre ,avg(price) as Average_price
from books
where Genre= 'Fantasy';
-- 3) List customers who have placed at least 2 ordered
select Customer_ID ,count(Order_ID) as order_count
from orders
group by Customer_ID
having count(Order_ID)>=2;
-- 4) find the most frequently ordered book
select Book_ID , count(Order_ID) as order_count
from orders
group by Book_ID
order by order_count desc;
-- 5) show the top 3 most expensive books fantasy genre
select * from books
where Genre = "Fantasy"
order by price desc limit 3;

-- 6) retrive the total quantity of books sold by each author:
SELECT 
    books.Author, SUM(orders.Quantity) AS Total_book_sold
FROM
    books
        JOIN
    orders ON books.Book_ID = orders.Book_ID
GROUP BY Author;
-- 7) List the cities where customers 
-- who spent over $30 is located
select distinct customers.City , Total_Amount
from orders  join Customers
on orders.Customer_ID = customers.Customer_ID
where orders.Total_Amount > 30;
-- 8) Find the customer who spent the most on orders:
select customers.Customer_ID , customers.name,
sum(orders.Total_Amount) as Total_Spent
from orders join customers
on orders.Customer_ID = customers.Customer_ID
group by customers.Customer_ID , orders.Order_ID
order by Total_Spent desc ;
-- 9 ) Calculate the stock remaining after  fulfilling all orders.
select books.Book_ID , books.Title, books.stock,
coalesce(sum(orders.Quantity),0) as order_quantity,
books.Stock-coalesce(sum(orders.Quantity),0) as Remaining_quantity
from books
join orders on books.Book_ID=orders.Book_ID
group by books.Book_ID
order by books.Book_ID;