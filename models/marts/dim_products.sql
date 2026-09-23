{{ config(materialized='table') }}

select
    product_id,
    product_name,
    category,
    subcategory,
    unit_cost,
    unit_price,
    round((unit_price - unit_cost) / nullif(unit_price, 0), 4) as margin_pct
from {{ ref('stg_products') }}
