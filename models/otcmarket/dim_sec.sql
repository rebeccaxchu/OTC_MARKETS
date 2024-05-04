{{ config(materialized="table") }}

with
    sec_cte as (
        select c.*, s.sec_name, s.sector
        from public."otcmarket.companyinfo" as c
        join public."otcmarket.otc_securities" as s on c.symbol = s.symbol
        where
            c.symbol is not null
            and s.symbol is not null
            and c.company_name is not null
            and c.sec_type is not null
            and trim(c.sec_type) <> ''
            and s.sector is not null
    )

select *
from sec_cte
