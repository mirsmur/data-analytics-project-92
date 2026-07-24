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
