{{ config(materialized='table') }}

WITH facts_cte AS (
    SELECT 
        ROW_NUMBER() OVER () AS fact_id,
        h.symbol,
        h.CUSIP,
        COALESCE(h.open_price::numeric(10,2), NULL) AS open_price,
        COALESCE(h.high_price::numeric(10,2), NULL) AS high_price,
        COALESCE(h.low_price::numeric(10,2), NULL) AS low_price,
        COALESCE(h.previous_closeprice::numeric(10,2), NULL) AS previous_closeprice,
        COALESCE(h.closingbest_bid::numeric(10,2), NULL) AS closingbest_bid,
        COALESCE(h.closingbest_ask::numeric(10,2), NULL) AS closingbest_ask,
        CASE
            WHEN h.closingbest_ask IS NOT NULL AND h.closingbest_bid IS NOT NULL THEN 
                (h.closingbest_ask::numeric(10,2) - h.closingbest_bid::numeric(10,2))
            ELSE NULL 
        END AS spread,
        COALESCE(h.dollar_vol::numeric(10,2), NULL) AS dollar_vol,
        COALESCE(h.share_vol::integer, NULL) AS share_vol,
        h.BFCMmid,
        COALESCE(h.shares_outstanding::bigint, NULL) AS shares_outstanding,
        d.date_id,
        st.status_id  -- Added the missing comma before this line
    FROM 
        public."otcmarket.hhc390ihqgzwa4hy" as h
    JOIN {{ ref('dim_sec') }} as s ON s.symbol = h.symbol
    JOIN {{ ref('dim_date') }} as d ON h."ClosingBestBidDate"::date = d.date_iso_format::date
    JOIN {{ ref('dim_status') }} AS st ON h."status_name" = st.status_name
)
SELECT *
FROM facts_cte
