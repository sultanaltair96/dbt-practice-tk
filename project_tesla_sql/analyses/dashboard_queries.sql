-- Tesla Inventory Dashboard

-- 1. Price Distribution by Model
select
    model,
    count(*) as vehicle_count,
    min(price) as min_price,
    round(avg(price), 2) as avg_price,
    max(price) as max_price,
    round(stddev(price), 2) as price_stddev
from main.stg_tesla_vehicles
where price is not null
group by model
order by avg_price desc;

-- 2. Vehicle Age Distribution
select
    extract(year from current_date) - year as vehicle_age,
    count(*) as vehicle_count
from main.stg_tesla_vehicles
group by vehicle_age
order by vehicle_age;

-- 3. Accident Rate by Country
select
    country,
    count(*) as total_vehicles,
    sum(case when had_accident then 1 else 0 end) as accident_count,
    round(sum(case when had_accident then 1 else 0 end) * 100.0 / count(*), 2) as accident_percentage
from main.stg_tesla_vehicles
group by country
having count(*) > 10
order by accident_percentage desc;

-- 4. Average Mileage by Model and Year
select
    model,
    year,
    round(avg(odometer), 2) as avg_mileage,
    count(*) as vehicle_count
from main.stg_tesla_vehicles
where odometer is not null
group by model, year
order by model, year desc;

-- 5. Price Trend Over Time
select
    country,
    model,
    year,
    round(avg(price), 2) as avg_price
from main.stg_tesla_vehicles
where price is not null
group by country, model, year
order by country, model, year;
