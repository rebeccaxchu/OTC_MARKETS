{{ config(materialized="table") }}

WITH tier_cte AS 
(
    SELECT
        tier_id
    FROM public."otcmarket.hhc390ihqgzwa4hy"
)

SELECT CAST (tier_id as integer)
from tier_cte
WHERE tier_id IS NOT NULL