{{
   config(
       materialized='table'
   )
}}

WITH facts_cte AS (
    SELECT 
        ROW_NUMBER() OVER () AS fact_id,
        h.symbol,
        h.CUSIP,
        CASE WHEN h.open_price IS NOT NULL THEN h.open_price::numeric(10,2) ELSE NULL END AS open_price,
        CASE WHEN h.high_price IS NOT NULL THEN h.high_price::numeric(10,2) ELSE NULL END AS high_price,
        CASE WHEN h.low_price IS NOT NULL THEN h.low_price::numeric(10,2) ELSE NULL END AS low_price,
        CASE WHEN h.previous_closeprice IS NOT NULL THEN h.previous_closeprice::numeric(10,2) ELSE NULL END AS previous_closeprice,
        CASE WHEN h.closingbest_bid IS NOT NULL THEN h.closingbest_bid::numeric(10,2) ELSE NULL END AS closingbest_bid,
        CASE WHEN h.closingbest_ask IS NOT NULL THEN h.closingbest_ask::numeric(10,2) ELSE NULL END AS closingbest_ask,
        CASE
            WHEN h.closingbest_ask IS NOT NULL AND h.closingbest_bid IS NOT NULL THEN 
                (h.closingbest_ask::numeric(10,2) - h.closingbest_bid::numeric(10,2))
            ELSE NULL 
        END AS spread,
        CASE WHEN h.dollar_vol IS NOT NULL THEN h.dollar_vol::numeric(10,2) ELSE NULL END AS dollar_vol,
        CASE WHEN h.share_vol IS NOT NULL THEN h.share_vol::integer ELSE NULL END AS share_vol,
        h.BFCMmid,
        CASE WHEN h.shares_outstanding IS NOT NULL THEN h.shares_outstanding::bigint ELSE NULL END AS shares_outstanding
    FROM 
        public."otcmarket.hhc390ihqgzwa4hy" as h
    JOIN {{ ref('dim_sec') }} as s ON s.symbol = h.symbol
)
SELECT *
FROM facts_cte