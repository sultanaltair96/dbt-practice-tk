

with validation as (
    select
        price as value_field
    from "tesla"."main"."stg_tesla_vehicles"
    where price is not null and price <= 0
)

select *
from validation

