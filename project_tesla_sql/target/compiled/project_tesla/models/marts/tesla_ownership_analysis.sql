

with stg_tesla as (
    select * from "tesla"."main"."stg_tesla_vehicles"
),

enhanced_data as (
    select
        
    case
        when vin is null then null
        when length(vin) < 10 then null
        else upper(regexp_replace(vin, '[^A-Za-z0-9]', ''))
    end
 as clean_vin,
        model,
        trim_name,
        year,
        price,
        
    case
        when price is null then 'Unknown'
        when price < 20000 then 'Budget (< 20K)'
        when price < 30000 then 'Value (20K-30K)'
        when price < 40000 then 'Mid-Range (30K-40K)'
        when price < 50000 then 'Premium (40K-50K)'
        else 'Luxury (50K+)'
    end
 as price_category,
        odometer,
        country,
        delivery_date,
        record_time_str,
        case 
            when delivery_date is not null and try_cast(record_time_str as timestamp) is not null then
                
    ((extract(year from try_cast(record_time_str as timestamp)) - extract(year from delivery_date)) + 
     (extract(month from try_cast(record_time_str as timestamp)) - extract(month from delivery_date)) / 12.0 + 
     (extract(day from try_cast(record_time_str as timestamp)) - extract(day from delivery_date)) / 365.0)

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