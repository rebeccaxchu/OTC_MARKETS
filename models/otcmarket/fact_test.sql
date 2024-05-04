{{ config(materialized='table') }}

SELECT DISTINCT
    ROW_NUMBER() OVER () AS fact_id,
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
    h.share_vol,
    t.tier_id,
    v.venue_id,
    s.status_id,
    l.location_id,
    bd.closingbest_biddateID,
    ad.closingbest_askdateID,
    (SELECT tier_id FROM {{ ref('dim_tier') }} WHERE tier_name = h.tier_name) AS tier_id,
    (SELECT CUSIP FROM {{ ref('dim_sec') }} WHERE sec_name = h.sec_name) AS CUSIP,
    (SELECT venue_id FROM {{ ref('dim_venue') }} WHERE venue_name = h.venue_name) AS venue_id,
    (SELECT status_id FROM {{ ref('dim_status') }} WHERE status_name = h.status_name) AS status_id,
    (SELECT location_id FROM {{ ref('dim_location') }} WHERE country = h.country AND state = h.state) AS location_id,
    (SELECT date_id FROM {{ ref('dim_date') }} WHERE date_iso_format = h.ClosingBestBidDate) AS closingbest_biddateid,
    (SELECT date_id FROM {{ ref('dim_date') }} WHERE date_iso_format = h.ClosingBestAskDate) AS closingbest_askdateid
FROM public."otcmarket.hhc390ihqgzwa4hy" AS h
WHERE h.CUSIP IS NOT NULL
