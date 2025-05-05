{{
    config(
        materialized='incremental',
        unique_key='id_pedido' -- (Chave Unica) -> atualiza pedidos novos e já existentes (ex: pedido 1 valor 10 mudou o valor pra 20)
    )

}}

WITH atualizacoes AS (
    SELECT
        id_pedido,
        data_criacao,
        data_entrega,
        valor
    FROM pedidos
    {% if is_incremental() %}
        WHERE data_criacao >= (SELECT MAX(data_criacao) FROM {{ this }}) -- this -> tabela autal
    {% endif %}
)

SELECT * FROM atualizacoes

-- Usar Soft delete (criar uma coluna de data da deleção) para não perder os dados antigos e organizar os dados.