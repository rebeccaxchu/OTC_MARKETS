{{
   config (
       materialized='table'
   )
}}

WITH StatusMapping AS (
    SELECT DISTINCT
        securitystatus,
        CASE 
            WHEN securitystatus = 'Active' THEN 101
            WHEN securitystatus = 'Halted' THEN 102
            WHEN securitystatus = 'Revoked' THEN 103
            WHEN securitystatus = 'Suspend' THEN 104
            ELSE 999 -- For any unexpected values
        END AS status_id
    FROM dbt_otcmarket."bjq0xakxhrwyjvu9"
)

SELECT 
    status_id, 
    securitystatus
FROM 
    StatusMapping