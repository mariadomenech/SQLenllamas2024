WITH primera AS (
    SELECT 
        b.runner_id AS corredor, 
        order_id,
        CASE WHEN distance = 'null' THEN '0'
            WHEN distance IS NULL THEN '0'
            WHEN distance = '' THEN '0'
            ELSE distance END AS distancia,
        CASE WHEN duration = 'null' THEN '0'
            WHEN duration IS NULL THEN '0'
            WHEN duration = '' THEN '0'
            ELSE duration END AS duracion
        
    FROM SQL_EN_LLAMAS.CASE02.RUNNER_ORDERS A
    FULL JOIN SQL_EN_LLAMAS.CASE02.RUNNERS B
        ON A.RUNNER_ID=B.RUNNER_ID
    ORDER BY B.RUNNER_ID, order_id
),

segunda AS (
    SELECT 
        corredor,
        TRIM(distancia, ' km') AS distancia_km,
        ROUND((TRIM(duracion, 'minutes')/60),4) AS duracion_horas
    FROM primera
    order by corredor
),

tercera AS (
    SELECT 
        corredor,
        distancia_km,
        duracion_horas,
        CASE WHEN duracion_horas = 0 THEN NULL
            WHEN distancia_km = 0 THEN NULL
            ELSE ROUND(distancia_km/duracion_horas,2) END AS velocidad_km_h
    FROM segunda
)

SELECT 
    corredor, 
    ROUND(AVG(velocidad_km_h),2) AS velocidad_media,
    SUM(distancia_km) AS distancia_acumulada
FROM tercera
GROUP BY corredor
ORDER BY corredor;


/*JUANPE: 

Resultado: Correcto. 

Código: Correcto pero mejorable. El primer cte el full es mejor poner right. En cuanto a los pasos para limpiar los campos distancia y duración aunque correcto
considero que das demasiados pasos quedando un código muy largo. Esta bien el uso del TRIM pero existen otras mejores y además ciertos pasos se pueden agrupar.
Te quiero comentar unas funciones útiles que puedes usar para la limpieza de los campos DISTANCE y DURATION. Hay unas expresiones que se conocen como
expresiones regulares empiezan por "REGEXP_" son como una versión más "pro" de funciones como replace, substr, count, instr ... En el caso de querer limpiar el 
campo con un replace podríamos hacer algo así: 
    TRY_CAST(REGEXP_REPLACE(DISTANCE, '[a-zA-Z]', '') AS NUMBER(10, 2))
Aquí le estamos diciendo que cualquier letra comprendida entre la A y la Z (minúscula y mayúscula), las reemplaza por '' (dos comillas y en medio nada). 
Otra versión puede ser con la función substr (para substraer), su versión mejorada nos permite:
    TRY_CAST(REGEXP_SUBSTR(DISTANCE, '[0-9]*[.]*[0-9]') AS NUMBER(10, 2))
Aquí le estamos diciendo que substraiga cualquier conjunto de dígitos entre el 0 y el 9 seguidos o no de un punto y seguidos o no de otro conjunto de dígitos entre 0 y 9.
La diferencia entre el try_cast y el cast es que si hay un registro que no pueda convertir el cast falla y el try_cast lo convierte a nulo. No es mejor o peor uno u otro 
es cuestión de gustos pues si se usa bien no hay problema. Pero en cuanto a las expresiones regulares si te pueden ofrecer ciertas ventajas. Aunque correcta tu forma, 
es menos genérica. Al final te pongo mi propuesta de código que tiene muchas menos lineas de código.

Legibilidad: Correcto aunque muchos with para algo tan simple

Extra: Bien en mosrtar al 4 runner pero no para este la distancia en vez de nula pones 0 en la velocidad en cambio dejas null. La velocidad bien pos mostrar en 2 decimales 
en cambio en la distancia muestras unos datos con un decima y otros con ninguno, siempre queda mejor usar un formato igual para todos los registros
*/
--Mi propuesta (limpio distancia y tiempo cada uno de forma distinta). Dado que es una query de pocas lineas, he preferido una subselect a una cte, pero 
--eso es cuestion de gustos.
SELECT B.RUNNER_ID
     , NVL(SUM(A.DISTANCIA_KM),0) AS DISTANCIA_ACUMULADA_KM
     , NVL(ROUND(AVG(A.VELOCIDAD_KM_H),2),0) AS VELOCIDAD_PROMEDIO_KM_H
FROM (SELECT RUNNER_ID
           , TRY_CAST(REGEXP_REPLACE(DISTANCE, '[a-zA-Z]', '') AS NUMBER(10, 2)) AS DISTANCIA_KM
           , TRY_CAST(REGEXP_SUBSTR(DURATION, '[0-9]*[.]*[0-9]') AS NUMBER) AS TIEMPO_MIN
           , 60*DISTANCIA_KM/TIEMPO_MIN AS VELOCIDAD_KM_H
      FROM RUNNER_ORDERS) A
RIGHT JOIN RUNNERS B
     USING (RUNNER_ID)
GROUP BY RUNNER_ID;

