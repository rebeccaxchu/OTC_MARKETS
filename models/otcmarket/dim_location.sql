{{
   config (
       materialized='table'
   )
}}

WITH location_cte AS (
    SELECT DISTINCT 
            c.country
    FROM public."otcmarket.companyinfo" AS c
    WHERE c.country IS NOT NULL
      
),
location_with_id AS (
    SELECT 
        country,
        ROW_NUMBER() OVER (ORDER BY country) AS location_id
    FROM location_cte
)

SELECT location_id, country
FROM location_with_id