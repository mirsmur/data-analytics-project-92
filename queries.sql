--Этот запрос выводит общее количество покупателей
select count(customer_id) as customers_count from customers;

-- Этот запрос выводит 10 лучших по выручке продавцов
select concat(c.first_name, ' ', c.last_name) as seller,
	count(s.sales_id) as operations,
	floor(sum(s.quantity*price)) as income
from sales as s
left join employees  as c 
	on c.employee_id = s.sales_person_id 
left join products as p
	on p.product_id = s.product_id
group by seller
order by income desc limit 10;

-- Этот запрос выводит отчет с продавцами, чья выручка ниже средней выручки всех продавцов
select seller,
	floor(income/quantity) as average_income
from (
select concat(c.first_name, ' ', c.last_name) as seller,
	sum(s.quantity*price) as income,
	s.quantity,
	avg(s.quantity*price) over () as total_avg
from sales as s
left join employees  as c 
	on c.employee_id = s.sales_person_id 
left join products as p
	on p.product_id = s.product_id
group by sales_person_id, seller, s.quantity, price)
where income/quantity < total_avg
order by average_income;

-- Этот запрос выводит отчет с данными по выручке по каждому продавцу и дню недели
select seller,
	TO_CHAR(sale_date, 'Day') as day_of_week,
	floor(income)
from (
	select concat(e.first_name, ' ', e.last_name) as seller,
		EXTRACT(DOW from sale_date) as day_of_week,
		sum(s.quantity*price) as income,
		sale_date
	from sales as s
	left join employees  as e 
		on e.employee_id = s.sales_person_id 
	left join products as p
		on p.product_id = s.product_id
	group by day_of_week, sale_date, e.first_name, e.last_name
	order by day_of_week, seller);
-- Этот запрос считает количество покупателей в разных возрастных группах
select age_category,
	sum(age_count) as age_count
from (select (
	case 
		when age > 40 then '40+'
		when age < 41 and age > 25 then '26-40'
		when age < 26 then '16-25'
		when age < 16 then 'child'
	end) as age_category,
	count(age) as age_count,
	age
from customers
group by age)
group by age_category

--Этот запрос считает количество уникальных покупателей в месяце и выручку, которую они принесли
select to_char(selling_month, 'YYYY-MM') as selling_month,
	sum(total_customers) as total_customers,
	sum(income) as income
from (select floor(sum(s.quantity*price)) as income, 
		DATE_TRUNC ('month', s.sale_date) as selling_month,
		count(s.customer_id) as total_customers,
		s.sale_date
	from sales s
	left join customers c
		on c.customer_id = s.customer_id
	left join products p
		on p.product_id = s.product_id
		group by extract(month from s.sale_date), s.sale_date)
group by selling_month
order by selling_month

-- Этот запрос выводит список покупателей, пришедших по акционному предложению
select concat(c.first_name, ' ', c.last_name) as customer,
	sale_date,
	concat(e.first_name, ' ', e.last_name) as seller
from (select customer_id,
	sales_person_id,
	FIRST_VALUE(s.sale_date) over (order by customer_id) as sale_date
from sales s
left join products p 
	on p.product_id = s.product_id 
where price = 0) as sub
left join customers c
	on c.customer_id = sub.customer_id
left join employees e
	on e.employee_id = sub.sales_person_id
group by concat(c.first_name, ' ', c.last_name), sub.sale_date, concat(e.first_name, ' ', e.last_name),sub.customer_id
order by sub.customer_id

