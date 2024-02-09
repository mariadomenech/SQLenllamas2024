/*¿EN CUÁNTOS DÍAS DE MEDIA SE REASIGNAN LOS CLIENTES A UN NODO DIFERENTE*/

CREATE OR REPLACE DATABASE SQL_EN_LLAMAS_FNM CLONE SQL_EN_LLAMAS;

CREATE SCHEMA SQL_EN_LLAMAS_FNM.CASE03 CLONE SQL_EN_LLAMAS.CASE03;

USE SCHEMA SQL_EN_LLAMAS_FNM.CASE03;

CREATE OR REPLACE TEMP TABLE CUSTOMER_NODES_SILVER
AS
SELECT CUSTOMER_ID,
    NODE_ID,
    START_DATE,
    LEAD(START_DATE) OVER (PARTITION BY CUSTOMER_ID ORDER BY START_DATE) AS START_DATE_DEF,
    LEAD (NODE_ID) OVER (PARTITION BY CUSTOMER_ID ORDER BY START_DATE) AS NODE_ID_DEF
FROM CUSTOMER_NODES;

SELECT ROUND(AVG(A.NODE_DAYS),1) AS AVG_NODE_DAYS
FROM(
SELECT CUSTOMER_ID,
    NODE_ID,
    NODE_ID_DEF,
    (START_DATE_DEF-START_DATE) AS NODE_DAYS
FROM CUSTOMER_NODES_SILVER
)A


/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/* 

La lógica del ejercicio tal cual la planteas empieza bien, pero, pasas por alto un par de cosillas que hace que el resultado no sea correcto:
    1. Cuando cuentas la diferencia de días entre nodos (START_DATE_DEF-START_DATE) estás sumando el día de inicio y fin. Debes de sumar solo uno de los dos. 
    Ejemplo, me estás diciendo:
-------------------------------------------------
NODO    START        END            DIF_DIAS      
-------------------------------------------------
4	    02/01/2020    03/01/2020	 2
                                            
4	    04/01/2020    14/01/2020	 11	

2	    15/01/2020    16/01/2020	 2	   

Los días que han pasado entre los nodos 4 a 4 son 02/01/2020  y  03/01/2020.
Y los días que han pasado entre los nodos 4 a 2 son 03/01/2020 ,  04/01/2020,  05/01/2020, etc.

Si te fijas estás sumando en en dos tramos el día 03/01/2020, y solo debe de estar en 1. Esto se soluciona restando 1 día a tu resta de fechas:  
(START_DATE_DEF-START_DATE) -1 

2. El último nodo no se cuenta como cambio de nodo, por lo que habría que filtrarlo.

RESULTADO CORRECTO: 17.865859.

CÓDIGO: te explico con un ejemplo. Cogemos el customer_id = 1:
-------------------------------------------------
NODO    START        END            D1      D2
-------------------------------------------------
4	    02/01/2020    03/01/2020	 1
                                            12
4	    04/01/2020    14/01/2020	 10	
-------------------------------------------------
2	    15/01/2020    16/01/2020	 1	    1
-------------------------------------------------
5	    17/01/2020    28/01/2020	 11	    11
-------------------------------------------------
3	    29/01/2020    18/02/2020	 20	    20
-------------------------------------------------
2	    19/02/2020    16/03/2020	 26	
                                            26+X+1
2	    17/03/2020    31/12/9999	  X	
-------------------------------------------------
D1 sería la diferencia de días por cada registro, y D2 es la diferencia de días hasta que cambia el nodo. Tú código está haciendo esto:
(1+10+1+11+20+26)=69/6=11.5
¿Que sería lo correcto?:
(12+1+11+20)/4=44/4=11

Te animo a que lo rehagas de nuevo teniendo esto en cuenta, puedes hacer la prueba con algunos concretos por ejemplo customer (1,24,62,447),
ver a mano que debe de salir y ver si te sale.

A parte del lead también existe el lag que en vez del siguiente te mira el anterior, te lo digo porque puede ayudarte a identificar las casuisticas
a tener en cuenta para resolverlo.

*/
