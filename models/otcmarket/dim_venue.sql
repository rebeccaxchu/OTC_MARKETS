{{ config(materialized="table") }}

WITH venue_cte AS (
    SELECT DISTINCT
        venue as venue_name
    FROM dbt_otcmarket."bjq0xakxhrwyjvu9"
    WHERE venue IS NOT NULL

),
venues_with_id AS (
    SELECT 
        venue_name,
        ROW_NUMBER() OVER (ORDER BY venue_name) AS venue_id
    FROM venue_cte
)
SELECT venue_id, venue_name
FROM venues_with_id