SELECT M.PRODUCT_NAME AS PRODUCTO,
        COUNT(S.PRODUCT_ID) AS VECES_PEDIDO
FROM SQL_EN_LLAMAS.CASE01.SALES AS S
RIGHT JOIN SQL_EN_LLAMAS.CASE01.MENU AS M
ON M.PRODUCT_ID = S.PRODUCT_ID
GROUP BY M.PRODUCT_NAME
ORDER BY VECES_PEDIDO DESC
LIMIT 1

/*********************************/
/***** COMENTARIO JUAN PEDRO *****/
/*********************************/
/*
¡Todo correcto enhorabuena! PERO OJO, usar LIMIT puede que en caso de empate en el producto más repetido solo te saque uno en vez de tantos como obtengas el primer 
puesto. Lo mejor hubiera sido una función ventana RANK o tirar de una serie de filtros usando subselect. Si tienes interes en como hacer esto y no te sale no dudes 
en pregutnar.
*/
