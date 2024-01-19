/*Day 5 - Josep quiere fidelizar a los clientes con 10 puntos por cada euro gastado, pero el sushi tendrá un multiplicador x2*/
SELECT 
    sales.customer_id as cliente, 
    SUM(
        CASE 
            WHEN menu.product_name = 'sushi' THEN MENU.price * 10 * 2
            ELSE menu.price * 10
        END
    ) AS PuntosTotales
FROM 
    SQL_EN_LLAMAS.CASE01.SALES
LEFT JOIN 
    SQL_EN_LLAMAS.CASE01.MENU
        ON SALES.product_id = MENU.product_id
GROUP BY SALES.customer_id
ORDER BY SALES.customer_id;

/*Otra forma, esta vez usando una CTE para tener el cálculo "encapsulado" y poder recurrir a el mas tarde*/

WITH PuntosPorVenta as (
    SELECT 
        sales.customer_id as cliente, 
        CASE 
            WHEN menu.product_name = 'sushi' THEN menu.price * 10 * 2
            ELSE menu.price * 10
        END as Puntos
    FROM 
        SQL_EN_LLAMAS.CASE01.SALES
    LEFT JOIN 
        SQL_EN_LLAMAS.CASE01.MENU
            ON sales.product_id = menu.product_id
)
SELECT 
    cliente, 
    SUM(Puntos) as PuntosTotales
FROM 
    PuntosPorVenta
GROUP BY 
    cliente
ORDER BY 
    cliente;
