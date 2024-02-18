WITH nodes_lead AS (
    SELECT 
        node_id
        ,start_date
        ,DECODE(end_date,'9999-12-31',NULL,end_date) AS end_date
        ,LEAD(node_id) OVER (PARTITION BY customer_id, region_id ORDER BY start_date) AS next_node_id
        ,LEAD(start_date) OVER (PARTITION BY customer_id, region_id ORDER BY start_date) AS next_start_date
    FROM case03.customer_nodes
)

SELECT 
    'Los clientes tardan de media en reasignarse ' || ROUND(AVG(difference_days), 2) || ' días' AS Salida
FROM 
(
    SELECT 
        node_id
        ,start_date
        ,next_start_date - start_date AS difference_days
    FROM nodes_lead
    WHERE end_date IS NOT NULL AND next_node_id != node_id
    ORDER BY 1,2,3
);

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

El resultado no es correcto. 

Te recomendaría calcular en una primera cte cuales son los primeros nodos de cada cliente con la función LAG (es similar a LEAD pero en lugar de buscar el siguiente registro busca el anterior). 
Una vez que tenemos identificados los primeros registros de cada cliente, ya podemos realizar el LEAD y los calculos posteriores.

*/
