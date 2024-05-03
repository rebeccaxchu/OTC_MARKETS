{{ config(materialized="table") }}

with
   sec_cte as 
(
    SELECT DISTINCT 
            h.CUSIP, 
            h.compid,
            h.symbol,
            h.company_name,
            h.sec_type, 
            s.sec_name,
            s.sector,
            h.caveat_emptor, 
            h.DAD_PAL
        from public."otcmarket.hhc390ihqgzwa4hy" AS h
        JOIN public."otcmarket.otc_securities" AS s
        ON h.symbol = s.symbol
)

select DISTINCT CUSIP, compid, symbol, company_name, sec_type ,sec_name, sector, caveat_emptor, DAD_PAL
from sec_cte
WHERE CUSIP IS NOT NULL
    AND company_name IS NOT NULL
    AND sec_type IS NOT NULL
    AND TRIM(sec_type) <> ''
    AND sector IS NOT NULL