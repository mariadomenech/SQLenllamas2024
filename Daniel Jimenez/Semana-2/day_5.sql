WITH recetas_temp AS (
    SELECT 
        PIZZA_ID
        , TOPPINGS AS ingredientes
    FROM 
        SQL_EN_LLAMAS.CASE02.PIZZA_RECIPES
),
recetas AS (
    SELECT PIZZA_ID, VALUE AS TOPPING_ID
    FROM recetas_temp, TABLE(SPLIT_TO_TABLE(recetas_temp.ingredientes, ', '))
),
pedidos_limpitos AS (
    SELECT  ORDER_ID
        ,   CUSTOMER_ID
        ,   PIZZA_ID
        ,   CASE WHEN EXCLUSIONS = 'null' OR EXCLUSIONS = '' THEN NULL ELSE EXCLUSIONS END AS ingredientes_excluidos
        ,   CASE WHEN EXTRAS = 'null' OR EXTRAS = '' THEN NULL ELSE EXTRAS END AS ingredientes_extras
        ,   ORDER_TIME
    FROM SQL_EN_LLAMAS.CASE02.CUSTOMER_ORDERS
),
split_extras AS (
    SELECT ORDER_ID, CUSTOMER_ID, PIZZA_ID, 
           CASE 
               WHEN VALUE = 'beef' THEN '3'
               ELSE VALUE
           END AS ingrediente, 
           'Añadido' AS accion
    FROM pedidos_limpitos, TABLE(SPLIT_TO_TABLE(pedidos_limpitos.ingredientes_extras, ', '))
    WHERE pedidos_limpitos.ingredientes_extras IS NOT NULL
),
split_exclusions AS (
    SELECT ORDER_ID, CUSTOMER_ID, PIZZA_ID, 
           CASE 
               WHEN VALUE = 'beef' THEN '3'
               ELSE VALUE
           END AS ingrediente, 
           'Excluido' AS accion
    FROM pedidos_limpitos, TABLE(SPLIT_TO_TABLE(pedidos_limpitos.ingredientes_excluidos, ', '))
    WHERE pedidos_limpitos.ingredientes_excluidos IS NOT NULL
),
unpivoted AS (
    SELECT * FROM split_extras
    UNION ALL
    SELECT * FROM split_exclusions
),
pedidos AS (
    SELECT PIZZA_ID, ingrediente AS TOPPING_ID
    FROM unpivoted
    WHERE accion = 'Añadido'
    UNION ALL
    SELECT r.PIZZA_ID, r.TOPPING_ID
    FROM recetas r
    LEFT JOIN unpivoted u
        ON r.PIZZA_ID = u.PIZZA_ID AND r.TOPPING_ID = u.ingrediente AND u.accion = 'Excluido'
    WHERE u.ingrediente IS NULL
),
ingredientes AS (
    SELECT TOPPING_ID, TOPPING_NAME
    FROM SQL_EN_LLAMAS.CASE02.PIZZA_TOPPINGS
)
SELECT TOPPING_NAME AS NOMBRE_DE_INGREDIENTE, COUNT(*) AS VECES_ENTREGADOS
FROM pedidos
JOIN ingredientes USING (TOPPING_ID)
GROUP BY TOPPING_NAME
ORDER BY VECES_ENTREGADOS DESC;



//ESTÁ MAL, no he usado UNPIVOT, quería hacerlo bien con lo que conocía y luego usar UNPIVOT. Me hice tremendo lío, listé los ingredientes pero fallé en las métricas, lógica y prácticamente todo. Ha sido mi talón de aquiles :(
