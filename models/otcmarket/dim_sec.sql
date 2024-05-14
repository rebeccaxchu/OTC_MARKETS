{{ config(materialized='table') }}

WITH sec_cte AS (
    SELECT 
        c.symbol,
        c.company_name,
        c.tier_name,
        c.sec_type,
        loc.location_id,
        s.sec_name,
        s.sector
    FROM public."otcmarket.companyinfo" AS c
    JOIN public."otcmarket.otc_securities" AS s ON c.symbol = s.symbol
    JOIN {{ ref('dim_location') }} loc ON c.country = loc.country
    WHERE
        c.symbol IS NOT NULL
        AND s.symbol IS NOT NULL
        AND c.company_name IS NOT NULL
        AND c.sec_type IS NOT NULL
        AND s.sector IS NOT NULL
)

SELECT *
FROM sec_cte