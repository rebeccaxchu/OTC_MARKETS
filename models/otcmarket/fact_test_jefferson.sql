{{ config(materialized='table') }}

WITH facts_cte AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY h.symbol, h.CUSIP, h."ClosingBestBidDate") AS unique_id, -- Generates a unique ID
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
        st.status_id,
        v.venue_id,
        t.tier_id
    FROM 
        public."otcmarket.hhc390ihqgzwa4hy" as h
    JOIN {{ ref('dim_sec') }} as s ON s.symbol = h.symbol
    JOIN {{ ref('dim_date') }} as d ON h."ClosingBestBidDate"::date = d.date_iso_format::date
    JOIN {{ ref('dim_status') }} AS st ON h."status_name" = st.status_name
    JOIN {{ ref('dim_venue') }} AS v ON h."venue_name" = v.venue_name
    JOIN {{ ref('dim_tier') }} AS t ON h."tier_name" = t.tier_name
),
batched AS (
    SELECT *,
        NTILE(CEILING(COUNT(*) OVER() / 50000.0)) OVER(ORDER BY unique_id) AS batch_number -- Calculates the batch number
    FROM facts_cte
)

--- This query will return the first batch of 50,000 rows and insert them into the table facts. You should change the batch number to fetch other batches. I would recommend that everyone
--- fetches the first batch first to make sure the query works as expected. Then split the batch between the team members to fetch the rest of the data.

SELECT *
FROM batched
WHERE batch_number = 1 -- Adjust this number to fetch other batches (1, 2, 3, ...)
ORDER BY unique_id;

