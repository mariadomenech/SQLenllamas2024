WITH CTE_STATUS AS(
/* CREAMOS DOS ESTADOS DE ENTREGA*/
    SELECT C.order_id,
        C.pizza_id,
        C.exclusions,
        C.extras,
        CASE
            WHEN B.cancellation = 'Restaurant Cancellation' OR B.cancellation = 'Customer Cancellation' THEN 'C'
            ELSE 'D'
        END status
    FROM sql_en_llamas.case02.customer_orders C
    LEFT JOIN sql_en_llamas.case02.runner_orders B
        ON C.order_id=B.order_id
    LEFT JOIN sql_en_llamas.case02.runners A
        ON A.runner_id=B.runner_id
    WHERE status!='C'
), CTE_SPLIT_ING AS (
    /*SEPARAMOS CADA INGREDIENTE DE LAS PIZZAS*/
    SELECT pizza_id,
    A.value topp_split
    FROM sql_en_llamas.case02.pizza_recipes,
    LATERAL FLATTEN(input=>SPLIT(toppings,', ')) A
), CTE_PIVOT_ING AS(
    /*VEMOS EL NUMERO DE VECES QUE SE USA CADA INGREDIENTE EN CADA PIZZA*/
    SELECT * 
    FROM CTE_SPLIT_ING
    PIVOT(COUNT(topp_split) FOR topp_split IN ('1','2','3','4','5','6','7','8','9','10','11','12'))
        AS ING (pizza_id, "1","2","3","4","5","6","7","8","9","10","11","12")
), CTE_UNPIVOT_ING AS(
    /*AGRUPAMOS POR PIZZA E INGREDIENTE*/
    SELECT pizza_id,
    ingredients,
    SUM(times) ing
    FROM CTE_PIVOT_ING
    UNPIVOT(times FOR ingredients IN ("1","2","3","4","5","6","7","8","9","10","11","12"))
    GROUP BY 1, 2
), CTE_SPLIT_EXTRAS AS (
    /*SEPARAMOS CADA UNO DE LOS EXTRAS DE LAS PIZZAS ENTREGADAS*/
    SELECT A.pizza_id,
    B.value extra
    FROM CTE_STATUS A,
    LATERAL FLATTEN(input=>SPLIT(A.extras,', ')) B
), CTE_PIVOT_EXTRA AS (
    /*CONTAMOS LAS VECES QUE CADA INGREDIENTE SE PIDE COMO EXTRA*/
    SELECT *
    FROM CTE_SPLIT_EXTRAS
    PIVOT(COUNT(extra) FOR extra IN ('1', '4', '5'))
        AS EXTR (pizza_id, "1", "4", "5")
), CTE_UNPIVOT_EXTRA AS (
    /*AGRUPAMOS POR INGREDIENTE*/
    SELECT extra,
    SUM(times) extr
    FROM CTE_PIVOT_EXTRA
    UNPIVOT(times FOR extra IN ("1", "4", "5"))
    GROUP BY 1
), CTE_SPLIT_EXCL AS(
    /*SEPARAMOS CADA INGREDIENTE EXCLUIDO DE LAS PIZZAS ENTREGADAS*/
    SELECT pizza_id,
    C.value exclusion
    FROM sql_en_llamas.case02.customer_orders,
    LATERAL FLATTEN(input=>SPLIT(exclusions,', ')) C
), CTE_PIVOT_EXCL AS(
    /*CONTAMOS LAS VECES QUE SE EXLUYE CADA INGREDIENTE*/
    SELECT *
    FROM CTE_SPLIT_EXCL
    PIVOT(COUNT(exclusion) FOR exclusion IN ('2', '4', '6', 'beef'))
            AS EXTR (pizza_id, "2", "4", "6", "3")
), CTE_UNPIVOT_EXCL AS (
    /*AGRUPAMOS POR INGREDIENTE*/
    SELECT exclusion,
    SUM(times) excl
    FROM CTE_PIVOT_EXCL
        UNPIVOT(times FOR exclusion IN ("2", "4", "6", "3"))
    GROUP BY 1

), CTE_DEL_ING AS (
    /*CONTAMOS LOS INGREDIENTES QUE SE USAN EN CADA PIZZA ENTREGADA*/
    SELECT A.ingredients,
    SUM(A.ing) freq
    FROM CTE_UNPIVOT_ING A
    LEFT JOIN CTE_DEL_ORDERS B
        ON A.pizza_id=B.pizza_id
    GROUP BY 1
)
/*CONTAMOS LAS VECES QUE SE USA CADA INGREDIENTE EN TODAS LAS PIZZAS ENTREGADAS TENIENDO EN CUNETAS SI SE USAN COMO EXTRA O SE EXCLUYEN*/
SELECT B.topping_name,
ZEROIFNULL(freq) + ZEROIFNULL(extr) - ZEROIFNULL(excl) times_used
FROM CTE_DEL_ING A
LEFT JOIN sql_en_llamas.case02.pizza_toppings B
    ON A.ingredients=B.topping_id
LEFT JOIN CTE_UNPIVOT_EXTRA C
    ON B.topping_id=C.extra
LEFT JOIN CTE_UNPIVOT_EXCL D
    ON B.topping_id=D.exclusion
ORDER BY 2 DESC
