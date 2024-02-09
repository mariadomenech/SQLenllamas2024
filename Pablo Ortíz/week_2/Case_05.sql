-- Limpiamos la tabla de ingerdientes

WITH ingredientes AS (  
    SELECT
         co.order_id
        ,pr.toppings
     , CASE
        WHEN co.exclusions IN ('', 'null') THEN NULL
        WHEN co.exclusions = 'beef' THEN '3'
            ELSE co.exclusions
    END AS exclusions
     , CASE
        WHEN co.extras IN ('', 'null') THEN NULL
        ELSE co.extras
    END AS extras
    
    FROM PIZZA_RECIPES pr
    
    LEFT JOIN CUSTOMER_ORDERS co
    on pr.pizza_id=co.pizza_id
    
    LEFT JOIN RUNNER_ORDERS ro
    on ro.order_id=co.order_id
   
   -- Nos quedamos solo con los pedidos no cancelados
    WHERE ro.cancellation IN ('', 'null') OR ro.cancellation IS NULL
),
-- Desgloso los ingredientes
Lista AS (
	SELECT order_id
        ,toppings
		,SPLIT(toppings, ', ') AS SPLIT1
		,SPLIT1 [0]::INT AS Ingrediente1
		,SPLIT1 [1]::INT AS Ingrediente2
		,SPLIT1 [2]::INT AS Ingrediente3
		,SPLIT1 [3]::INT AS Ingrediente4
		,SPLIT1 [4]::INT AS Ingrediente5
		,SPLIT1 [5]::INT AS Ingrediente6
		,SPLIT1 [6]::INT AS Ingrediente7
		,SPLIT1 [7]::INT AS Ingrediente8
        ,SPLIT (extras, ', ') AS SPLIT2
        ,SPLIT2 [0]::INT AS Extra1
        ,SPLIT2 [1]::INT AS Extra2
        ,SPLIT (exclusions, ', ') AS SPLIT3
        ,SPLIT3 [0]::INT AS Exclusion1
        ,SPLIT3 [1]::INT AS Exclusion2
	FROM ingredientes
	),
-- Hago unpivot para los ingerdientes y extras
    TablaIngredientesyExtra AS (
    SELECT 
        IngredientesyExtra
    FROM Lista
    UNPIVOT(IngredientesyExtra FOR a IN (Ingrediente1, Ingrediente2, Ingrediente3, Ingrediente4, Ingrediente5, Ingrediente6, Ingrediente7, Ingrediente8, Extra1, Extra2))
    WHERE IngredientesyExtra IS NOT NULL
    ),
-- Hago unpivot para las exclusiones
    TablaExclusion AS (
    SELECT 
        Exclusion 
    FROM Lista
    UNPIVOT(Exclusion FOR a IN ( Exclusion1, Exclusion2))
    WHERE Exclusion IS NOT NULL
    ),
    -- Cuento Los Ingredientes y Extras
    CuentaTIE AS 
    (
    SELECT 
        IngredientesyExtra
        , COUNT(IngredientesyExtra) AS TotalIngredientesyExtra
        FROM TablaIngredientesyExtra
        GROUP BY IngredientesyExtra
    ),
    -- Cuento las exclusiones
    CuentaTE AS 
    (
    SELECT 
        Exclusion
        , COUNT(Exclusion) AS TotalExclusion
        FROM TablaExclusion
        GROUP BY Exclusion
    ),

    -- Uno las tablas de los counts ayudandome de la tabla pizza_toppings
    TablaCount AS (SELECT 
    pt.topping_id
    , CASE WHEN TIE.TotalIngredientesyExtra IS NULL THEN 0 ELSE TIE.TotalIngredientesyExtra END AS TotalIngredientesyExtra
    , CASE WHEN TE.TotalExclusion IS NULL THEN 0 ELSE TE.TotalExclusion END AS TotalExclusion
    FROM pizza_toppings pt
    LEFT JOIN CuentaTIE AS TIE
    on pt.topping_id=TIE.IngredientesyExtra
    LEFT JOIN CuentaTE AS TE
    ON pt.topping_id=TE.Exclusion
    ),

    -- Hago el cálculo de las veces repetidas totales
    TablaFinal AS (
    SELECT 
    topping_id
    , TotalIngredientesyExtra-TotalExclusion AS Veces_Repetido
    FROM TablaCount
    )
    
-- Limpio el resultado:
SELECT
      LISTAGG(pt.topping_name, ', ') as Ingrediente
, TF.Veces_Repetido
FROM TablaFinal AS TF
LEFT JOIN pizza_toppings pt
ON pt.topping_id=TF.topping_id
GROUP BY TF.Veces_Repetido
ORDER BY TF.Veces_Repetido DESC
