SELECT M.customer_id,ZEROIFNULL(SUM(price)) as total_gastado
FROM SALES S
JOIN MENU ME
ON S.product_id = ME.product_id
full JOIN MEMBERS M
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

La comprobación del nulo para poner 0 sería más correcta así: SUM(ZEROIFNULL(MENU.PRICE)). ¿Por qué?
 - de tu forma si se diera este caso: 5+null+5 es 0 puesto que 5+null+5 sería null al ser uno de los sumandos null,
   y por tanto luego el IFNULL lo convierte a 0
 - de la forma que te cuento: 5+null+5 =10 porque previo a la suma ha cambiado el null por 0.

Respecto a las tabulaciones, a mí me resulta más fácil leer las columnas tabuladas tras cada ',', es decir, expandiría la lista de columnas a mostrar.


*/
