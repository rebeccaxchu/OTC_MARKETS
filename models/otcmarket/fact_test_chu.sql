{{ config(materialized='table') }}

WITH facts_cte AS (
    SELECT 
        ROW_NUMBER() OVER () AS fact_id,
        h.symbol,
        h.CUSIP,
        h.open_price::numeric(10,2) AS open_price,
        h.high_price::numeric(10,2) AS high_price,
        h.low_price::numeric(10,2) AS low_price,
        h.previous_closeprice::numeric(10,2) AS previous_closeprice,
        h.closingbest_bid::numeric(10,2) AS closingbest_bid,
        h.closingbest_ask::numeric(10,2) AS closingbest_ask,
        CASE
            WHEN h.closingbest_ask IS NOT NULL AND h.closingbest_bid IS NOT NULL THEN 
                (h.closingbest_ask::numeric(10,2) - h.closingbest_bid::numeric(10,2))
            ELSE NULL 
        END AS spread,
        h.dollar_vol::numeric(10,2) AS dollar_vol,
        h.share_vol::integer AS share_vol,
        h.BFCMmid,
        h.shares_outstanding::bigint AS shares_outstanding,
        d.date_id,
        st.status_id,
        v.venue_id,
        t.tier_id
    FROM 
        public."otcmarket.hhc390ihqgzwa4hy" AS h
    JOIN {{ ref('dim_sec') }} AS s ON s.symbol = h.symbol
    JOIN {{ ref('dim_date') }} AS d ON h."ClosingBestBidDate"::date = d.date_iso_format::date
    JOIN {{ ref('dim_status') }} AS st ON h."status_name" = st.status_name
    JOIN {{ ref('dim_venue') }} AS v ON h."venue_name" = v.venue_name
    JOIN {{ ref('dim_tier') }} AS t ON h."tier_name" = t.tier_name
    WHERE h.open_price IS NOT NULL -- Example filter condition to exclude irrelevant rows
)
SELECT * FROM facts_cte