{{
   config (
        materialized='table'
   )
}}

WITH date_cte AS (
    SELECT DISTINCT 
        CASE
            WHEN closingbestbiddate ~ '^\d{4}-\d{2}-\d{2}$' THEN CAST(closingbestbiddate AS DATE)
            ELSE NULL
        END AS date_value
    FROM dbt_otcmarket."bjq0xakxhrwyjvu9"
    WHERE closingbestbiddate IS NOT NULL
    AND closingbestaskdate IS NOT NULL
    AND closingbestbiddate = closingbestaskdate
)

SELECT
    {{ datetime_to_yyyymmddhh('date_value') }} AS date_id,
    date_value AS date_iso_format,
    EXTRACT(YEAR FROM date_value) AS yearNumber,
    EXTRACT(QUARTER FROM date_value) AS quarterNumber,
    EXTRACT(MONTH FROM date_value) AS monthNumber,
    TO_CHAR(date_value, 'Month') AS monthName,
    FLOOR((EXTRACT(DAY FROM date_value) - 1) / 7 + 1) AS weekOfMonth,
    EXTRACT(DAY FROM date_value) AS dayNumber,
    EXTRACT(ISODOW FROM date_value) AS dayOfWeek,
    TO_CHAR(date_value, 'Day') AS dayName,
    CAST(EXTRACT(WEEK FROM date_value) AS INTEGER) AS weekOfYear

FROM date_cte
WHERE date_value IS NOT NULL