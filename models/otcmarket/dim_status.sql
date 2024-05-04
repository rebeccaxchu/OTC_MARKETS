{{
   config (
       materialized='table'
   )
}}

WITH StatusMapping AS (
    SELECT 
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
    WHERE 
        status_name IS NOT NULL AND
        status_name !~ '^[0-9]+(\.[0-9]+)?$' AND
        status_name !~ '^(\d{4}-\d{2}-\d{2}|\d{2}/\d{2}/\d{4})$' AND
        status_name IN ('Active', 'Halted', 'Revoked', 'Suspend')
    GROUP BY 
        status_name
)

SELECT 
    status_id, 
    status_name
FROM 
    StatusMapping