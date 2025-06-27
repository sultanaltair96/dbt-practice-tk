{{
    config(
        materialized='table'
    )
}}

with stg_tesla as (
    select * from {{ ref('stg_tesla_vehicles') }}
    where price is not null
),

country_model_stats as (
    select
        country,
        model,
        trim_name,
        year,
        round(avg(price), 2) as avg_price,
        count(*) as vehicle_count,
        min(price) as min_price,
        max(price) as max_price,
        round(stddev(price), 2) as price_stddev
    from stg_tesla
    group by country, model, trim_name, year
),

price_ranks as (
    select
        *,
        row_number() over (partition by country, model order by avg_price desc) as price_rank,
        avg_price - lag(avg_price) over (partition by country, model order by year) as price_diff_from_prev_year,
        round(avg_price / avg(avg_price) over (partition by country, model) * 100, 2) as percent_of_avg_model_price
    from country_model_stats
)

select * from price_ranks
order by country, model, year desc
