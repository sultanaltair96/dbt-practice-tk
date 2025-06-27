
        
            delete from "tesla"."main"."tesla_vehicles_incremental"
            where (
                vin) in (
                select (vin)
                from "tesla_vehicles_incremental__dbt_tmp20250621234559723963"
            );

        
    

    insert into "tesla"."main"."tesla_vehicles_incremental" ("vin", "model", "trim_name", "year", "country", "city", "price", "odometer", "delivery_date", "had_accident", "refurbishment_status", "color", "record_time_str")
    (
        select "vin", "model", "trim_name", "year", "country", "city", "price", "odometer", "delivery_date", "had_accident", "refurbishment_status", "color", "record_time_str"
        from "tesla_vehicles_incremental__dbt_tmp20250621234559723963"
    )
  