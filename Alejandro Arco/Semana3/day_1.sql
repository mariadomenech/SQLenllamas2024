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