/*Day 5 - Josep quiere fidelizar a los clientes con 10 puntos por cada euro gastado, pero el sushi tendrá un multiplicador x2*/
SELECT 
    members.customer_id as cliente, 
    NVL(
    SUM(
        CASE 
            WHEN menu.product_name = 'sushi' THEN MENU.price * 10 * 2
            ELSE menu.price * 10
        END )
    ,0) AS PuntosTotales
FROM 
    SQL_EN_LLAMAS.CASE01.MEMBERS
LEFT JOIN 
    SQL_EN_LLAMAS.CASE01.SALES
        ON members.customer_id = sales.customer_id
LEFT JOIN 
    SQL_EN_LLAMAS.CASE01.MENU
        ON menu.product_id = sales.product_id
GROUP BY members.customer_id
ORDER BY members.customer_id;

/*Otra forma, esta vez usando una CTE para tener el cálculo "encapsulado" y poder recurrir a el mas tarde*/

WITH PuntosPorVenta as (
    SELECT 
        members.customer_id as cliente, 
        CASE 
            WHEN menu.product_name = 'sushi' THEN menu.price * 10 * 2 
            WHEN menu.product_name IS NULL THEN 0
            ELSE menu.price * 10
        END as Puntos
    FROM 
        SQL_EN_LLAMAS.CASE01.MEMBERS
    LEFT JOIN 
        SQL_EN_LLAMAS.CASE01.SALES
            ON members.customer_id = sales.customer_id
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
