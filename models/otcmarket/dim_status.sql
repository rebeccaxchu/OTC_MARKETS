{{ config(materialized="table") }}

WITH status_cte AS (
    SELECT DISTINCT
        securitystatus as status_name
    FROM dbt_otcmarket."bjq0xakxhrwyjvu9"
    WHERE securitystatus IS NOT NULL

),
status_with_id AS (
    SELECT 
        status_name,
        ROW_NUMBER() OVER (ORDER BY status_name) AS status_id
    FROM status_cte
)
SELECT status_id, status_name
FROM status_with_id