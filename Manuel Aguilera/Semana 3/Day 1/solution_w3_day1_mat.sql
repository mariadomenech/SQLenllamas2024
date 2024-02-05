 -- Selecciona la información necesaria y calcula el próximo nodo, anterior 
WITH CUSTOMER_NODES_PROXIMO_ANTERIOR_NODO AS (
    SELECT
        CUSTOMER_ID,
        LEAD(NODE_ID) OVER (PARTITION BY CUSTOMER_ID ORDER BY START_DATE DESC) AS ANTERIOR_NODO,
        NODE_ID AS ACTUAL_NODO,
        LEAD(NODE_ID) OVER (PARTITION BY CUSTOMER_ID ORDER BY START_DATE) AS PROXIMO_NODO,
        START_DATE,
        END_DATE
    FROM
        SQL_EN_LLAMAS.CASE03.CUSTOMER_NODES
    ORDER BY 
        CUSTOMER_ID, START_DATE
),
 -- Selecciona la información necesaria y calcula la fecha anterior si el nodo anterior y actual es el mismo 
CUSTOMER_NODES_CLEAN AS(
SELECT 
    CUSTOMER_ID, 
    ANTERIOR_NODO,
    ACTUAL_NODO,
    PROXIMO_NODO,
    CASE 
        WHEN ACTUAL_NODO = ANTERIOR_NODO
            THEN LEAD(START_DATE) OVER (PARTITION BY CUSTOMER_ID ORDER BY START_DATE DESC)
        ELSE START_DATE
    END AS START_DATE,
    END_DATE 
FROM CUSTOMER_NODES_PROXIMO_ANTERIOR_NODO
    WHERE NOT(ACTUAL_NODO = NVL(ANTERIOR_NODO,0) AND ACTUAL_NODO=PROXIMO_NODO) --Con este filtro quitamos aquellas lineas que tanto el anterior como siguiente nodo es el mismo
    ORDER BY START_DATE  
)
-- Consulta principal que calcula la media de días de reasignación
SELECT 
    AVG(END_DATE - START_DATE) AS MEDIA_DIAS
FROM CUSTOMER_NODES_CLEAN
    -- Filtra los nodos que no han sido desasignadas y el nodo actual es diferente al próximo nodo
WHERE 
    END_DATE <> '9999-12-31' 
    AND ACTUAL_NODO <> PROXIMO_NODO;


/*
COMENTARIOS JUANPE:

RESULTADO: CORRECTO

CÓDIGO: CORRECTO. Nada que comentar salvo que para el nodo anterior usas lead ordenando por DESC y es totalmente válido pero aprovecho para decirte 
una función ánaloga a LEAD que es LAG, esta mira el anterior ordenando de forma ASC).

LEGIBILIDAD: CORRECTO

EXTRA: Muy bien resuelto. Bien jugado con los nodos anteriores y posteriores para establecer las fechas reales de cambio de nodo.
*/
