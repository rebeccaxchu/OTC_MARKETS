{% macro date_to_yymmdd(date) %}
  SELECT
    CAST(TO_CHAR({{ date }}, 'YYYYMMDD') AS INTEGER) AS date_int
{% endmacro %}