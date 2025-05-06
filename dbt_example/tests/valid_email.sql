{% test valid_email(model, column_name) %}

WITH validation AS (
    SELECT {{ column_name }} AS email
    FROM {{ model }}
    WHERE {{ column_name }} IS NOT LIKE '%_@___%.__%' -- This regex checks for a basic email format
)

SELECT COUNT(*)
FROM validation

{% endtest %}