--Obtenemos la tupla que supone el primer tramo de fechas en un nodo determinado con la función de ventana LAG.
WITH inicio_nodo AS (
    SELECT
        *,
        CASE
            WHEN LAG(NODE_ID) OVER (PARTITION BY customer_id ORDER BY start_date) = node_id THEN 0
            ELSE 1
        END AS tramo_inicial
    FROM SQL_EN_LLAMAS.CASE03.CUSTOMER_NODES
),
/*
Nos quedamos solo con los inicios en cada nodo y restamos las fechas de inicio del siguiente tramo con el actual
menos 1 porque la fecha fin en el tramo es el día anterior a la del comienzo en el siguiente nodo. Además, con
QUALIFY me quito el último nodo en el que está cada cliente porque ya no se produce cambio alguno.
*/
dias_cambio AS (
    SELECT
        customer_id,
        LEAD(start_date) OVER (PARTITION BY customer_id ORDER BY start_date) - start_date - 1 AS dias_en_nodo
    FROM inicio_nodo
    WHERE tramo_inicial = 1
    QUALIFY LEAD(start_date) OVER (PARTITION BY customer_id ORDER BY start_date) IS NOT NULL
    ORDER BY customer_id, start_date
)
/*
Finalmente, calculo la media (espero no haberme equivocado esta vez) como la suma de todos los días que estuvo cada 
cliente en un nodo hasta cambiar a uno diferente entre el número de cambios totales, sin diferenciar por clientes.
Muestro el resultado con dos decimales por un lado e incluido en un texto sin redondear por otro que es como más correcto 
me parece al tratarse de días. Mostrar la solución en formato texto ha sido por probar algo diferente al tener solo un dato.
¿Cómo de recomendable es realmente mostrar así la solución?
*/
SELECT
    ROUND(AVG(dias_en_nodo), 2) AS dias_reasignacion_media,
    CONCAT('Los clientes se reasignan a un nodo diferente cada ' || ROUND(AVG(dias_en_nodo)) || ' días de media.') AS texto
FROM dias_cambio;
