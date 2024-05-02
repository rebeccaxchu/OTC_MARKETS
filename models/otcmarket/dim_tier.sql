{{ config(materialized="table") }}

with 
    tier_cte as (
        select tier_id 
    from public."otcmarket.hhc390ihqgzwa4hy")

select cast(tier_id as integer)
from tier_cte
