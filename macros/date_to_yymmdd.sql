{% macro date_to_yymmdd(date) %}
  SELECT
    CAST(TO_CHAR({{ date_string }}, 'YYYYMMDD') AS INTEGER) AS date_int
{% endmacro %}