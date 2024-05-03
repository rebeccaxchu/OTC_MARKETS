{{
   config (
       materialized='table'
   )
}}

WITH location_cte AS
(
   SELECT DISTINCT 
            c.country,
            c.state
    FROM public."otcmarket.companyinfo" AS c
    JOIN public."otcmarket.companyinfo" AS h
    ON c.symbol = h.symbol

    WHERE c.country IS NOT NULL
      AND c.country !~ '^[0-9]+(\.[0-9]+)?$'
      AND c.country !~ '^(\d{4}-\d{2}-\d{2}|\d{2}/\d{2}/\d{4})$'
),
location_with_id AS (
    SELECT DISTINCT
        country,
        state,
        ROW_NUMBER() OVER (ORDER BY country, state) AS location_id
    FROM location_cte
)

SELECT DISTINCT location_id, country, state
FROM location_with_id