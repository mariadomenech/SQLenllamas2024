
/* ¿En cuantos dias de media se reasignan los clientes a un nodo diferente? */

---TABLAS LIMPIAS---
CREATE OR REPLACE TEMPORARY TABLE ESPECIALIDAD_SQL_BRONZE_DB_BEA.RETO.CUSTOMER_NODES AS 
SELECT 
    customer_id
    ,region_id
    ,node_id
    ,start_date
    ,DECODE(end_date,'9999-12-31',NULL,end_date) AS end_date
FROM case03.customer_nodes;

WITH Nodes_lead AS (
    SELECT 
        node_id
        ,start_date
        ,end_date
        ,LEAD(node_id) OVER (PARTITION BY customer_id, region_id ORDER BY start_date) AS next_node_id
        ,LEAD(start_date) OVER (PARTITION BY customer_id, region_id ORDER BY start_date) AS next_start_date
    FROM ESPECIALIDAD_SQL_BRONZE_DB_BEA.RETO.CUSTOMER_NODES
)

SELECT 
    'Los clientes tardan de media en reasignarse ' || ROUND(AVG(difference_days), 2) || ' días' AS Salida
FROM 
(
    SELECT 
        node_id
        ,start_date
        ,next_start_date - start_date AS difference_days
    FROM Nodes_lead
    WHERE end_date IS NOT NULL AND next_node_id != node_id
    ORDER BY 1,2,3
);

 
