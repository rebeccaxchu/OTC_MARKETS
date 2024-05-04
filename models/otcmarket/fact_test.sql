SELECT
    ROW_NUMBER() OVER () AS fact_id,
    h.CUSIP::int,
    h.open_price::float,
    h.high_price::float,
    h.low_price::float,
    h.previous_closeprice::float,
    h.shares_outstanding::int,
    h.BFCMmid::int,
    h.closingbest_bid::numeric,
    h.closingbest_ask::numeric,
    (h.closingbest_ask::numeric - h.closingbest_bid::numeric) AS spread,
    h.dollar_vol::int,
    h.share_vol::int,
    t.tier_id::int,
    v.venue_id::int,
    s.status_id::int,
    l.location_id::int,
    bd.closingbest_biddateID::int,
    ad.closingbest_askdateID::int
FROM
    public."otcmarket.hhc390ihqgzwa4hy" AS h
    JOIN {{ ref('dim_tier') }} AS t ON t.tier_id = (SELECT tier_id FROM {{ ref('dim_tier') }} WHERE tier_name = h.tier_name)
    JOIN {{ ref('dim_sec') }} AS s ON s.CUSIP = (SELECT CUSIP FROM {{ ref('dim_sec') }} WHERE sec_name = h.sec_name)
    JOIN {{ ref('dim_venue') }} AS v ON v.venue_id = (SELECT venue_id FROM {{ ref('dim_venue') }} WHERE venue_name = h.venue_name)
    JOIN {{ ref('dim_status') }} AS st ON st.status_id = (SELECT status_id FROM {{ ref('dim_status') }} WHERE status_name = h.status_name)
    JOIN {{ ref('dim_location') }} AS l ON l.location_id = (SELECT location_id FROM {{ ref('dim_location') }} WHERE country = h.country AND state = h.state)
    JOIN {{ ref('dim_date') }} AS bd ON bd.date_id = h.ClosingBestBidDate
    JOIN {{ ref('dim_date') }} AS ad ON ad.date_id = h.ClosingBestAskDate
WHERE
    h.CUSIP IS NOT NULL;
