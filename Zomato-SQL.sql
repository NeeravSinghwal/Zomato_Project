create database zomato;
use zomato;

-- -----------------------------------------------------------------------------
CREATE TABLE Salespeople (
    snum INT,
    sname VARCHAR(255),
    city VARCHAR(255),
    comm DECIMAL(10,2)
);

INSERT INTO Salespeople (snum, sname, city, comm) VALUES
(1001, 'Peel', 'London', 0.12),
(1002, 'Serres', 'San Jose', 0.13),
(1003, 'Axelrod', 'New York', 0.10),
(1004, 'Motika', 'London', 0.11),
(1007, 'Rifkin', 'Barcelona', 0.15);

-- -----------------------------------------------------------------------------
CREATE TABLE Cust (
    cnum INT,
    cname VARCHAR(255),
    city VARCHAR(255),
    rating INT,
    snum INT
);

INSERT INTO Cust (cnum, cname, city, rating, snum) VALUES
(2001, 'Hoffman', 'London', 100, 1001),
(2002, 'Liu', 'San Jose', 100, 1002),
(2003, 'Grass', 'Berlin', 100, NULL),
(2004, 'Clemens', 'London', 300, NULL),
(2005, 'Pereira', 'Rome', NULL, NULL);

-- -----------------------------------------------------------------------------
CREATE TABLE orders (
  onum INT,
  amt DECIMAL(10,2),
  odate DATE,
  cnum INT,
  snum INT
);

INSERT INTO orders (onum, amt, odate, cnum, snum) VALUES
(3001, 18.69, '1994-10-03', NULL, NULL),
(3002, 1900.10, '1994-10-03', 2007, 1004),
(3003, 767.19, '1994-10-03', 2001, 1001),
(3005, 5160.45, '1994-10-03', 2003, 1002),
(3006, 1098.16, '1994-10-04', 2008, 1007),
(3007, 75.75, '1994-10-05', NULL, NULL),
(3008, 4723.00, '1994-10-05', 2006, 1001),
(3009, 1713.23, '1994-10-06', 2002, 1003),
(3010, 1309.95, '1994-10-06', 2004, 1002),
(3011, 9891.88, '1994-10-06', 2006, 1001);

show tables;

-- 4-----------------------------------------------------------------------------

-- Write a query to match the salespeople to the customers according to the city they are living.

SELECT 
    C.cname as CustomerName, 
    S.sname as SalespersonName, 
    C.city as City
FROM 
    Cust as C
JOIN 
    Salespeople as S ON C.city = S.city;

-- 5----------------------------------------------------------------------------

-- Write a query to select the names of customers and the salespersons who are providing service to them.
 
 SELECT 
    C.cname as CustomerName, S.sname as SalespersonName
FROM 
    Cust as C inner join Salespeople as S ON C.snum = S.snum;

-- 6-----------------------------------------------------------------------------

-- Write a query to find out all orders by customers not located in the same cities as that of their salespeople

SELECT c.cnum,c.cname,c.rating,o.onum,o.amt,o.odate,s.snum,s.sname,s.city,s.comm
FROM orders as o
INNER JOIN Cust as c ON o.cnum = c.cnum
INNER JOIN Salespeople s ON o.snum = s.snum
WHERE c.city <> s.city;

-- 7-----------------------------------------------------------------------------

-- Write a query that lists each order number followed by name of customer who made that order

SELECT o.onum, c.cname
FROM orders as o INNER JOIN Cust as c ON o.cnum = c.cnum;

-- 8-----------------------------------------------------------------------------

-- Write a query that finds all pairs of customers having the same rating.

SELECT c1.cname as customer1, c2.cname as customer2, c1.rating
FROM Cust as c1
INNER JOIN Cust as c2 ON c1.rating = c2.rating
WHERE c1.cnum < c2.cnum; -- To avoid duplicate pairs

-- 9-----------------------------------------------------------------------------

-- Write a query to find out all pairs of customers served by a single salesperson.

SELECT DISTINCT c1.cnum AS customer1, c1.cname AS customer1_name,
                c2.cnum AS customer2, c2.cname AS customer2_name,
                s.snum AS salesperson_number
FROM Cust c1
INNER JOIN Cust c2 ON c1.snum = c2.snum AND c1.cnum < c2.cnum
INNER JOIN Salespeople s ON c1.snum = s.snum;

-- 10-----------------------------------------------------------------------------

-- Write a query that produces all pairs of salespeople who are living in same city.

SELECT s1.sname as salesperson1, s2.sname as salesperson2, s1.city
FROM Salespeople as s1
INNER JOIN Salespeople as s2 ON s1.city = s2.city
WHERE s1.snum < s2.snum; -- To avoid duplicate pairs

-- -----------------------------------------------------------------------------


-- 11-----------------------------------------------------------------------------

-- Write a Query to find all orders credited to the same salesperson who services Customer 2008

SELECT o.*
FROM orders o
JOIN Cust c ON o.snum = c.snum
WHERE c.cnum = 2008;

-- 12-----------------------------------------------------------------------------

-- Write a Query to find out all orders that are greater than the average for Oct 4th

SELECT * FROM orders
WHERE amt > (SELECT AVG(amt) FROM orders
WHERE odate = '1994-10-04'
);

-- 13-----------------------------------------------------------------------------

-- Write a Query to find all orders attributed to salespeople in London.

SELECT o.*
FROM orders as o
JOIN Salespeople as s ON o.snum = s.snum
WHERE s.city = 'London';

-- 14-----------------------------------------------------------------------------

-- Write a query to find all the customers whose cnum is 1000 above the snum of Serres. 

SELECT *
FROM Cust
WHERE cnum = (SELECT snum FROM Salespeople WHERE sname = 'Serres') + 1000;

-- 15-----------------------------------------------------------------------------

-- Write a query to count customers with ratings above San Jose’s average rating.

SELECT COUNT(*) as Total_Count
FROM Cust
WHERE rating > (SELECT AVG(rating) FROM Cust WHERE city = 'San Jose');

-- 16-----------------------------------------------------------------------------

-- Write a query to show each salesperson with multiple customers.

SELECT s.snum, s.sname, COUNT(c.cnum) AS num_customers
FROM Salespeople s
LEFT JOIN Cust c ON s.snum = c.snum
GROUP BY s.snum, s.sname
HAVING COUNT(c.cnum) > 1 OR COUNT(c.cnum) IS NULL;