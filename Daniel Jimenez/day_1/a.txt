// DÍA 1 - ¿Cuanto han gastado en total los clientes en el restaurante?

SELECT      A."customer_id" as id_cliente ,
            SUM(IFNULL(B."price", 0)) as precio
FROM SQL_EN_LLAMAS.CASE01.MEMBERS A
LEFT JOIN SQL_EN_LLAMAS.CASE01.SALES C
    ON A."customer_id" = C."customer_id"
LEFT JOIN SQL_EN_LLAMAS.CASE01.MENU B
    ON C."product_id" = B."product_id"
GROUP BY 1  
ORDER BY 2 DESC;
