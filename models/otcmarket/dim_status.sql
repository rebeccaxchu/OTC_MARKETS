{{
   config (
       materialized='table'
   )
}}

WITH StatusMapping AS (
    SELECT DISTINCT
        status_name,
        CASE 
            WHEN status_name = 'Active' THEN 101
            WHEN status_name = 'Halted' THEN 102
            WHEN status_name = 'Revoked' THEN 103
            WHEN status_name = 'Suspend' THEN 104
            ELSE 999 -- For any unexpected values
        END AS status_id
    FROM 
        public."otcmarket.hhc390ihqgzwa4hy"
)

SELECT 
    status_id, 
    status_name
FROM 
    StatusMapping