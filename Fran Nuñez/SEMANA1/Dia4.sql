SELECT MENU.PRODUCT_NAME AS "PRODUCTO",
COUNT(SALES.PRODUCT_ID) AS "Nº VECES PEDIDO"
FROM SALES
RIGHT JOIN MENU
ON MENU.PRODUCT_ID = SALES.PRODUCT_ID
GROUP BY MENU.PRODUCT_NAME
ORDER BY "Nº VECES PEDIDO" DESC
LIMIT 1

/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/

/* 

Correcto Fran!!

Las dobles comillas para los alias no hacen falta.

*/
