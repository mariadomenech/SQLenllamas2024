SELECT 
     ME.CUSTOMER_ID CLIENTE
    ,SUM(IFNULL(PRICE, 0)) "PRECIO"
FROM
    SQL_EN_LLAMAS.CASE01.SALES S
    JOIN SQL_EN_LLAMAS.CASE01.MENU M
    ON S.PRODUCT_ID=M.PRODUCT_ID
    FULL JOIN SQL_EN_LLAMAS.CASE01.MEMBERS ME
    ON S.CUSTOMER_ID=ME.CUSTOMER_ID
GROUP BY ME.CUSTOMER_ID;

/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/*

El resultado es completamente correcto y me ha gustado que hayas usado correctamente la función IFNULL con el SUM.

Pero el código tiene algo que yo cambiaría.

Los FULL JOIN no son muy recomendables, en este caso no altera el resultado y además son pocos registros, pero en tablas
con miles de registros y en los que no sabes exactamente qué tiene cada tabla puede ser un problema ya que podría dar registros 
no deseados, nulos e incluso te puede penalizar el tiempo en máquina al pedir al motor que te cruce en ambos sentidos.

Yo primero me pararía a pensar qué tabla es la de dimensiones principal y eligiría una dirección de join. 
Al coger la columna de CUSTOMER_ID de la tabla members, esta es tu tabla principal, por lo que solo tiene sentido que uses un RIGHT,
o incluso partir en el FROM de la tabla MEMBERS, hacer LEFT JOIN con SALES, y de nuevo LEFT JOIN con MENU.

*/
