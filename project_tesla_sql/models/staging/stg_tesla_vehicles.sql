{{
    config(
        materialized='view'
    )
}}

with source_data as (
    select * from {{ ref('tesla_results') }}
),

staged as (
    select
        -- Basic vehicle information
        trim(model) as model,
        trim(trim_name) as trim_name,
        year,
        vin,
        
        -- Location information
        trim(country) as country,
        trim(country_code) as country_code,
        trim(city) as city,
        
        -- Price and metrics
        -- Extract numeric price from string
        regexp_extract(price, '[0-9]+') as price_str,
        try_cast(regexp_extract(price, '[0-9]+') as float) as price,
        try_cast(odometer as float) as odometer,
        
        -- Dates
        try_cast(original_delivery_date as timestamp) as delivery_date,
        try_cast(battery_warranty_exp_date as timestamp) as warranty_expiry_date,
        "current_time" as record_time_str,
        
        -- Additional attributes
        trim(color) as color,
        trim(vehicle_history) as vehicle_history,
        case 
            when vehicle_history is null then false
            when lower(vehicle_history) like '%accident%' then true
            else false
        end as had_accident,
        
        -- Status flags
        in_transit,
        trim(cpo_refurbishment_status) as refurbishment_status
    from source_data
)

select * from staged
