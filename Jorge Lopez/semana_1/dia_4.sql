//Día4: ¿Cuál es el producto más pedido del menú y cuántas veces se ha pedido?
SELECT 	PRODUCT_NAME
		,COUNT(SALES.PRODUCT_ID) AS NUM_VECES
FROM CASE01.SALES
INNER JOIN CASE01.MENU
	ON SALES.PRODUCT_ID = MENU.PRODUCT_ID
GROUP BY PRODUCT_NAME
ORDER BY NUM_VECES DESC
LIMIT 1;


/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/*

Perfecto Jorge!

*/
