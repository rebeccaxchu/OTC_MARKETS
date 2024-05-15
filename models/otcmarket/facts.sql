{{ config(materialized="table") }}

with
    fact_cte as (
        select
            cusip,
            max(t.tier_id::INTEGER) as tier_id,
            max(v.venue_id::INTEGER) as venue_id,
            max(st.status_id::INTEGER) as status_id,
            max(s.location_id::INTEGER) as location_id,
            max(d.date_id::INTEGER) as date_id,
            max(compid::numeric) as compid,
            b.symbol,
            closingbestbiddate as date,
            avg(
                (closingbestask::numeric - closingbestbid::numeric)
            ) as spread,
            max(closingbestask::numeric) as closingbest_ask,
            max(closingbestbid::numeric) as closingbest_bid,
            max(sharesoutstanding::numeric) as shares_outstanding,
            max(sharevolume::numeric) as share_vol,
            max(dollarvol::numeric) as dollar_vol
        from dbt_otcmarket."bjq0xakxhrwyjvu9" as b
        join {{ ref("dim_sec") }} as s on b.symbol = s.symbol
        join
            {{ ref("dim_calendar") }} as d
            on b.closingbestbiddate::date = d.date_iso_format::date
        join {{ ref("dim_status") }} as st on b.securitystatus = st.status_name
        join {{ ref("dim_venue") }} as v on b.venue = v.venue_name
        join {{ ref("dim_tier") }} as t on b.tiername = t.tier_name
        where closingbestbiddate = closingbestaskdate
        group by b.symbol, closingbestbiddate, b.cusip
    )

select *
from fact_cte