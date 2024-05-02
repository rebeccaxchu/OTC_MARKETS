{{ config(materialized="table") }}

with
    venue_cte as (
        select DISTINCT
            "Venue"
        from public."otcmarket.hhc390ihqgzwa4hy"
        where "Venue" is not null
    )
select DISTINCT "Venue"
from venue_cte