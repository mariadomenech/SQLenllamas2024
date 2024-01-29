WITH CUSTOMER_NODES_PROXIMO_NODO AS (
    -- Selecciona la información necesaria y calcula el próximo nodo y la fecha anterior
    SELECT
        CUSTOMER_ID,
        NODE_ID AS ACTUAL_NODO,
        LEAD(NODE_ID) OVER (PARTITION BY CUSTOMER_ID ORDER BY START_DATE) AS PROXIMO_NODO,
        COALESCE(LEAD(START_DATE) OVER (PARTITION BY CUSTOMER_ID ORDER BY START_DATE DESC), START_DATE) AS ANTERIOR_DATE,
        START_DATE,
        END_DATE
    FROM
        SQL_EN_LLAMAS.CASE03.CUSTOMER_NODES
    WHERE 
        CUSTOMER_ID IN (1, 2)
    ORDER BY 
        CUSTOMER_ID, START_DATE
)
SELECT 
    -- Calcula la media de la diferencia entre la fecha de fin y la fecha anterior
    AVG(COALESCE(END_DATE, CURRENT_DATE) - COALESCE(ANTERIOR_DATE, START_DATE)) AS MEDIA
FROM 
    CUSTOMER_NODES_PROXIMO_NODO
WHERE 
    -- Filtra las reasignaciones que no han sido desasignadas y el nodo actual es diferente al próximo nodo
    END_DATE <> '9999-12-31' 
    AND ACTUAL_NODO <> PROXIMO_NODO;


 -- Selecciona la información necesaria y calcula el próximo nodo, anterior y la fecha anterior
WITH CUSTOMER_NODES_PROXIMO_NODO AS (
    SELECT
        CUSTOMER_ID,
        LEAD(NODE_ID) OVER (PARTITION BY CUSTOMER_ID ORDER BY START_DATE DESC) AS ANTERIOR_NODO,
        NODE_ID AS ACTUAL_NODO,
        LEAD(NODE_ID) OVER (PARTITION BY CUSTOMER_ID ORDER BY START_DATE) AS PROXIMO_NODO,
        LEAD(START_DATE) OVER (PARTITION BY CUSTOMER_ID ORDER BY START_DATE DESC) AS ANTERIOR_DATE,        
        START_DATE,
        END_DATE
    FROM
        SQL_EN_LLAMAS.CASE03.CUSTOMER_NODES
    ORDER BY 
        CUSTOMER_ID, START_DATE
)
-- Consulta principal que calcula la media de días de reasignación
SELECT AVG(
        CASE
            WHEN ACTUAL_NODO = ANTERIOR_NODO 
                THEN END_DATE - ANTERIOR_DATE
            ELSE
                END_DATE - START_DATE
        END
    ) AS MEDIA_DIAS
FROM CUSTOMER_NODES_PROXIMO_NODO
    -- Filtra los nodos que no han sido desasignadas y el nodo actual es diferente al próximo nodo
WHERE 
    END_DATE <> '9999-12-31' 
    AND ACTUAL_NODO <> PROXIMO_NODO;
