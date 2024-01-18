-- ¿Cuál es el primer producto que ha pedido cada cliente?
SELECT
    A.customer_id
   ,A.first_order_date
   ,LISTAGG(DISTINCT A.product_name ||' (' || product_count||')', ', ')  AS orders_placed
FROM
    (
    SELECT 
        sales.customer_id
        ,menu.product_name
        ,sales.order_date as first_order_date
        ,COUNT( DISTINCT menu.product_name) OVER (PARTITION BY sales.customer_id,
                                                               sales.order_date,
                                                               menu.product_name
                                                  ) AS product_count       
    FROM case01.members
    LEFT JOIN case01.sales
    INNER JOIN (SELECT product_id, product_name 
                FROM case01.menu
                ) AS menu
           ON sales.product_id = menu.product_id 
    WHERE order_date in (select min (order_date) 
                         from case01.sales)
    ) A
GROUP BY A.customer_id,A.first_order_date
