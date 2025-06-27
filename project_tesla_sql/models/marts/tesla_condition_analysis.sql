{{
    config(
        materialized='table'
    )
}}

-- Step 1: Get base vehicle data
with stg_tesla as (
    select * from {{ ref('stg_tesla_vehicles') }}
),

-- Step 2: Categorize vehicles by age
vehicle_age_categories as (
    select 
        *,
        extract(year from current_date) - year as vehicle_age,
        case
            when extract(year from current_date) - year <= 1 then 'New (0-1 years)'
            when extract(year from current_date) - year <= 3 then 'Recent (1-3 years)'
            when extract(year from current_date) - year <= 5 then 'Mid-age (3-5 years)'
            else 'Older (5+ years)'
        end as age_category
    from stg_tesla
),

-- Step 3: Calculate accident statistics by age category
accident_by_age as (
    select
        age_category,
        count(*) as total_vehicles,
        sum(case when had_accident then 1 else 0 end) as accident_count,
        round(sum(case when had_accident then 1 else 0 end) * 100.0 / count(*), 2) as accident_percentage
    from vehicle_age_categories
    group by age_category
),

-- Step 4: Calculate accident statistics by model
accident_by_model as (
    select
        model,
        count(*) as total_vehicles,
        sum(case when had_accident then 1 else 0 end) as accident_count,
        round(sum(case when had_accident then 1 else 0 end) * 100.0 / count(*), 2) as accident_percentage
    from stg_tesla
    group by model
),

-- Step 5: Calculate mileage statistics by model and year
mileage_stats as (
    select
        model,
        year,
        count(*) as total_vehicles,
        round(avg(odometer), 2) as avg_mileage,
        min(odometer) as min_mileage,
        max(odometer) as max_mileage,
        round(stddev(odometer), 2) as mileage_stddev
    from stg_tesla
    where odometer is not null
    group by model, year
)

-- Combine all the analyses into a single result
select 
    'Accident Stats by Age' as analysis_type,
    age_category as dimension,
    total_vehicles,
    accident_count,
    accident_percentage,
    null as avg_mileage,
    null as model,
    null as year
from accident_by_age

union all

select 
    'Accident Stats by Model' as analysis_type,
    model as dimension,
    total_vehicles,
    accident_count,
    accident_percentage,
    null as avg_mileage,
    model,
    null as year
from accident_by_model

union all

select 
    'Mileage Stats by Model/Year' as analysis_type,
    model || ' (' || year || ')' as dimension,
    total_vehicles,
    null as accident_count,
    null as accident_percentage,
    avg_mileage,
    model,
    year
from mileage_stats
