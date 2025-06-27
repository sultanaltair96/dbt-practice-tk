
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select vin
from "tesla"."tesla_data"."tesla_results"
where vin is null



  
  
      
    ) dbt_internal_test