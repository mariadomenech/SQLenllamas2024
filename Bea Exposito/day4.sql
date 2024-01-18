-- ¿Cuál es el producto más pedido del menú y cuántas veces ha sido pedido?

--OPCION 1
SELECT
    B.product_name,
    B.leading_product
FROM 
        (
        SELECT TOP 1
            A.product_name,
            A.leading_product,
            rank() OVER (ORDER BY A.leading_product DESC) AS product_rank
        FROM
            (
                SELECT
                    menu.product_name,
                    MAX(sales.products_sold) ||' times' AS leading_product      
                FROM
                    case01.menu
                INNER JOIN (
                    SELECT 
                        product_id,
                        COUNT(product_id) AS products_sold
                    FROM
                        case01.sales
                    GROUP BY
                        product_id
                ) sales ON sales.product_id = menu.product_id 
                GROUP BY
                    menu.product_name
            ) A
        ORDER BY
            A.leading_product DESC
        ) B
WHERE  B.product_rank = 1


--OPCION 2
WITH menu_sales AS 
(
    SELECT
         A.product_name
        ,B.product_id
        ,B.customer_id
        ,COUNT(B.product_id) AS sales
    FROM case01.menu A
    INNER JOIN case01.sales B 
        ON A.product_id = B.product_id 
    GROUP BY 1, 2, 3
    ORDER BY sales DESC
)

SELECT
    C.product_name,
    SUM(C.sales) ||' times' as SALES
    ,LISTAGG(C.customer_id, ', ') AS customer_list
FROM menu_sales C
GROUP BY  1
ORDER BY 2 DESC
LIMIT 1
