{{
   config (
       materialized='table'
   )
}}

WITH status_cte AS
(
   SELECT DISTINCT 
            status_name
    FROM public."otcmarket.hhc390ihqgzwa4hy"
    WHERE status_name IS NOT NULL
      AND status_name !~ '^[0-9]+(\.[0-9]+)?$'
      AND status_name !~ '^(\d{4}-\d{2}-\d{2}|\d{2}/\d{2}/\d{4})$'
      AND status_name IN ('Active', 'Halted', 'Revoked', 'Suspend')
),
status_with_id AS (
    SELECT 
        status_name,
        ROW_NUMBER() OVER (ORDER BY status_name) AS status_id
    FROM status_cte
)
SELECT status_id, status_name
FROM status_with_id