SELECT TOP 1 A.product_name AS PRODUCTO,
COUNT(B.product_id) VECES_PEDIDO
FROM SQL_EN_LLAMAS.CASE01.MENU A
LEFT JOIN SQL_EN_LLAMAS.CASE01.SALES B
ON A.product_id=B.product_id
GROUP BY 1
ORDER BY 2 DESC

/*********************************/
/***** COMENTARIO JUAN PEDRO *****/
/*********************************/
/*
¡Todo correcto enhorabuena! PERO OJO, usar TOP puede que en caso de empate en el producto más repetido solo te saque uno en vez de tantos como obtengan el primer 
puesto. Lo mejor hubiera sido una función ventana RANK o tirar de una serie de filtros usando subselect. Si tienes interes en como hacer esto y no te sale no dudes 
en pregutnar.
*/
