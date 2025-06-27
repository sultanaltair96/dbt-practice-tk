

with validation as (
    select
        odometer as value_field
    from "tesla"."main"."stg_tesla_vehicles"
    where odometer is not null and odometer <= 0
)

select *
from validation

