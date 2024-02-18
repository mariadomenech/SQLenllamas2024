/*DÍA 1 ¿cuantos días de media se reasignan los clientes a un nodo diferente?*/

WITH nodos_clientes_limpito AS (
    SELECT  CUSTOMER_ID 
        ,   NODE_ID 
        ,   START_DATE 
        ,   LEAD(START_DATE) OVER (PARTITION BY CUSTOMER_ID ORDER BY START_DATE) as nueva_fecha_comienzo
        ,   LEAD (NODE_ID) OVER (PARTITION BY CUSTOMER_ID ORDER BY START_DATE) as nuevo_nodo_id
    FROM    SQL_EN_LLAMAS.CASE03.CUSTOMER_NODES
),

fecha_cambio_nodos AS (
    SELECT  CUSTOMER_ID
        ,   NODE_ID
        ,   nuevo_nodo_id
        ,   nueva_fecha_comienzo - START_DATE as dias_para_nuevo_nodo
    FROM    nodos_clientes_limpito
    WHERE   NODE_ID != nuevo_nodo_id
)
SELECT  ROUND(AVG(dias_para_nuevo_nodo), 2) as media_dias_cambio_de_nodo
FROM    fecha_cambio_nodos;

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

El resultado no es correcto. 

Te recomendaría calcular en una primera cte cuales son los primeros nodos de cada cliente con la función LAG (es similar a LEAD pero en lugar de buscar el siguiente registro busca el anterior). 
Una vez que tenemos identificados los primeros registros de cada cliente, ya podemos realizar el LEAD y los calculos posteriores.

*/
