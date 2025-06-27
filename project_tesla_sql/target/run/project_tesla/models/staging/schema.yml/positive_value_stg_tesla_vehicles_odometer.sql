
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  

with validation as (
    select
        odometer as value_field
    from "tesla"."main"."stg_tesla_vehicles"
    where odometer is not null and odometer <= 0
)

select *
from validation


  
  
      
    ) dbt_internal_test