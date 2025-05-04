-- Query Comum

SELECT * 
FROM vendas
WHERE data_venda >= "2023-09-01"

-- Query com Jinja

SELECT *
FROM vendas
WHERE data_venda >= '{{ var("data_venda") }}'

-- Query com Jinja 2

SELECT *
FROM vendas
WHERE data_venda >= '{{ (execute_At | as_timestamp).strftime("%Y-%m-01") }}' -- data e hora da execução do dbt do primeiro dia do mês atual 

-- Loop com Jinja

SELECT 
    client_id,
    {% for mes in range(1, 13) %}
        SUM(CASE WHEN EXTRACT(MONTH FROM data_venda) = {{ mes }} THEN valor END) AS valor_mes_{{ mes }} {% if not loop.last %}, {% endif %}
    {% endfor %}
FROM vendas
GROUP BY client_id

-- condicional com Jinja

SELECT *
FROM vendas
WHERE
    {% if flag_ativo == true %}
        data_venda >= CURRENT_DATE - INTERVAL '30' DAY
    {% else %}
        data_venda IS NOT NULL
    {% endif %}