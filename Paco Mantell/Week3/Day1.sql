WITH CTE_CLEAN_DATA AS (
    /*Limpiamos la columna end_date, que contiene años erroneos, y obtenemos una columna de siguiente nodo*/
    SELECT customer_id,
    region_id,
    node_id,
    start_date,
    REPLACE(end_date,YEAR(end_date), YEAR(start_date)) end_date,
    LEAD(node_id) IGNORE NULLS OVER (ORDER BY customer_id) next_node
    FROM sql_en_llamas.case03.customer_nodes
), CTE_DAYDIFF AS(
    /*seleccionamos solo las filas correspondientes a un cambio de nodo y calculamos la diferencia de dias*/
    SELECT customer_id,
    region_id,
    start_date,
    node_id,
    end_date,
    next_node,
    DATEDIFF(DAY,start_date,end_date) daydiff
    FROM CTE_CLEAN_DATA
    WHERE node_id!=next_node
    
)
/*Mostramos la media de dias por cliente y el total en la primera fila*/
SELECT 'TOTAL' totals,
CAST(AVG(daydiff) AS INT) avg_days
FROM CTE_DAYDIFF
GROUP BY 1

UNION ALL
SELECT TO_VARCHAR(customer_id),
avg_days
FROM(
    SELECT customer_id,
    CAST(AVG(daydiff) AS INT) avg_days
    FROM CTE_DAYDIFF A
    GROUP BY 1
    ORDER BY 1 ASC
)
