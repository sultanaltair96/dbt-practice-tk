
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    vin as unique_field,
    count(*) as n_records

from "tesla"."tesla_data"."tesla_results"
where vin is not null
group by vin
having count(*) > 1



  
  
      
    ) dbt_internal_test