# Food Delivery Insights: Analysing Data with SQL  
#Let's Create tables

/* Creating Premium membership users table
	This table contains data about Premium members means those members who had been taken subscription of Master Food.
*/
drop table if exists goldusers_signup;
CREATE TABLE goldusers_signup (
    userid INTEGER,
    gold_signup_date DATE
); 

INSERT INTO goldusers_signup(userid,gold_signup_date) 
 VALUES (1,'2017-09-22'), 
(3,'2017-04-21'); 

select * from goldusers_signup;

/*Creating users table
This table contains Master Food's customers id and signup date data. 
*/
drop table if exists users;
CREATE TABLE users (
    userid INTEGER,
    signup_date DATE
);

INSERT INTO users(userid,signup_date) 
 VALUES (1,'2014-02-09'), 
(2,'2015-01-15'), 
(3,'2014-04-11'); 

select * from users;

/*Creating Sales table
 This table contains order id, order created date and product ordered id
*/
drop table if exists sales;
CREATE TABLE sales (
    userid INTEGER,
    created_date DATE,
    product_id INTEGER
); 

INSERT INTO sales(userid,created_date,product_id) 
 VALUES (1,'2017-04-19',2),
(3,'2019-12-18',1), 
(2,'2020-07-20',3), 
(1,'2019-10-23',2), 
(1,'2018-03-19',3), 
(3,'2016-12-20',2), 
(1,'2016-11-09',1),
(1,'2016-05-20',3),
(2,'2017-09-24',1),
(1,'2017-03-11',2),
(1,'2016-03-11',1),
(3,'2016-11-10',1),
(3,'2017-12-07',2),
(3,'2016-12-15',2),
(2,'2017-11-08',2),
(2,'2018-09-10',3);

select * from sales;

/* Creating product table
This table contains product id,name and price for that product  */

drop table if exists product;
CREATE TABLE product (
    product_id INTEGER,
    product_name TEXT,
    price INTEGER
); 

INSERT INTO product(product_id,product_name,price) 
 VALUES
(1,'p1',980),
(2,'p2',870),
(3,'p3',330);

select * from product;

# Now let's explore this data 

# 1. What is total amount each customer spent on Master Food?
SELECT 
    sales.userid as customer_id, SUM(product.price) as Total_amount_spent
FROM
    sales
        JOIN
    product ON sales.product_id = product.product_id
GROUP BY sales.userid
ORDER BY sales.userid;

# 2. How many days does each customer visited Master Food?
SELECT 
    userid, COUNT(DISTINCT created_date) AS No_of_days_visited
FROM
    sales
GROUP BY userid;

# 3. What was the first product purchased by each customer? 
select * from
(select *, rank() over(partition by userid order by created_date) rnk from sales) a where rnk=1;

# 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT 
    product.product_name,
    sales.product_id,
    COUNT(sales.product_id) AS count
FROM
    sales
        JOIN
    product ON sales.product_id = product.product_id
GROUP BY product_id
ORDER BY COUNT(product_id) DESC
LIMIT 1;

# 5. Which item was the most popular for each customer?
select * from
(select *, rank() over (partition by userid order by cnt desc)rnk from
(select userid,product_id, count(product_id)cnt from sales group by userid,product_id)a)b
where rnk=1;

 #6. Which item was purchased first by the customer after they become a premium member?
select d.* from
(select c.*,rank() over(partition by userid order by created_date)rnk from
(SELECT 
    a.userid, a.created_date, a.product_id, b.gold_signup_date
FROM
    sales a
        JOIN
    goldusers_signup b ON a.userid = b.userid
WHERE
	b.gold_signup_date<=a.created_date)c)d
    where rnk=1;
    
# 7.Which item was purchased just before customer became a premium member?

select d.* from
(select c.*,rank() over(partition by userid order by created_date desc)rnk from
( SELECT 
    a.userid, a.created_date, a.product_id, b.gold_signup_date
FROM
    sales a
JOIN
    goldusers_signup b ON a.userid = b.userid
WHERE
	a.created_date<=b.gold_signup_date)c)d
    where rnk=1;
 
 # 8. What is the total orders and amount spent for each member before they became a premium member?
 
select d.userid,count(created_date) as no_of_orders,sum(price) as total_amount_spend from 
(select c.*,product.price from
(SELECT 
    a.userid, a.created_date,a.product_id, b.gold_signup_date
FROM
    sales a
JOIN
    goldusers_signup b ON a.userid = b.userid
WHERE
	b.gold_signup_date>=a.created_date
ORDER BY
	a.userid)c
    join product on product.product_id=c.product_id)d
    group by userid
    order by userid;
  

 
 
 
 
 
 
 
 
 
 
 
