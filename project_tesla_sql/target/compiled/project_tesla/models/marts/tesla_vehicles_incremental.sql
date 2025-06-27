

with source_data as (
    select * from "tesla"."main"."stg_tesla_vehicles"
    
    
        -- This filter will only be applied on an incremental run
        where record_time_str > (select max(record_time_str) from "tesla"."main"."tesla_vehicles_incremental")
    
)

select
    vin,
    model,
    trim_name,
    year,
    country,
    city,
    price,
    odometer,
    delivery_date,
    had_accident,
    refurbishment_status,
    color,
    record_time_str
from source_data