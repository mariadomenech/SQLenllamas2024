USE SQL_EN_LLAMAS;
USE SCHEMA CASE01;

SELECT M.CUSTOMER_ID, IFNULL(SUM(MEN.PRICE),0) AS TOTAL_SPEND 
    FROM MEMBERS M
    LEFT JOIN SALES S
        ON M.CUSTOMER_ID = S.CUSTOMER_ID
    LEFT JOIN MENU MEN
        ON S.PRODUCT_ID = MEN.PRODUCT_ID
    GROUP BY M.CUSTOMER_ID;

/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/*

El resultado es completamente correcto, joins bien montados y el hecho de especificar base de datos y esquema es un ejemplo de buenas prácticas.

Pero el código tiene algo que yo cambiaría.

La comprobación del nulo para poner 0 sería más correcta así: SUM(IFNULL(MEN.PRICE,0)). ¿Por qué?
 - de tu forma si se diera este caso: 5+null+5 es 0 puesto que 5+null+5 sería null al ser uno de los sumandos null,
   y por tanto luego el IFNULL lo convierte a 0
 - de la forma que te cuento: 5+null+5 =10 porque previo a la suma ha cambiado el null por 0.

Respecto a las tabulaciones, a mí me resulta más fácil leer las columnas tabuladas tras cada ',', es decir, expandiría la lista de columnas a mostrar.

Pero muy bien!

*/
	
