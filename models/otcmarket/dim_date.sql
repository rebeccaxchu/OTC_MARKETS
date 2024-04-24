{{
   config (
        materialized='table'
   )
}}


WITH date_cte AS (
   SELECT DISTINCT CAST(closingbest_biddate AS timestamp) as date_value FROM otc_market_raw 
   UNION
   SELECT DISTINCT CAST(closingbest_askdate AS timestamp) as date_value FROM otc_market_raw 
)


SELECT
 
 CAST(EXTRACT (YEAR FROM date_value) AS INTEGER) AS yearNumber,
 EXTRACT (MONTH FROM date_value) AS monthNumber,
 EXTRACT (DAY FROM date_value) AS dayNumber,
 EXTRACT (QUARTER FROM date_value) AS quarterNumber,
 TO_CHAR(date_value, 'Month') AS monthName,
 EXTRACT (isodow FROM date_value) AS dayofWeek,
 FLOOR (EXTRACT (day FROM date_value) - 1) / 7) + 1 AS weekofMonth,
 TO_CHAR(date_value, 'Day') AS dayName,
 EXTRACT (week FROM date_value) AS weekofYear
FROM date_cte