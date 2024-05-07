{{ config(materialized='table') }}

WITH country_cte AS (
    SELECT DISTINCT 
        c.country
    FROM public."otcmarket.companyinfo" AS c
    WHERE c.country IS NOT NULL
      AND c.country !~ '^[0-9]+(\.[0-9]+)?$'
      AND c.country !~ '^(\d{4}-\d{2}-\d{2}|\d{2}/\d{4})$'
),
sec_cte AS (
    SELECT 
        c.symbol,
        c.company_name,
        c.tier_name,
        c.sec_type,
        c.country,
        s.sec_name,
        s.sector
    FROM public."otcmarket.companyinfo" AS c
    JOIN public."otcmarket.otc_securities" AS s ON c.symbol = s.symbol
    WHERE
        c.symbol IS NOT NULL
        AND s.symbol IS NOT NULL
        AND c.company_name IS NOT NULL
        AND c.sec_type IS NOT NULL
        AND TRIM(c.sec_type) <> ''
        AND s.sector IS NOT NULL
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
),
sec_with_country AS (
    SELECT 
        sec.symbol,
        sec.company_name,
        sec.tier_name,
        sec.sec_type,
        sec.sec_name,
        sec.sector,
        loc.country_id
    FROM sec_cte AS sec
    JOIN {{ ref('dim_location') }} loc ON sec.country = loc.country
)

SELECT *
FROM sec_with_country