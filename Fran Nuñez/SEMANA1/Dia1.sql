SELECT MEMBERS.CUSTOMER_ID AS "CLIENTE", CASE WHEN SUM(MENU.PRICE) IS NULL THEN 0 ELSE SUM(MENU.PRICE) END AS "GASTO"
FROM SALES
JOIN MENU
ON SALES.PRODUCT_ID = MENU.PRODUCT_ID
FULL JOIN MEMBERS
ON SALES.CUSTOMER_ID = MEMBERS.CUSTOMER_ID
GROUP BY MEMBERS.CUSTOMER_ID

/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/* 
El resultado es completamente correcto pero el código tiene algo que yo mejoraría.

Los FULL JOIN no son muy recomendables, en este caso no altera el resultado y además son pocos registros, pero en tablas
con miles de registros y en los que no sabes exactamente que tiene cada tabla puede ser un problema ya que podría dar registros no deseados o nulos
e incluso el tiempo en máquina te puede penalizar al pedir al motor que te cruce en ambos sentidos.

Yo primero me pararía a pensar qué tabla es la de dimensiones principal y eligiría una dirección de join. 
Al coger la columna de CUSTOMER_ID de la tabla members, esta es tu tabla principal, por lo que solo tiene sentido que uses un RIGHT,
o incluso partir en el FROM de la tabla MEMBERS, hacer LEFT JOIN con SALES, 
y de nuevo LEFT JOIN con MENU.

Respecto a las tabulaciones, a mí me resulta más fácil leer las columnas tabuladas tras cada ',', es decir, expandiría la lista de columnas a mostrar.

*/

/*CAMBIOS FRAN*/
SELECT MEMBERS.CUSTOMER_ID AS "CLIENTE",
CASE WHEN SUM(MENU.PRICE) IS NULL
THEN 0 ELSE SUM(MENU.PRICE) END AS "GASTO"
FROM SALES
JOIN MENU
ON SALES.PRODUCT_ID = MENU.PRODUCT_ID
RIGHT JOIN MEMBERS
ON SALES.CUSTOMER_ID = MEMBERS.CUSTOMER_ID
GROUP BY MEMBERS.CUSTOMER_ID
