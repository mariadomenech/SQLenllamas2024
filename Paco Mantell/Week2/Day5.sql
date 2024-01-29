WITH CTE_STATUS AS(
    /* MOSTRAMOS LAS PIZZAS ENTREGADAS */
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
), CTE_EXTRAS AS (
    /*INGREDIENTES EMPLEADOS COMO EXTRA*/
    SELECT extra,
    SUM(times) extr
    FROM(
        /*CONTAMOS LAS VECES QUE SE USA CADA INGREDIENTE*/
        SELECT *
        FROM (
            /*SEPARAMOS CADA UNO DE LOS EXTRAS DE LAS PIZZAS ENTREGADAS*/
            SELECT A.pizza_id,
            B.value extra
            FROM CTE_STATUS A,
            LATERAL FLATTEN(input=>SPLIT(A.extras,', ')) B
        )
        
        PIVOT(COUNT(extra) FOR extra IN ('1', '4', '5'))
            AS EXTR (pizza_id, "1", "4", "5")
     )
     /*AGRUPAMOS EL CONTEO*/
    UNPIVOT(times FOR extra IN ("1", "4", "5"))
    GROUP BY 1
), CTE_EXCLUSIONS AS(
    /*INGREDIENTES EXCLUIDOS*/
    SELECT exclusion,
    SUM(times) excl
    FROM(
        /*CONTAMOS LAS VECES QUE SE EXCLUYE CADA INGREDIENTE*/
        SELECT *
        FROM (
            /*SEPARAMOS CADA EXCLUSION*/
            SELECT pizza_id,
            C.value exclusion
            FROM sql_en_llamas.case02.customer_orders,
            LATERAL FLATTEN(input=>SPLIT(exclusions,', ')) C
        )
        
        PIVOT(COUNT(exclusion) FOR exclusion IN ('2', '4', '6', 'beef'))
                AS EXTR (pizza_id, "2", "4", "6", "3")
    )
    /*AGRUPAMOS POR INGREDIENTE*/
    UNPIVOT(times FOR exclusion IN ("2", "4", "6", "3"))
    GROUP BY 1
), CTE_INGREDIENTS AS(
    /*INGREDIENTES UTILIZADOS EN CADA PIZZA ENTREGADA*/
    SELECT A.ingredients,
    SUM(A.ing) freq
    FROM(
        SELECT pizza_id,
        ingredients,
        SUM(times) ing
        FROM(
            SELECT * FROM(
                /*SEPARAMOS CADA INGREDIENTE DE LAS PIZZAS*/
                SELECT pizza_id,
                A.value topp_split
                FROM sql_en_llamas.case02.pizza_recipes,
                LATERAL FLATTEN(input=>SPLIT(toppings,', ')) A
            )
            /*VEMOS EL NUMERO DE VECES QUE SE USA CADA INGREDIENTE EN CADA PIZZA*/
            PIVOT(COUNT(topp_split) FOR topp_split IN ('1','2','3','4','5','6','7','8','9','10','11','12'))
                AS ING (pizza_id, "1","2","3","4","5","6","7","8","9","10","11","12")
        )
        /*AGRUPAMOS POR PIZZA E INGREDIENTE*/
        UNPIVOT(times FOR ingredients IN ("1","2","3","4","5","6","7","8","9","10","11","12"))
        GROUP BY 1, 2
    ) A
    /*NOS QUEDAMOS CON AQUELLOS PEDIDOS ENTREGADOS*/
    LEFT JOIN CTE_STATUS B
        ON A.pizza_id=B.pizza_id
    GROUP BY 1
)
/*CONTAMOS LAS VECES QUE SE USA CADA INGREDIENTE EN TODAS LAS PIZZAS ENTREGADAS TENIENDO EN CUNETAS SI SE USAN COMO EXTRA O SE EXCLUYEN*/
SELECT B.topping_name,
ZEROIFNULL(freq) + ZEROIFNULL(extr) - ZEROIFNULL(excl) times_used
FROM CTE_INGREDIENTS A
LEFT JOIN sql_en_llamas.case02.pizza_toppings B
    ON A.ingredients=B.topping_id
LEFT JOIN CTE_EXTRAS C
    ON B.topping_id=C.extra
LEFT JOIN CTE_EXCLUSIONS D
    ON B.topping_id=D.exclusion
ORDER BY 2 DESC
