{% snapshot vendas_snapshot %}

{{ 
    config(
        target_schema='historico',
        target_database='datawarehouse',
        unique_key='id_pedido',
        strategy='timestamp', -- timestamp ou check
        updated_at='data_atualizacao', -- timestamp ou check
        -- strategy='check', -- Comparada todas ou algumas colunas (check_cols)
        -- check_cols='all'
    )
}}

    SELECT
        id_pedido,
        data_venda,
        status,
        valor
    FROM vendas


{% endsnapshot %}