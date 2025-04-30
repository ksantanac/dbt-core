{{
    config(
        tags=['comercial']
    )
}}

with orders as (
    select
        extract(month from order_date) as month,
        extract(year from order_date) as year,
        freight as total_frete
    from {{ ref('stg_orders') }}
)


, vendas as (
    select 
        mes,
        ano,
        sum(total_frete) as total_frete
    from orders 
    group by mes, ano
)


select
    *
from vendas