{{ config(materialized="table") }}

with
   sec_cte as (
    SELECT DISTINCT CUSIP, 
    o."CompID" AS compID,
    o."Symbol" AS symbol,
    o."Issue" AS company_name,
    o."SecType" AS sec_type, 
    -- missing security name from table "otc_securities"
    -- missing sector
    o."CaveatEmptor" AS caveat_emptor, 
    o."DAD_PAL" AS DAD_PAL

    from public."otcmarket.hhc390ihqgzwa4hy" AS o
)

select DISTINCT cusip
from sec_cte
WHERE cusip IS NOT NULL