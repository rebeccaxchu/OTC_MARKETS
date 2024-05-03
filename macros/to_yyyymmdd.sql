{% macro datetime_to_yyyymmddhh(column_name) %}
    CAST(TO_CHAR({{ column_name }}, 'YYYYMMDD') AS INTEGER)
{% endmacro %}