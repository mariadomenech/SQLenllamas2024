SELECT M.customer_id, ZEROIFNULL(count(distinct S.order_date)) AS DIAS_VISITADOS
FROM MEMBERS M
FULL JOIN SALES S
ON M.customer_id= S.customer_id
GROUP BY 1;

/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/*

El resultado es completamente correcto.

Pero el código tiene algo que yo cambiaría.

Los FULL JOIN no son muy recomendables, en este caso no altera el resultado y además son pocos registros, pero en tablas
con miles de registros y en los que no sabes exactamente qué tiene cada tabla puede ser un problema ya que podría dar registros 
no deseados, nulos e incluso te puede penalizar el tiempo en máquina al pedir al motor que te cruce en ambos sentidos.

Yo primero me pararía a pensar qué tabla es la de dimensiones principal y eligiría una dirección de join. 
Al coger la columna de CUSTOMER_ID de la tabla members, esta es tu tabla principal, por lo que solo tiene sentido que uses un RIGHT,
o incluso partir en el FROM de la tabla MEMBERS, hacer LEFT JOIN con SALES, y de nuevo LEFT JOIN con MENU.

Para los conteos la función de comprobación de nulos no sería necesaria.

Respecto a las tabulaciones, a mí me resulta más fácil leer las columnas tabuladas tras cada ',', es decir, expandiría la lista de columnas a mostrar.


*/
