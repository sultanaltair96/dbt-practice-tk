
    
    

select
    vin as unique_field,
    count(*) as n_records

from "tesla"."main"."stg_tesla_vehicles"
where vin is not null
group by vin
having count(*) > 1


