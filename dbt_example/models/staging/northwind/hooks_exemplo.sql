{{
    config(
        pre_hook=[
            "CREATE TABLE IF NOT EXISTS temp_clientes AS SELECT * FROM clientes LIMIT 100"
        ],
        post_hook=[
            "DROP TABLE IF EXISTS temp_clientes"
        ]
    )
}}

SELECT * FROM temp_clientes

----

{{
    config(
        pre_hook=[
            "CREATE TABLE IF NOT EXISTS temp_clientes AS SELECT * FROM clientes LIMIT 100",
            "UPDATE temp_clientes SET ativo = true WHERE status = 'ativo'"
        ],
        post_hook=[
            "ANALYZE temp_clientes",
            "DROP TABLE IF EXISTS temp_clientes"
        ]
    )
}}

SELECT * FROM temp_clientes


----
-- executa para insert de logs
{{
    config(
        post_hook=[
            "INSERT INTO log_execucoes(modelo, data_execucao, status) VALUES ('{{ this.name }}', CURRENT_TIMESTAMP, 'SUCESSO')"
        ]
    )
}}

SELECT * FROM clientes

----
-- executa o post_hook com envio de alerta
{{
    config(
        post_hook=[
            "{% if target.name == 'prod' %} INSERT INTO log_execucoes(modelo, data_execucao, status) VALUES ('{{ this.name }}', CURRENT_TIMESTAMP, 'SUCESSO') {% endif %}"
        ]
    )
}}
{{
    config(
        post_hook=[
            "CALL send_email('time@empresa.com', 'Modelo {{ this.name}} executado com sucesso', 'Modelo finalizdo em {{ run_started_at }}.')",
        ]
    )
}}

SELECT * FROM clientes


----
-- executa o post_hook apenas no ambiente de produção
{{
    config(
        post_hook=[
            "{% if target.name == 'prod' %} INSERT INTO log_execucoes(modelo, data_execucao, status) VALUES ('{{ this.name }}', CURRENT_TIMESTAMP, 'SUCESSO') {% endif %}"
        ]
    )
}}

SELECT * FROM clientes