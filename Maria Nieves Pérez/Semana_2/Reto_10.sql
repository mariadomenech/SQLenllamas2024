WITH primera AS (
    
    SELECT 
        pizza_id,
        trim(ingredientes [0],' ')::number AS ingrediente_1,
        trim(ingredientes [1],' ')::number AS ingrediente_2,
        trim(ingredientes [2],' ')::number AS ingrediente_3,
        trim(ingredientes [3],' ')::number AS ingrediente_4,
        trim(ingredientes [4],' ')::number AS ingrediente_5,
        trim(ingredientes [5],' ')::number AS ingrediente_6,
        trim(ingredientes [6],' ')::number AS ingrediente_7,
        trim(ingredientes [7],' ')::number AS ingrediente_8
        --cancelaciones
    FROM (
        select 
            b.pizza_id,
            SPLIT(toppings, ',') as ingredientes,
            CASE WHEN cancellation IS NULL THEN 'Aceptada'
                WHEN cancellation = 'null' THEN 'Aceptada'
                WHEN CANCELLATION = '' THEN 'Aceptada'
                ELSE cancellation END                           AS cancelaciones
        from SQL_EN_LLAMAS.CASE02.PIZZA_RECIPES A
        inner join SQL_EN_LLAMAS.CASE02.CUSTOMER_ORDERS B
            on A.PIZZA_ID=b.pizza_id
        inner join SQL_EN_LLAMAS.CASE02.RUNNER_ORDERS C
            on b.order_id=c.order_id
        where cancelaciones = 'Aceptada'
    )
),

segunda AS ( 

    SELECT pizza_id, ingrediente 
    FROM   
       (SELECT 
            pizza_id, 
            ingrediente_1, 
            ingrediente_2, 
            ingrediente_3, 
            ingrediente_4, 
            ingrediente_5,
            ingrediente_6,
            ingrediente_7,
            ingrediente_8
       FROM primera) p  
       UNPIVOT  
       (ingrediente FOR lista_ingr IN (  
            ingrediente_1, 
            ingrediente_2, 
            ingrediente_3, 
            ingrediente_4, 
            ingrediente_5,
            ingrediente_6,
            ingrediente_7,
            ingrediente_8
        )  
    )
), 

tercera AS (
    SELECT 
        distinct S.ingrediente,
        --S.pizza_id,
        T.topping_name AS ingred_nombre,
        CASE WHEN ingrediente = 1 THEN (sum(ingrediente) OVER (PARTITION BY pizza_id))
            WHEN ingrediente=2 THEN (sum(ingrediente) OVER (PARTITION BY pizza_id))
            WHEN ingrediente=3 THEN (sum(ingrediente) OVER (PARTITION BY pizza_id))
            WHEN ingrediente=4 THEN (sum(ingrediente) OVER (PARTITION BY pizza_id))
            WHEN ingrediente=5 THEN (sum(ingrediente) OVER (PARTITION BY pizza_id))
            WHEN ingrediente=6 THEN (sum(ingrediente) OVER (PARTITION BY pizza_id))
            WHEN ingrediente=7 THEN (sum(ingrediente) OVER (PARTITION BY pizza_id))
            WHEN ingrediente=8 THEN (sum(ingrediente) OVER (PARTITION BY pizza_id))
            WHEN ingrediente=9 THEN (sum(ingrediente) OVER (PARTITION BY pizza_id))
            WHEN ingrediente=10 THEN (sum(ingrediente) OVER (PARTITION BY pizza_id))
            WHEN ingrediente=11 THEN (sum(ingrediente) OVER (PARTITION BY pizza_id))
            WHEN ingrediente=12 THEN (sum(ingrediente) OVER (PARTITION BY pizza_id))
            END AS cantidad_cada_ingrediente
    FROM segunda S
    INNER JOIN SQL_EN_LLAMAS.CASE02.PIZZA_TOPPINGS T
        ON S.ingrediente=T.topping_id
),

cuarta AS (
    SELECT 
        distinct ingrediente, 
        ingred_nombre,
        sum(cantidad_cada_ingrediente) OVER (PARTITION BY ingrediente) AS cantidad_cada_ingrediente
    FROM tercera
    order by cantidad_cada_ingrediente desc, ingrediente asc
)

SELECT * FROM cuarta


