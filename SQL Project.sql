CREATE DATABASE PIZZAHUT;
CREATE TABLE Orders(
order_id int not null,
order_date date not null,
order_time time not null,
primary key(order_id)
);
CREATE TABLE Order_details(
order_details_id int not null,
orde_id int not null,
pizaa_id text not null,
quantity int not null,
primary key(order_details_id)
);
drop table Order_details;
CREATE TABLE Order_details(
order_details_id int not null,
order_id int not null,
pizza_id text not null,
quantity int not null,
primary key(order_details_id)
);
select * from Orders;
select * from Order_details;
select * from pizzas;
select * from pizza_types;
#Questions
-- 1) Retrieve the total number of orders placed.
select count(order_id) as total_orders from Orders;
-- 2) Calculate the total revenue generated from pizza sales.
select 
round(sum(Order_details.quantity*pizzas.price),2) as total_revenue
from Order_details join pizzas 
on Order_details.pizaa_id=pizzas.pizza_id;
-- 3)Identify the highest_priced pizza.
SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;
-- 4) Identify the most common pizza size ordered.
select pizzas.size, count(Order_details.order_details_id)
as order_count
from pizzas join Order_datails
on pizzas.pizza_id = Order_details.pizza_id
group by pizzas.size order by order_count desc
limit 1;
select * from Pizzahut.Order_details;
-- 5)  List the top 5 most ordered pizza
-- types along with their quantities.
SELECT 
    pizza_types.name, SUM(Order_details.quantity) AS quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    Order_details ON Order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY quantity DESC
LIMIT 5;
-- 6) join the necessary tables to find the total quantity
-- of each pizza category ordered.
SELECT 
    pizza_types.category,
    SUM(Order_details.quantity) AS quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    Order_details ON Order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY quantity DESC;
-- 7) Determine the distribution of orders by hour of the day.
SELECT 
    HOUR(order_time), COUNT(order_id)
FROM
    Orders
GROUP BY HOUR(order_time);
-- 8)join relevant tables to 
-- find the category-wise distribution of pizzas. 
select category , count(name) from pizza_types
group by category;
-- 9)Group the orders by date and 
-- calculate the average number of pizzas ordered per day.
SELECT 
    ROUND(AVG(quantity), 0)
FROM
    (SELECT 
        Orders.order_date, SUM(Order_details.quantity) AS quantity
    FROM
        Orders
    JOIN Order_details ON Orders.order_id = Order_details.order_id
    GROUP BY Orders.order_date) AS order_quantity;
-- 10) Determine the top 3
--  most ordered pizza type based on revenue
SELECT 
    pizza_types.name,
    SUM(Order_details.quantity * pizzas.price) AS Revenue
FROM
    pizza_types
        JOIN
    Pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    Order_details ON Order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY Revenue DESC
LIMIT 3;
-- 11) Calculate the percentage contribution of each
-- pizza type to total revenue.
SELECT 
    pizza_types.category,
    (SUM(Order_details.quantity * pizzas.price) / (SELECT 
            ROUND(SUM(Order_details.quantity * pizzas.price),
                        2) AS total_sales
        FROM
            Order_details
                JOIN
            pizzas ON pizzas.pizza_id = Order_details.pizza_id)) * 100 AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    Order_details ON pizzas.pizza_id = Order_details.pizza_id
GROUP BY pizza_types.category
ORDER BY revenue DESC;
-- 12) Analyze the cummulative revenue generated over time.
select order_date , sum(revenue) over(order by order_date)
as cum_revenue
from
(select Orders.order_date, 
sum(Order_details.quantity*pizzas.price)
as revenue
from Order_details join pizzas
on Order_details.pizza_id = pizzas.pizza_id
join
Orders
on orders.order_id = Order_details.order_id
group by Orders.order_date ) as Sales;
-- 13) Determine the top 3 most ordered pizza types
-- based on revenue for each pizza category.
select name, revenue from 
(select category,name, revenue, rank() 
over(partition by category order by revenue desc) as rn
from
(select pizza_types.category, pizza_types.name,
sum(Order_details.quantity*pizzas.price) as revenue
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join Order_details
on Order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category,pizza_types.name) as a) as b
where rn<=3;


