-----------------------------------------------------LIMPIEZA DE TABLAS-----------------------------------------------------------------------
CREATE OR REPLACE TEMP TABLE ESPECIALIDAD_SQL_BRONZE_DB_SVM.PRUEBAS.CUSTOMER_ORDERS_CLEAN AS
    SELECT
        ORDER_ID,
        CUSTOMER_ID,
        PIZZA_ID,
        DECODE(EXCLUSIONS,'',NULL,'null',NULL,EXCLUSIONS) AS EXCLUSIONS,
        DECODE(EXTRAS,'',NULL,'null',NULL,EXTRAS) AS EXTRAS,
        ORDER_TIME   
    FROM CUSTOMER_ORDERS;

CREATE OR REPLACE TEMP TABLE ESPECIALIDAD_SQL_BRONZE_DB_SVM.PRUEBAS.RUNNER_ORDERS_CLEAN AS
    SELECT
        ORDER_ID,
        RUNNER_ID,
        TRY_CAST(PICKUP_TIME AS TIMESTAMP) AS PICKUP_TIME,
        CAST(REPLACE(UPPER(DECODE(DISTANCE,'',NULL,'null',NULL,DISTANCE)), 'KM') AS DECIMAL(15,2)) AS DISTANCE_KM,
        TO_NUMBER(REGEXP_REPLACE(DECODE(DURATION,'',NULL,'null',NULL,DURATION), '[a-zA-Z]', ''))AS DURATION_MIN,
        CASE
            WHEN TRIM(CANCELLATION) IN ('null', '') OR CANCELLATION IS NULL THEN NULL
            ELSE 'CANCELED'
        END AS CANCELLATION   
    FROM RUNNER_ORDERS;

--------------------------------------------------------------DIA_2----------------------------------------------------------

SELECT
    B.RUNNER_ID,
    SUM(IFNULL(DISTANCE_KM,0)) AS TOTAL_DISTANCIA_KM,
    IFNULL(ROUND(AVG(DISTANCE_KM/(DURATION_MIN/60)), 2),0) AS VELOCIDAD_MEDIA_KM_H
FROM ESPECIALIDAD_SQL_BRONZE_DB_SVM.PRUEBAS.RUNNER_ORDERS_CLEAN A
RIGHT JOIN RUNNERS B
    ON A.RUNNER_ID = B.RUNNER_ID
GROUP BY B.RUNNER_ID;


/*JUANPE: 

Resultado: Correcto

Código: Correcto. Aunque correcto te quiero comentar otra forma para la limpieza de los campos DISTANCE y DURATION. Hay unas expresiones que se conocen como
expresions regulares empiezan por "REGEXP_" son como una versión más "pro" de funciones como replace, substr, count, instr ... De hecho las usas pero no la 
aprovechas del todo, ya que el 'null' entrecomillado te lo cargas con el replace no hace falta el decode. El uso de try_cast también es otra opción para combinarla
y realizar la limpieza: 
    TRY_CAST(REGEXP_REPLACE(DISTANCE, '[a-zA-Z]', '') AS NUMBER(10, 2))
Otra versión puede ser con la función substr (para substraer), su versión mejorada nos permite:
    TRY_CAST(REGEXP_SUBSTR(DISTANCE, '[0-9]*[.]*[0-9]') AS NUMBER(10, 2))
Aquí le estamos diciendo que substraiga cualquier conjunto de dígitos entre el 0 y el 9 seguidos o no de un punto y seguidos o no de otro conjunto de digitos entre 0 y 9.
La ventaja del try_castes que si hay un registro que no pueda convertir no falla si no que lo convierte a nulo. No es mejor o peor una forma u otra es cuestión de gustos.
Te lo comento para que veas otras alternativas.

Legibilidad: Correcto

Extra: Bien por limpiar los nulos por 0 y por sacar los resultados con 2 decimales.

*/
