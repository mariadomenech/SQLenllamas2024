WITH RUNNER_ORDERS AS (
    SELECT
        ORDER_ID,
        RUNNER_ID,
        PICKUP_TIME,
        CAST(REPLACE(DISTANCE,'km','') AS NUMBER(5,2)) AS DISTANCE_NUMBER,
        CAST(REPLACE(REPLACE(REPLACE(DURATION,'minutes',''),'mins',''),'minute','') AS NUMBER(5,2)) AS DURATION_NUMBER,
        DISTANCE_NUMBER/(DURATION_NUMBER/60) AS KM_H,
        CASE WHEN CANCELLATION IN ('', 'null') THEN NULL ELSE CANCELLATION END AS CANCELLATION_REAL
    FROM SQL_EN_LLAMAS.CASE02.RUNNER_ORDERS
    WHERE CANCELLATION_REAL IS NULL
)

SELECT
    R.RUNNER_ID,
    SUM(RO.DISTANCE_NUMBER) AS DISTANCE_TOTAL,
    CAST(AVG(RO.KM_H) AS NUMBER(5,2)) AS VELOCIDAD_PROMEDIO
FROM RUNNER_ORDERS RO
RIGHT JOIN SQL_EN_LLAMAS.CASE02.RUNNERS R
ON RO.RUNNER_ID = R.RUNNER_ID
GROUP BY R.RUNNER_ID;


/*JUANPE: 

Resultado: Correcto

Código: Correcto. Aunque correcto te quiero comentar unas funciones útiles que puedes usar para la limpieza de los campos DISTANCE y DURATION. Hay unas expresiones que se conocen como
expresiones regulares empiezan por "REGEXP_" son como una versión más "pro" de funciones como replace, substr, count, instr ... En el caso de querer limpiar el campo con un replace podríamos
hacer algo así: 
    TRY_CAST(REGEXP_REPLACE(DISTANCE, '[a-zA-Z]', '') AS NUMBER(10, 2))
Aquí le estamos diciendo que cualquier letra comprendida entre la A y la Z (minúscula y mayúscula), las reemplaza por ''. 
Otra versión puede ser con la función substr (para substraer), su versión mejorada nos permite:
    TRY_CAST(REGEXP_SUBSTR(DISTANCE, '[0-9]*[.]*[0-9]') AS NUMBER(10, 2))
Aquí le estamos diciendo que substraiga cualquier conjunto de dígitos entre el 0 y el 9 seguidos o no de un punto y seguidos o no de otro conjunto de dígitos entre 0 y 9.
La diferencia entre el try_cast y el cast es que si hay un registro que no pueda convertir el cast falla y el try_cast lo convierte a nulo. No es mejor o peor uno u otro es cuestión de gustos
pues si se usa bien no hay problema. Pero en cuanto a las expresiones regulares si te pueden ofrecer ciertas ventajas.

Legibilidad: Correcto

Extra: Hubiera sido un extra que los resultados del runner 4 en vez de nulos pusiera 0. Bien en redondear a dos decimales el resultado de la velocidad. 

*/
