
      
  
    
    

    create  table
      "tesla"."main"."tesla_price_history"
  
    as (
      
    

    select *,
        md5(coalesce(cast(vin as varchar ), '')
         || '|' || coalesce(cast(record_time_str as varchar ), '')
        ) as dbt_scd_id,
        record_time_str as dbt_updated_at,
        record_time_str as dbt_valid_from,
        
  
  coalesce(nullif(record_time_str, record_time_str), null)
  as dbt_valid_to
from (
        



select 
    vin,
    model,
    trim_name,
    year,
    price,
    country,
    record_time_str
from "tesla"."main"."stg_tesla_vehicles"
where price is not null

    ) sbq



    );
  
  
  