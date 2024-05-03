{{ config(materialized="table") }}

WITH tier_cte AS 
(
    SELECT DISTINCT
        tier_id,
        tier_name
    FROM public."otcmarket.hhc390ihqgzwa4hy"
)

SELECT DISTINCT CAST (tier_id as integer), tier_name
from tier_cte
WHERE tier_id IS NOT NULL AND
    tier_id ~ '^\d+$' AND
    tier_id::integer >= 1 AND
    tier_id::integer < 41 AND
    tier_name IS NOT NULL AND tier_name !~ '^\d+$' AND
    (
        (tier_id::integer = 1 AND tier_name = 'OTCQX U.S. Premier') OR
        (tier_id::integer = 2 AND tier_name = 'OTCQX U.S.') OR
        (tier_id::integer = 6 AND tier_name = 'OTCQX International') OR
        (tier_id::integer = 10 AND tier_name = 'OTCQB') OR
        (tier_id::integer = 11 AND tier_name = 'FINRA BB Only') OR
        (tier_id::integer = 20 AND (tier_name = 'OTC Pink Current' OR tier_name = 'Pink Current')) OR
        (tier_id::integer = 21 AND (tier_name = 'OTC Pink Limited' OR tier_name = 'Pink Limited')) OR
        (tier_id::integer = 22 AND (tier_name = 'OTC Pink No Information' OR tier_name = 'Pink No Information')) OR
        (tier_id::integer = 30 AND tier_name = 'Grey Market') OR
        (tier_id::integer = 40 AND tier_name = 'Expert Market')
    )