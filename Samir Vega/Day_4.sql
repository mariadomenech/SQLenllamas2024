--------------------------------------------------------------DIA_4----------------------------------------------------------

SELECT TOP 1
    B.PRODUCT_NAME,
    COUNT(*) AS CONTEO_PEDIDOS
FROM SALES A
INNER JOIN MENU B
    ON A.PRODUCT_ID = B.PRODUCT_ID
GROUP BY PRODUCT_NAME
ORDER BY CONTEO_PEDIDOS DESC;

/*********************************/
/***** COMENTARIO JUAN PEDRO *****/
/*********************************/
/*
¡Todo correcto enhorabuena! PERO OJO, usar TOP puede que en caso de empate en el producto más repetido solo te saque uno en vez de tantos como obtengan el primer 
puesto. Lo mejor hubiera sido una función ventana RANK o tirar de una serie de filtros usando subselect. Si tienes interes en como hacer esto y no te sale no dudes 
en pregutnar.
*/
