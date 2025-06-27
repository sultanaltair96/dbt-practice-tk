{{
    config(
        materialized='incremental',
        unique_key='vin'
    )
}}

with source_data as (
    select * from {{ ref('stg_tesla_vehicles') }}
    
    {% if is_incremental() %}
        -- This filter will only be applied on an incremental run
        where record_time_str > (select max(record_time_str) from {{ this }})
    {% endif %}
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
