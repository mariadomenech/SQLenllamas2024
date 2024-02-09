/* Día 1: ¿En cuaántos días de media se reasignan los clientes a un nodo diferente? 

Nota: He comprobado sin restar uno al resultado que cuenta el dia de inicio para realizar el cálculo, con lo que sale un día de más */

SELECT     
    CUSTOMER_ID,
    TO_CHAR(START_DATE, 'DD-MM-YYYY') AS START_DATE,
    TO_CHAR(END_DATE, 'DD-MM-YYYY') AS END_DATE,
    LEAD(START_DATE) OVER (PARTITION BY CUSTOMER_ID ORDER BY END_DATE) - START_DATE - 1 AS DIFF_DIAS
FROM CASE03.CUSTOMER_NODES
ORDER BY CUSTOMER_ID, DIFF_DIAS ASC; 


/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/* 

Buen intento, pero ¿está sin acabar no?

Te animo a que continúes el código, tiene buena pinta. Como comentas es correcto no tener en cuenta ese día de más.

Para la resolución del código ten en cuenta lo siguiente:

- El último nodo del cliente no cuenta para ver  la diferencia de días.
- Cuando un nodo está varios registros solo cuenta uno de los registros en vez del primero al ultimo

RESULTADO CORRECTO: 17.865859.

CÓDIGO: te explico con un ejemplo. Cogemos el customer_id = 1:
-------------------------------------------------
NODO    START        END           D1     D2
-------------------------------------------------
4	    02/01/2020    03/01/2020	1
                                          12
4	    04/01/2020    14/01/2020	10	
-------------------------------------------------
2	    15/01/2020    16/01/2020	1	  1
-------------------------------------------------
5	    17/01/2020    28/01/2020	11	  11
-------------------------------------------------
3	    29/01/2020    18/02/2020	20	  20
-------------------------------------------------
2	    19/02/2020    16/03/2020	26	
                                          26+X+1
2	    17/03/2020    31/12/9999	X	
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

