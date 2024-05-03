{{ config(materialized="table") }}

with
   facts_cte as 
(
    SELECT DISTINCT 
        h.CUSIP,
        h.open_price,
        h.high_price,
        h.low_price,
        h.previous_closeprice,
        h.shares_outstanding,
        h.BFCMmid,
        h.closingbest_bid,
        h.closingbest_ask,
        h.spread,
        h.dollar_vol,
        h.share_vol
        t.tier_id,
        v.venue_id,
        s.status_id,
        l.location_id,
        bd.closingbest_biddateID,
        ad.closingbest_askdateID

        FROM public."otcmarket.hhc390ihqgzwa4hy" AS h
        INNER JOIN dbt_otcmarket.dim_tier t ON t.tier_id = CAST(h.tier_id)
)

SELECT DISTINCT CUSIP, open_price, high_price, low_price, previous_closeprice,
        shares_outstanding, BFCMmid, closingbest_bid, closingbest_ask, spread,
        dollar_vol, share_vol
FROM facts_cte