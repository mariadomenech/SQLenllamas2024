with nodos_previo_proximo as (
    select 
          *
        , LEAD(node_id) OVER (PARTITION BY customer_id ORDER BY end_date) as nodo_proximo
    from 
        SQL_EN_LLAMAS.CASE03.CUSTOMER_NODES
--- quitamos los que están activos ---        
    where 
        end_date <> ('9999-12-31')
)

select 
    cast(avg((end_date + 1) - start_date) as numeric(5,2)) as nodo_dias_media_cambio 
from nodos_previo_proximo
--- quitamos cuando el cambio es al mismo nodo ---
where 
    node_id <> nodo_proximo; 


/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/* 

La lógica del ejercicio es tal cual la planteas empieza bien, pero, pasas por alto una cosilla que hace que el resultado no sea correcto:
 - No hay que tener en cuenta el dia de inicio para realizar el cálculo. En vez de (end_date + 1) - start_date    es     (end_date) - start_date
 - Cuando un nodo está varios registros solo cuenta uno de los registros en vez del primero al ultimo

RESULTADO CORRECTO: 17.865859.

CÓDIGO: te explico con un ejemplo. Cogemos el customer_id = 1, corrigiendo ese día de más que estabas incluyendo:
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
(10+1+11+20)=42/4=10.5
¿Que sería lo correcto?:
(12+1+11+20)/4=44/4=11

Te animo a que lo rehagas de nuevo teniendo esto en cuenta, puedes hacer la prueba con algunos concretos por ejemplo customer (1,24,62,447),
ver a mano que debe de salir y ver si te sale.

A parte del lead también existe el lag que en vez del siguiente te mira el anterior, te lo digo porque puede ayudarte a identificar las casuisticas
a tener en cuenta para resolverlo.

*/
