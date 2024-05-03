{{
   config (
        materialized='table'
   )
}}

WITH date_cte AS (
   SELECT DISTINCT "ClosingBestBidDate" AS date_value FROM public."otcmarket.hhc390ihqgzwa4hy"
   UNION
   SELECT DISTINCT "ClosingBestAskDate" AS date_value FROM public."otcmarket.hhc390ihqgzwa4hy"
)
SELECT
    {{ date_to_yymmdd('date_value') }} AS date_id,
    date_value AS date_iso,
    EXTRACT(YEAR FROM date_value) AS yearNumber,
    EXTRACT(QUARTER FROM date_value) AS quarterNumber,
    EXTRACT(MONTH FROM date_value) AS monthNumber,
    TO_CHAR(date_value, 'Month') AS monthName,
    FLOOR((EXTRACT(DAY FROM date_value) - 1) / 7 + 1) AS weekOfMonth,
    EXTRACT(WEEK FROM date_value) AS weekOfYear,
    EXTRACT(DAY FROM date_value) AS dayNumber,
    EXTRACT(ISODOW FROM date_value) AS dayOfWeek,
    TO_CHAR(date_value, 'Day') AS dayName

FROM date_cte
WHERE date_value IS NOT NULL

