{{
   config (
        materialized='table'
   )
}}

WITH date_cte AS (
   SELECT DISTINCT ClosingBestBidDate AS date_value FROM otcmarket.hhc390ihqgzwa4hy
   UNION
   SELECT DISTINCT ClosingBestAskDate AS date_value FROM otcmarket.hhc390ihqgzwa4hy
)
SELECT * FROM date_cte LIMIT 10