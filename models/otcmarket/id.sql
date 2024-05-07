 SELECT 
        ROW_NUMBER() OVER (ORDER BY h.symbol, h.CUSIP, h."ClosingBestBidDate") AS unique_id, 
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
        h.shares_outstanding::bigint AS shares_outstanding
        FROM 
        public."otcmarket.hhc390ihqgzwa4hy" AS h