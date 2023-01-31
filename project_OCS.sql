create database ProjectP74;
use ProjectP74;

CREATE TABLE Salespeople (
    snum INTEGER PRIMARY KEY,
    sname VARCHAR(20),
    city VARCHAR(20),
    comm FLOAT
);
insert into salespeople (snum,sname,city,comm) values
    (1001,'Peel','London',0.12),
    (1002,'Serres','San Jose',0.13),
    (1003,'Axelrod','New York',0.10),
    (1004,'Motika','London',0.11),
    (1007,'Rafkin','Barcelona',0.15);
    
   CREATE TABLE Cust (
    cnum INTEGER PRIMARY KEY,
    cname VARCHAR(20),
    city VARCHAR(20),
    rating INTEGER,
    snum INTEGER REFERENCES salespeople (snum)
);

insert into Cust(cnum,cname,city,rating,snum) values (2001,'Hoffman','London',100,1001),
(2002,'Giovanne','Rome',200,1003),
(2003,'Liu','San Jose',300,1002),
(2004,'Grass','Berlin',100,1002),
(2006,'Clemens','London',300,1007),
(2007,'Pereira','Rome',100,1004),
(2008,'James','London',200,1007);

CREATE TABLE orders (
    onum INTEGER,
    amt FLOAT,
    odate DATE,
    cnum INTEGER REFERENCES Cust (cnum),
    snum INTEGER REFERENCES salespeople (snum)
);

insert into orders(onum,amt,odate,cnum,snum) values
(3001,18.69,'1994-10-03',2008,1007),
(3002,1900.10,'1994-10-03',2007,1004),
(3003,767.19,'1994-10-03',2001,1001),
(3005,5160.45,'1994-10-03',2003,1002),
(3006,1098.16,'1994-10-04',2008,1007),
(3007,75.75,'1994-10-05',2004,1002),
(3008,4723.00,'1994-10-05',2006,1001),
(3009,1713.23,'1994-10-04',2002,1003),
(3010,1309.95,'1994-10-06',2004,1002),
(3011,9891.88,'1994-10-06',2006,1001);

# Q. Write a query to match the salespeople to the customers according to the city they are living.

SELECT 
    salespeople.sname, cust.cname, cust.city
FROM
    salespeople,
    cust
WHERE
    salespeople.snum = cust.snum
        AND salespeople.city = cust.city;

# Q.	Write a query to select the names of customers and the salespersons who are providing service to them.

SELECT 
    salespeople.snum,salespeople.sname, salespeople.city,cust.snum, cust.cname
FROM
    salespeople,
    cust
WHERE
    salespeople.snum = cust.snum;

# Q. Write a query to find out all orders by customers not located in the same cities as that of their salespeople

SELECT 
    onum,
    orders.cnum,
    cust.city,
    orders.snum,
    salespeople.city
FROM
    orders,
    cust,
    salespeople
WHERE
    cust.city <> salespeople.city
        AND orders.cnum = cust.cnum
        AND orders.snum = salespeople.snum;

# Q. Write a query that lists each order number followed by name of customer who made that order

SELECT 
    orders.onum, cust.cname
FROM
    orders,
    cust
WHERE
    orders.cnum = cust.cnum;

# Q. Write a query that finds all pairs of customers having the same rating………………

SELECT 
    *
FROM
    cust
ORDER BY rating;

# Q. Write a query to find out all pairs of customers served by a single salesperson………………..

SELECT 
    salespeople.sname,cust.cname
FROM
    cust,salespeople
    where cust.snum=salespeople.snum
ORDER BY cust.snum;

# Q. Write a query that produces all pairs of salespeople who are living in same city………………..
SELECT 
    *
FROM
    salespeople
ORDER BY city;

# Q. Write a Query to find all orders credited to the same salesperson who services Customer 2008
SELECT 
    onum, salespeople.sname, orders.cnum
FROM
    orders,
    salespeople
WHERE
    orders.cnum = 2008
        AND orders.snum = salespeople.snum;

# Q. Write a Query to find out all orders that are greater than the average for Oct 4th

SELECT 
    *
FROM
    orders
WHERE
    amt > (SELECT 
            AVG(amt)
        FROM
            orders
        WHERE
            odate = '1994-10-04');

# Q. Write a Query to find all orders attributed to salespeople in London

SELECT 
    *
FROM
    orders
WHERE
    snum IN (SELECT 
            snum
        FROM
            salespeople
        WHERE
            city = 'London');
   
   
   # Q. Write a query to find all the customers whose cnum is 1000 above the snum of Serres
  SELECT 
    cnum, cname, cust.snum
FROM
    cust
WHERE
    cnum > 1000 + (SELECT 
            snum
        FROM
            salespeople
        WHERE
            sname = 'serres');
   
  
  # Q. Write a query to count customers with ratings above San Jose’s average rating. 
  
 SELECT 
    COUNT(cnum) AS count_of_customers
FROM
    cust
WHERE
    rating > (SELECT 
            AVG(rating)
        FROM
            cust
        WHERE
            city = 'san jose');
  
  # Q. Write a query to show each salesperson with multiple customers.
 
 SELECT 
    snum, sname
FROM
    salespeople
WHERE
    snum IN (SELECT 
            cust.snum
        FROM
            cust
        GROUP BY cust.snum
        HAVING COUNT(*) > 1);
  
  
  
  
  
  
   
   