{{
   config (
       materialized='table'
   )
}}

WITH country_cte AS (
    SELECT DISTINCT 
            c.country
    FROM public."otcmarket.companyinfo" AS c
    WHERE c.country IS NOT NULL
      AND c.country !~ '^[0-9]+(\.[0-9]+)?$'
      AND c.country !~ '^(\d{4}-\d{2}-\d{2}|\d{2}/\d{4})$'
),
country_with_id AS (
    SELECT DISTINCT
        country,
        CONCAT(
            UPPER(SUBSTRING(country FROM 1 FOR 1)),
            '-',
            LPAD(CAST(ROW_NUMBER() OVER (ORDER BY country) AS TEXT), 4, '0')
        ) AS country_id
    FROM country_cte
)

SELECT DISTINCT country_id, country
FROM country_with_id
