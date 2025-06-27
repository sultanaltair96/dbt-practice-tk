-- This analysis helps identify the most valuable Tesla inventory

with vehicles as (
    select * from "tesla"."main"."stg_tesla_vehicles"
),

value_score as (
    select 
        vin,
        model,
        trim_name,
        year,
        price,
        odometer,
        country,
        had_accident,
        -- Calculate a "value score" based on price, age, and condition
        price * (
            (1.0 - (extract(year from current_date) - year) * 0.1) -- Age devaluation
            * (case when had_accident then 0.7 else 1.0 end) -- Accident devaluation
            * (case 
                when odometer is null then 0.9 
                else (1.0 - least(odometer / 200000, 0.7)) -- Mileage devaluation
              end)
        ) as value_score
    from vehicles
    where price is not null
),

ranked_vehicles as (
    select 
        *,
        row_number() over (partition by model order by value_score desc) as model_value_rank,
        row_number() over (order by value_score desc) as overall_value_rank
    from value_score
)

-- Top 10 vehicles by overall value
select 
    vin,
    model,
    trim_name,
    year,
    price,
    odometer,
    country,
    had_accident,
    round(value_score, 2) as value_score,
    overall_value_rank
from ranked_vehicles
where overall_value_rank <= 10
order by overall_value_rank