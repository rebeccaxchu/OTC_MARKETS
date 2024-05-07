{{ config(materialized="table") }}

WITH venue_cte AS (
    SELECT DISTINCT
        venue_name
    FROM public."otcmarket.hhc390ihqgzwa4hy"
    WHERE venue_name IS NOT NULL
      AND venue_name IN ('BB', 'Grey Market', 'OTC Link', 'OTC Link/BB')
),
venues_with_id AS (
    SELECT 
        venue_name,
        ROW_NUMBER() OVER (ORDER BY venue_name) AS venue_id
    FROM venue_cte
)
SELECT venue_id, venue_name
FROM venues_with_id