WITH CTE_PRICES AS(
    /*COLUMNA DE PRECIOS DE PIZZAS*/
    SELECT pizza_id,
    pizza_name,
    CASE
        WHEN pizza_id=1 THEN 12
        WHEN pizza_id=2 THEN 10
        ELSE 0
    END price
    FROM sql_en_llamas.case02.pizza_names
), CTE_STATUS AS(
    /* CREAMOS DOS ESTADOS DE ENTREGA*/
    SELECT A.runner_id,
        B.order_id,
        CASE
            WHEN B.cancellation = 'Restaurant Cancellation' OR B.cancellation = 'Customer Cancellation' THEN 'C'
            ELSE 'D'
        END status
    FROM sql_en_llamas.case02.runners A
    LEFT JOIN sql_en_llamas.case02.runner_orders B
        ON A.runner_id=B.runner_id
), CTE_COUNT_EXTRAS AS(
    /*NUMERO DE EXTRAS DE CADA PIZZA*/
    SELECT order_id,
    customer_id,
    pizza_id,
    CASE
        WHEN A.extras = 'null' OR LENGTH(A.extras) = 0 OR LENGTH(A.extras) IS null THEN 0
        ELSE REGEXP_COUNT(A.extras, '\\d')
    END NUM_EXTRAS
    FROM sql_en_llamas.case02.customer_orders A
), CTE_DELIVERED AS(
    /*PEDIDOS Y PIZZAS ENTREGADOS*/
    SELECT A.runner_id,
    ZEROIFNULL(COUNT(DISTINCT A.order_id)) DEL_ORDERS,
    ZEROIFNULL(SUM(C.price)+SUM(B.NUM_EXTRAS)) PIZZA_SALES
    FROM CTE_STATUS A
    LEFT JOIN CTE_COUNT_EXTRAS B
        ON A.order_id=B.order_id
    LEFT JOIN CTE_PRICES C
        ON B.pizza_id=C.pizza_id
    WHERE A.status='D'
    GROUP BY 1
), CTE_TELEMETRICS AS (
    /*LIMPIAMOS LOS DATOS DE DISTANCIA Y DURACION*/
    SELECT runner_id,
    CAST(ZEROIFNULL(regexp_substr(distance,'(\\d+\.\\d+)|(\\d+)')) AS FLOAT) distance_num
    FROM sql_en_llamas.case02.runner_orders
), CTE_RUNNER_STATS AS(
    /*ESTADISTICAS DE LOS RUNNERS*/
    SELECT B.runner_id,
    ZEROIFNULL(SUM(distance_num) * 0.3)::decimal(10,2) runner_cost
    FROM CTE_TELEMETRICS A
    RIGHT JOIN sql_en_llamas.case02.runners B
    ON A.runner_id=B.runner_id
    GROUP BY 1
), CTE_TOTALES AS(
    /*CALCULAMOS LOS TOTALES*/
    SELECT 'TOTAL' totales,
    CONCAT(SUM(DD.pizza_sales),' €') total_sales,
    CONCAT(SUM(EE.runner_cost),' €') total_cost,
    CONCAT(SUM(DD.pizza_sales) - SUM(EE.runner_cost), ' €') total_profit
    FROM CTE_DELIVERED DD
    RIGHT JOIN CTE_RUNNER_STATS EE
        ON DD.runner_id=EE.runner_id
)
/*MOSTRAMOS*/
SELECT TO_VARCHAR(D.runner_id) RUNNER,
CONCAT(D.pizza_sales,' €') SALES,
CONCAT(E.runner_cost, ' €') RUNNER_COST,
CONCAT(D.pizza_sales - E.runner_cost, ' €') PROFIT
FROM CTE_DELIVERED D
RIGHT JOIN CTE_RUNNER_STATS E
    ON D.runner_id=E.runner_id
UNION ALL
SELECT TOTALES,
TOTAL_SALES,
TOTAL_COST,
TOTAL_PROFIT
FROM CTE_TOTALES
