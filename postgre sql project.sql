drop table if exists Books;
create table Books(
			
	Book_ID	serial	primary key,
	Title	varchar(100),	
	Author	varchar(100),	
	Genre	varchar(100),	
	Published_Year	int,	
	Price	numeric(10,2),	
	Stock	int	
);

select * from Books ;

create table customers(	Customer_ID	serial	primary key,
	Name	varchar(100),	
	Email	varchar(100),	
	Phone	bigint,	
	City	varchar(100),	
	Country	varchar(100)	
);

select * from customers ;

drop table if exists orders;

create table orders(
	Order_ID	serial	primary key,
	Customer_ID	int	references customers(customer_id),
	Book_ID	int	References orders(order_id),
	Order_Date date	,	
	Quantity int,
	Total_Amount numeric(10,2)	
);

select * from orders ;

copy Books(Book_ID,Title,Author,Genre,Published_Year,Price,Stock)
from 'C:\Users\Acer\OneDrive\Desktop\pg sql files\Books.csv'
csv header;

copy customers(Customer_ID,Name,Email,Phone,City,Country)
from'C:\Users\Acer\OneDrive\Desktop\pg sql files\customers.csv'
csv header;

copy orders(Order_ID,Customer_ID,Book_ID,Order_Date,Quantity,Total_Amount)
from'C:\Users\Acer\OneDrive\Desktop\pg sql files\Orders.csv'
csv header;

select * from Books ;
select * from customers ;
select * from orders ;


-- 1) Retrive all the books to the 'fiction' genre ?
select * from Books where genre = 'Fiction';

-- 2) Find books Published After the year 1950 ?
select * from books where published_year > 1950;

--3) list all customers from the canada ?
select * from customers where country = 'Canada';

--4) show orders placed in november 2023 ?
select * from orders where order_date >=
'2023-11-01' and order_date <='2023-11-30' ;

--5) Retreive the total stock of books available?
select sum(stock)as total_stock from books;

--6) find the details of the most expensive book ?
select * from Books where price > 0 order by  price desc limit 1 ;

--7) show all customers who ordered more than 1 quaqntity of book ?
select * from orders where quantity >1 order by quantity ;

--8) retrive all orders where the total amount exceeds $ 20 ?
select * from orders where total_amount >  20 order by total_amount ;

--9) list all genrs availabe in the books table ?
select distinct genre from books;

--10)find the book with lowest stock ?
select * from books where stock >= 0 order by stock limit 1;

--11)calculate the total revenue generated from all orders ?
select sum(total_amount) as Total_Revenue from orders;

                  --Advance Queries --
--1)Retrieve the total number of books sold for each genre?
select books.genre,sum(orders.quantity)as total_Books_solds from
books 
join
orders
on 
 orders.book_id=Books.book_id
 group by genre; 

--2)Find the average price of books inthe fantasy genre?
select avg(price) as avg_price from
books where genre = 'Fantasy';

--3)List customers who have placed at least 2 orders?
select customers.Name, orders.customer_id, count(orders.order_id) as order_count 
from customers
join orders
on orders.customer_id = customers.customer_id
group by orders.customer_id, customers.name
having count(orders.order_id) >= 2;
--or--
select customer_id, count(order_id) as order_count 
from  orders
group by customer_id
having count(orders.order_id) >= 2;

--4)Find the most frequently ordered book?
select books.title,orders.book_id, count(order_id) as order_count from orders
join books
on orders.book_id = books.book_id
group by orders.book_id,books.title
order by order_count desc limit 1 ;

--5)Show the top 3 most expensive books of 'Fantasy'genre?
select * from Books where genre = 'Fantasy' order by  price desc limit 3 ;
 
--6)Retrieve the total quqntity of books  sold by each author?
select books.author,sum(orders.quantity) from 
books 
join 
orders
on
books.book_id = orders.Book_id group by author;

--7List the cities where customers who spent over $30 are located
select distinct customers.city,total_amount 
from orders  join customers
on orders.customer_id = customers.customer_id 
where orders.total_amount > 30;

--8)Find the customers who spent the most on orders?
select c.customer_id,c.name,sum(o.total_amount) as total_spent
from orders o join customers c
on  o.customer_id = c.customer_id 
group by c.customer_id,c.name
order by total_spent desc limit 3;

--9)Calculate the stock remaining after fulfilling all orders?
select b.book_id,b.title,b.stock,coalesce(sum(quantity),0) as order_qty,
b.stock-coalesce(sum(quantity),0)as remaining_qty
from books b
left join orders o on b.book_id=o.book_id
group by b.book_id order by b.book_id;