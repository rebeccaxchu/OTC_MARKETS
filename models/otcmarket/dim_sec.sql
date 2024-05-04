{{ config(materialized="table") }}

with
   sec_cte as 
(
    SELECT  
        c.*,
        s.sec_name,
        s.sector
    from public."otcmarket.companyinfo" AS c
    JOIN public."otcmarket.otc_securities" AS s
    ON  c.symbol = s.symbol
    WHERE c.symbol IS NOT NULL
    AND s.symbol IS NOT NULL
    AND c.company_name IS NOT NULL
    AND c.sec_type IS NOT NULL
    AND TRIM(c.sec_type) <> ''
    AND s.sector IS NOT NULL
)

select *
from sec_cte
