{{ config(materialized="table") }}

WITH tier_cte AS 
(
    SELECT DISTINCT
        tierid AS tier_id,
        tiername AS tier_name
    FROM dbt_otcmarket."bjq0xakxhrwyjvu9"
)

SELECT CAST(tier_id AS INTEGER), tier_name
from tier_cte