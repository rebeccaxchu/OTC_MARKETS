{{
   config (
       materialized='table'
   )
}}


WITH status_cte AS
(
   SELECT DISTINCT 
            securitystatus
       FROM public."otcmarket.hhc390ihqgzwa4hy"
)

select securityStatus
from status_cte
where securitystatus IS NOT NULL