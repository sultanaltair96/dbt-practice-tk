
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  

with validation as (
    select
        year as value_field
    from "tesla"."main"."stg_tesla_vehicles"
    where year is not null and year <= 0
)

select *
from validation


  
  
      
    ) dbt_internal_test