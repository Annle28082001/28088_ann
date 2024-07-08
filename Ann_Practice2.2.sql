WITH CTE1 AS (
    SELECT 
        a.order_id,
        a.product_id,
        b.category,
        b.retail_price,
        b.cost,
        c.created_at, 
        (b.retail_price - b.cost) AS profit
    FROM 
        bigquery-public-data.thelook_ecommerce.order_items AS a
    JOIN 
        bigquery-public-data.thelook_ecommerce.products AS b 
    ON 
        a.product_id = b.id
    JOIN 
        bigquery-public-data.thelook_ecommerce.orders AS c
    ON 
        a.order_id = c.order_id
)

SELECT 
    FORMAT_DATE('%y-%m', created_at) AS Month, 
    EXTRACT(YEAR FROM created_at) AS Year, 
    category, 
    SUM(retail_price) OVER (PARTITION BY FORMAT_DATE('%y-%m', created_at)) AS TPV,
    COUNT(order_id) OVER (PARTITION BY FORMAT_DATE('%y-%m', created_at)) AS TPO, 
    SUM(profit) OVER (PARTITION BY FORMAT_DATE('%y-%m', created_at)) AS total_profit,
    SUM(cost) OVER (PARTITION BY FORMAT_DATE('%y-%m', created_at)) AS total_cost, 
    (SUM(profit) OVER (PARTITION BY FORMAT_DATE('%y-%m', created_at)))/(SUM(cost) OVER (PARTITION BY FORMAT_DATE('%y-%m', created_at))) as profit_to_cost_radio

FROM 
    CTE1
ORDER BY 
    Month, category;

