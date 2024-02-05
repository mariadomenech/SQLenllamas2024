--¿EN CUÁNTOS DÍAS DE MEDIA SE REASIGNAN LOS CLIENTES A UN NODO DIFERENTE?--

WITH NODOS_CLIENTE AS
(
    SELECT
         CUSTOMER_ID
        ,REGION_ID
        ,NODE_ID
        ,START_DATE
        ,END_DATE
        ,NVL(LAG(NODE_ID) OVER (PARTITION BY CUSTOMER_ID ORDER BY END_DATE),-1) AS NODO_ANTERIOR
        ,NVL(LEAD(NODE_ID) OVER (PARTITION BY CUSTOMER_ID ORDER BY END_DATE), -1) AS NODO_SIGUIENTE
    FROM 
        SQL_EN_LLAMAS.CASE03.CUSTOMER_NODES
    WHERE 
        END_DATE <> TO_DATE('9999-12-31')
),
CLEANED_NODES AS
(
    SELECT 
         A.*
    FROM NODOS_CLIENTE A
    WHERE NOT (NODE_ID = NODO_SIGUIENTE  AND NODO_ANTERIOR = NODE_ID)
    ORDER BY START_DATE
)

SELECT 
    ROUND(AVG(DATEDIFF(DAY,FECHA_COMIENZO_ACTUALIZADA,FECHA_FINALIZACION_ACTUALIZADA)),2) AS MEDIA_DIAS_CAMBIO_NODO
FROM (
        SELECT
            DISTINCT CUSTOMER_ID
           ,REGION_ID
           ,NODE_ID
           ,CASE
                WHEN NODO_ANTERIOR = NODE_ID THEN LAG(START_DATE) OVER (PARTITION BY CUSTOMER_ID ORDER BY END_DATE)
                WHEN NODO_ANTERIOR <> NODE_ID THEN START_DATE
            END AS FECHA_COMIENZO_ACTUALIZADA
           ,CASE
                WHEN NODO_SIGUIENTE = NODE_ID THEN LEAD(END_DATE) OVER (PARTITION BY CUSTOMER_ID ORDER BY END_DATE)
                WHEN NODO_SIGUIENTE <> NODE_ID THEN END_DATE
            END AS FECHA_FINALIZACION_ACTUALIZADA
        FROM CLEANED_NODES)A;
/*
COMENTARIOS JUANPE:

RESULTADO: INCORRECTO! CASI!! El reultado correcto es 17.865859 te explico en el siguiente apartado la diferencia.

CODIGO: INCORRECTO! La lógica del ejercicio es tal cual la planteas salvo por un pequeño matiz, haces demasiado pronto el filtro: END_DATE <> TO_DATE('9999-12-31')
Este filtro debiera ser justo al final antes de tu punto y coma. Y por consiguiente debería ser: FECHA_FINALIZACION_ACTUALIZADA <> TO_DATE('9999-12-31')
¿Qué ocurre de una forma y de otra? Veamos el ejemplo del customer_id 1.
Primero estuvo en nodo 4, durante 12 días y pasó al 2, que estuvo 1 día y pasó al 5 que estuvo 11 días y pasó al nodo 3 que estuvo 20 días y pasó al 2.
Este es el último hasta la fecha. Por tanto (12+1+11+20)/4=44/4=11 días. Eso es lo que sabemos si miramos a ojo pero, ¿al poner el filtro antes qué ocurre?
El ulitmo nodo en que está es el 2, pero hay doble registro. En el primer registro estuvo 26 días y luego hubo otro registro pero sin cambiar de nodo por lo tanto
no debemos tener ese 26 en la media, y al filtrar antes de tiempo por la fecha abierta '9999-12-31' te ocurre esta diferencia. Es decir, has filtrado el último 
registro pero no el último nodo entero. Si esto sigue sin cuadrarte podemos verlo más en detalle, no dudes en preguntarme.

LEGIBLIDAD: CORRECTO

EXTRA: Muy bien resuelto salvo por el matiz bien uso de la lógica y bien jugado con los nodos anteriores y posteriores para establecer las fechas reales de cambio
de nodo.
*/
