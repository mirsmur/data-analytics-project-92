--Этот запрос выводит общее количество покупателей
select count(customer_id) as customers_count from customers;

-- Этот запрос выводит 10 лучших по выручке продавцов
select
    concat(e.first_name, ' ', e.last_name) as seller,
    count(s.sales_id) as operations,
    floor(sum(s.quantity * price)) as income
from sales as s
left join employees as e
    on s.sales_person_id = e.employee_id
left join products as p
    on s.product_id = p.product_id
group by seller
order by income desc limit 10;

-- Этот запрос выводит отчет с продавцами, чья выручка ниже средней выручки всех продавцов
select
    seller,
    floor(average_income)
from (
    select
        concat(e.first_name, ' ', e.last_name) as seller,
        avg(s.quantity * price)
            over (partition by sales_person_id)
            as average_income,
        avg(s.quantity * price) over () as total_avg
    from sales as s
    left join products as p
        on s.product_id = p.product_id
    left join employees as e
        on s.sales_person_id = e.employee_id
    order by sales_person_id
)
where average_income < total_avg
group by seller, average_income
order by average_income;

-- Этот запрос выводит отчет с данными по выручке по каждому продавцу и дню недели
select
    seller,
    day_of_week,
    floor(sum(income)) as income
from (
    select
        concat(e.first_name, ' ', e.last_name) as seller,
        to_char(sale_date, 'Day') as day_of_week,
        sum(s.quantity * price) as income,
        extract(dow from sale_date) as num_of_day
    from sales as s
    left join employees as e
        on s.sales_person_id = e.employee_id
    left join products as p
        on s.product_id = p.product_id
    group by day_of_week, sale_date, seller
)
group by num_of_day, day_of_week, seller
order by num_of_day, seller;

-- Этот запрос считает количество покупателей в разных возрастных группах
select
    age_category,
    sum(age_count) as age_count
from (select
    age,
    (
        case
            when age > 40 then '40+'
            when age < 41 and age > 25 then '26-40'
            when age < 26 then '16-25'
            when age < 16 then 'child'
        end
    ) as age_category,
    count(age) as age_count
from customers
group by age)
group by age_category;

--Этот запрос считает количество уникальных покупателей в месяце и выручку, которую они принесли
select
    to_char(selling_month, 'YYYY-MM') as selling_month,
    sum(total_customers) as total_customers,
    sum(income) as income
from (
    select
        s.sale_date,
        floor(sum(s.quantity * price)) as income,
        date_trunc('month', s.sale_date) as selling_month,
        count(s.customer_id) as total_customers
    from sales as s
    left join customers as c
        on s.customer_id = c.customer_id
    left join products as p
        on s.product_id = p.product_id
    group by extract(month from s.sale_date), s.sale_date
)
group by selling_month
order by selling_month;

-- Этот запрос выводит список покупателей, пришедших по акционному предложению
select
    s.sale_date,
    concat(c.first_name, ' ', c.last_name) as customer,
    concat(e.first_name, ' ', e.last_name) as seller
from (
    select
        s.customer_id,
        min(s.sales_id) over (partition by s.customer_id) as sales_id
    from sales as s
    left join products as p
        on p.product_id = s.product_id
    where price = 0
    group by s.sales_id, s.customer_id
    order by s.sales_id
) as sub
left join sales as s
    on sub.sales_id = s.sales_id
left join customers as c
    on s.customer_id = c.customer_id
left join employees as e
    on s.sales_person_id = e.employee_id
group by sub.sales_id, sub.customer_id, customer, seller, sale_date
order by sub.customer_id;