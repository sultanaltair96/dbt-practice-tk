
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  

with validation as (
    select
        price as value_field
    from "tesla"."main"."stg_tesla_vehicles"
    where price is not null and price <= 0
)

select *
from validation


  
  
      
    ) dbt_internal_test