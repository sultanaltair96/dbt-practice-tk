
    
    

select
    vin as unique_field,
    count(*) as n_records

from "tesla"."tesla_data"."tesla_results"
where vin is not null
group by vin
having count(*) > 1


