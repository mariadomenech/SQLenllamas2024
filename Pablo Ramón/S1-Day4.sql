--Dia 4 ¿Producto más vendido?+¿Cuantas veces se ha pedido?
USE SQL_EN_LLAMAS;

SELECT 
        TOP 1 PRODUCT_NAME AS PRODUCTO_MAS_VENDIDO
        ,COUNT(*) AS VECES_PEDIDO
FROM CASE01.SALES S
LEFT JOIN CASE01.MENU M
    ON S.PRODUCT_ID = M.PRODUCT_ID
GROUP BY 1
ORDER BY 2 DESC;

/*********************************/
/***** COMENTARIO JUAN PEDRO *****/
/*********************************/
/*
¡Todo correcto enhorabuena! PERO OJO, usar TOP puede que en caso de empate en el producto más repetido solo te saque uno en vez de tantos como obtengan el primer 
puesto. Lo mejor hubiera sido una función ventana RANK o tirar de una serie de filtros usando subselect. Si tienes interes en como hacer esto y no te sale no dudes 
en pregutnar.
*/
