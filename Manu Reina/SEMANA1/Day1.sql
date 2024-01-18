-- ¿Cuánto ha gastado en total cada cliente en el restaurante? -- 
SELECT 
     MEMBERS.CUSTOMER_ID
    ,IFNULL(SUM(MENU.PRICE),0) AS TOTAL_GASTADO
FROM CASE01.SALES
INNER JOIN CASE01.MENU
        ON SALES.PRODUCT_ID = MENU.PRODUCT_ID
FULL JOIN CASE01.MEMBERS 
        ON SALES.CUSTOMER_ID = MEMBERS.CUSTOMER_ID
GROUP BY MEMBERS.CUSTOMER_ID;
/*********************************/
/***** COMENTARIO JUAN PEDRO *****/
/*********************************/
/* 
El resultado es completamente correcto pero el código tiene dos pequeña deficiencias.

Los FULL JOIN no son muy recomendables, en este caso no altera el resultado y además son pocos registros, pero en tablas
con miles de registros y en los que no sabes exactamente que tiene cada tabla puede ser un problema. Por ello sería más
correcto usar un RIGHT, o incluso partir en el FROM de la tabla MEMBERS, hacer LEFT JOIN con SALES, y de nuevo LEFT JOIN
con MENU.

La comprobación del nulo para poner 0 sería más correcta así: SUM(IFNULL(MENU.PRICE,0)). ¿Por qué?
 - de tu forma si se diera este caso: 5+null+5 es 0 puesto que 5+null+5 sería null al ser uno de los sumandos null,
   y por tanto luego el IFNULL lo convierte a 0
 - de la forma que te cuento: 5+null+5 =10 porque previo a la suma ha cambiado el null por 0.

En cuanto a la limpieza de código nada que objetar, es una opinión subjetiva pero me gusta que esté todo en mayúscula. 
Respecto a las tabulaciones nada que objetar tampoco, están tal cual las habria hecho yo, que no significa que sea la 
única forma correcta, pero para mi está TOP!
*/
