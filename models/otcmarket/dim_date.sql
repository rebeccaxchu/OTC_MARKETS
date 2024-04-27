{{
   config (
        materialized='table'
   )
}}


WITH date_cte AS (
   SELECT DISTINCT CAST(closingbest_biddate AS timestamp) as date_value FROM "otcmarket.hhc390ihqgzwa4hy"
   UNION
   SELECT DISTINCT CAST(closingbest_askdate AS timestamp) as date_value FROM "otcmarket.hhc390ihqgzwa4hy"
)


SELECT
 {{ date_to_yymmdd (date_Value) }} AS date_id, 
 date_value AS date_iso_format,
 EXTRACT (YEAR FROM date_value) AS yearNumber,
 EXTRACT (QUARTER FROM date_value) AS quarterNumber,
 EXTRACT (MONTH FROM date_value) AS monthNumber,
 TO_CHAR(date_value, 'Month') AS monthName,
 FLOOR (EXTRACT (day FROM date_value) - 1) / 7) + 1 AS weekOfMonth,
 EXTRACT (week FROM date_value) AS weekOfYear,
 EXTRACT (DAY FROM date_value) AS dayNumber,
 EXTRACT (isodow FROM date_value) AS dayofWeek,
 TO_CHAR(date_value, 'Day') AS dayName
FROM date_cte