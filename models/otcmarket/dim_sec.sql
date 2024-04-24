{{
   config (
       materialized='table'
   )
}}


WITH CUSIP_cte AS
{
   SELECT DISTINCT
       CUSIP
       FROM public.otc_market_raw
}
