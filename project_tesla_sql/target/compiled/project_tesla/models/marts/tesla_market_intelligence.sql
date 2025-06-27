

with base_vehicles as (
    select * from "tesla_project"."main"."stg_tesla_vehicles"
),

-- Create a "Regional Market Performance" virtual table
regional_markets as (
    select
        country,
        city,
        count(*) as inventory_count,
        round(avg(price), 2) as avg_market_price,
        round(min(price), 2) as min_market_price,
        round(max(price), 2) as max_market_price,
        round(avg(odometer), 2) as avg_mileage,
        count(case when had_accident then 1 end) as accident_vehicles,
        round(count(case when had_accident then 1 end) * 100.0 / nullif(count(*), 0), 2) as accident_rate_pct,
        -- Market tier classification
        case 
            when avg(price) >= 80000 then 'Premium Market'
            when avg(price) >= 50000 then 'Mid-tier Market'
            else 'Entry Market'
        end as market_tier
    from base_vehicles
    where price is not null
    group by country, city
    having count(*) >= 3  -- Only include markets with meaningful inventory
),

-- Create a "Model Performance Metrics" virtual table
model_performance as (
    select
        model,
        trim_name,
        year,
        count(*) as model_inventory,
        round(avg(price), 2) as avg_model_price,
        round(avg(odometer), 2) as avg_model_mileage,
        -- Price depreciation per mile (proxy for value retention)
        case 
            when avg(odometer) > 0 then round((avg(price) / nullif(avg(odometer), 0)) * 1000, 2)
            else null
        end as price_per_1k_miles,
        -- Model condition score
        round((count(*) - count(case when had_accident then 1 end)) * 100.0 / nullif(count(*), 0), 2) as clean_history_pct,
        -- Categorize model popularity
        case 
            when count(*) >= 100 then 'High Volume'
            when count(*) >= 50 then 'Medium Volume'
            when count(*) >= 20 then 'Low Volume'
            else 'Rare'
        end as availability_tier
    from base_vehicles
    where price is not null and model is not null
    group by model, trim_name, year
),

-- Create comprehensive joined analysis
market_intelligence as (
    select
        -- Vehicle details
        v.vin,
        v.model,
        v.trim_name,
        v.year,
        v.price,
        v.odometer,
        v.color,
        v.had_accident,
        v.delivery_date,
        
        -- Regional market context (joined data)
        v.country,
        v.city,
        rm.market_tier,
        rm.inventory_count as city_inventory,
        rm.avg_market_price as city_avg_price,
        rm.accident_rate_pct as city_accident_rate,
        
        -- Model performance context (joined data)
        mp.model_inventory as total_model_inventory,
        mp.avg_model_price,
        mp.avg_model_mileage as model_avg_mileage,
        mp.price_per_1k_miles as model_value_retention,
        mp.clean_history_pct as model_clean_rate,
        mp.availability_tier,
        
        -- Calculated insights from joins
        round(v.price - rm.avg_market_price, 2) as price_vs_market_avg,
        round((v.price - rm.avg_market_price) * 100.0 / nullif(rm.avg_market_price, 0), 2) as price_premium_pct,
        round(v.price - mp.avg_model_price, 2) as price_vs_model_avg,
        round((v.price - mp.avg_model_price) * 100.0 / nullif(mp.avg_model_price, 0), 2) as model_price_variance_pct,
        
        -- Market positioning score (combination of regional and model factors)
        case
            when v.price > rm.avg_market_price and v.price > mp.avg_model_price and not v.had_accident then 'Premium Positioned'
            when v.price < rm.avg_market_price and v.price < mp.avg_model_price then 'Value Opportunity'
            when v.had_accident and v.price < mp.avg_model_price * 0.85 then 'Discounted - Accident History'
            when v.odometer < mp.avg_model_mileage * 0.7 then 'Low Mileage Premium'
            else 'Market Standard'
        end as market_position,
        
        -- Investment score (1-10 scale based on multiple factors)
        least(10, greatest(1, 
            5 +  -- Base score
            case when v.price < rm.avg_market_price then 2 else -1 end +  -- Below market price bonus
            case when v.odometer < mp.avg_model_mileage then 1 else 0 end +  -- Low mileage bonus
            case when not v.had_accident then 1 else -2 end +  -- Clean history bonus
            case when rm.market_tier = 'Premium Market' then 1 else 0 end +  -- Premium market bonus
            case when mp.availability_tier = 'Rare' then 2 else 0 end  -- Rarity bonus
        )) as investment_score
        
    from base_vehicles v
    
    -- Join with regional market data
    left join regional_markets rm
        on v.country = rm.country 
        and v.city = rm.city
    
    -- Join with model performance data  
    left join model_performance mp
        on v.model = mp.model 
        and v.trim_name = mp.trim_name 
        and v.year = mp.year
        
    where v.price is not null
)

select * from market_intelligence
order by investment_score desc, price asc