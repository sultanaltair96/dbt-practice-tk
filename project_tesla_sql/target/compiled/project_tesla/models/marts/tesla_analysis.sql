

with stg_tesla as (
    select * from "tesla"."main"."stg_tesla_vehicles"
),

country_stats as (
    select
        country,
        count(*) as total_vehicles,
        round(avg(price), 2) as avg_price,
        round(avg(odometer), 2) as avg_odometer,
        count(case when had_accident then 1 end) as vehicles_with_accidents,
        round(count(case when had_accident then 1 end) * 100.0 / count(*), 2) as accident_percentage
    from stg_tesla
    group by country
),

model_analysis as (
    select
        model,
        trim_name,
        count(*) as total_count,
        round(avg(price), 2) as avg_price,
        min(price) as min_price,
        max(price) as max_price,
        round(avg(odometer), 2) as avg_odometer
    from stg_tesla
    group by model, trim_name
)

select 
    'country_stats' as analysis_type,
    country as dimension,
    total_vehicles as count,
    avg_price,
    null as min_price,
    null as max_price,
    avg_odometer,
    vehicles_with_accidents,
    accident_percentage,
    null as trim_name
from country_stats

union all

select
    'model_analysis' as analysis_type,
    model as dimension,
    total_count as count,
    avg_price,
    min_price,
    max_price,
    avg_odometer,
    null as vehicles_with_accidents,
    null as accident_percentage,
    trim_name
from model_analysis