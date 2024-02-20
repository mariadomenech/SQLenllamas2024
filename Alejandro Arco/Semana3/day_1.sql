/* Day 1
    ¿En cuántos días de media se reasignan los clientes a un nodo diferente?
*/

USE SQL_EN_LLAMAS;
USE SCHEMA CASE03;

WITH NODES_DATA AS (
    SELECT
        node_id AS current_node_id,
        LEAD(node_id) OVER(
            PARTITION BY customer_id
            ORDER BY customer_id, start_date
        ) AS next_node_id,
        start_date as current_start_date,
        LEAD(start_date) OVER(
            PARTITION BY customer_id
            ORDER BY customer_id, start_date
        ) AS next_start_date
    FROM CUSTOMER_NODES
)

SELECT
    ROUND(AVG(DATEDIFF(
            DAY,
            current_start_date,
            next_start_date
        )
    ),2) AS avg_days
FROM NODES_DATA
WHERE current_node_id != next_node_id;

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

El resultado no es correcto. 

Revisando el codigo no estas contando el primer dia, ya que al filtrar que el nodo actual sea distinto que el siguiente te quitas registros que tienen varias fechas para el mismo nodo,
para ello te recomiendo calcular en una primera cte si la fecha es la primera fecha registrada con la función LAG (es similar a LEAD pero en lugar de buscar el siguiente registro busca el anterior). 
Una vez que tenemos identificados los primeros registros de cada cliente, ya podemos realizar el LEAD y los calculos posteriores. 
Tambien te recomiendo calcular los dias desde la primera fecha del nodo hasta la siguiente fecha de inicio (LEAD), para por último realizar la media.

*/

--Obtenemos la tupla que supone el primer tramo de fechas en un nodo determinado con la función de ventana LAG.

-- Añadida solución de Ángel
WITH inicio_nodo AS (
    SELECT
        *,
        CASE
            WHEN LAG(NODE_ID) OVER (PARTITION BY customer_id ORDER BY start_date) = node_id THEN 0
            ELSE 1
        END AS tramo_inicial
    FROM SQL_EN_LLAMAS.CASE03.CUSTOMER_NODES
),

dias_cambio AS (
    SELECT
        customer_id,
        LEAD(start_date) OVER (PARTITION BY customer_id ORDER BY start_date) - start_date - 1 AS dias_en_nodo
    FROM inicio_nodo
    WHERE tramo_inicial = 1
    QUALIFY LEAD(start_date) OVER (PARTITION BY customer_id ORDER BY start_date) IS NOT NULL
    ORDER BY customer_id, start_date
)

SELECT
    ROUND(AVG(dias_en_nodo), 2) AS dias_reasignacion_media,
    CONCAT('Los clientes se reasignan a un nodo diferente cada ' || ROUND(AVG(dias_en_nodo)) || ' días de media.') AS texto
FROM dias_cambio;
