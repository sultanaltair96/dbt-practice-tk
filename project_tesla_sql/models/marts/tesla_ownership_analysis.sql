{{
    config(
        materialized='table'
    )
}}

with stg_tesla as (
    select * from {{ ref('stg_tesla_vehicles') }}
),

enhanced_data as (
    select
        {{ clean_vin('vin') }} as clean_vin,
        model,
        trim_name,
        year,
        price,
        {{ price_category('price') }} as price_category,
        odometer,
        country,
        delivery_date,
        record_time_str,
        case 
            when delivery_date is not null and try_cast(record_time_str as timestamp) is not null then
                {{ date_diff_in_years("try_cast(record_time_str as timestamp)", "delivery_date") }}
            else null
        end as ownership_years,
        had_accident
    from stg_tesla
),

ownership_analysis as (
    select
        price_category,
        count(*) as vehicle_count,
        round(avg(price), 2) as avg_price,
        round(avg(ownership_years), 2) as avg_ownership_years,
        round(avg(odometer), 2) as avg_odometer,
        round(avg(case when had_accident then 1.0 else 0.0 end) * 100, 2) as accident_percentage
    from enhanced_data
    where ownership_years is not null
    group by price_category
)

select * from ownership_analysis
order by avg_price
