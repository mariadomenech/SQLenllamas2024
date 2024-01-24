/*Día 3: Una pizza meat lovers(1) cuesta 12 y la vegetariana(2) 10. Cada ingrediente extra 1 euros Cada 
runner se le paga 0.30 km ¿Cuánto dinero queda de ganancia después de las entregas?*/

SELECT 
    (SUM(DINERO_GENERADO + EXTRAS_OK)) - (SUM(KM_TOTALES * 0.30)) AS BENEFICIO_TOTAL
FROM(
    SELECT 
        PEDIDO,
        DINERO_GENERADO,
        CASE WHEN EXTRAS IS NULL THEN 0 ELSE EXTRAS END AS EXTRAS_OK,
        KM_TOTALES
    FROM(
        SELECT 
            co.ORDER_ID AS PEDIDO,
            SUM(CASE 
                    WHEN ro.PICKUP_TIME IS NULL THEN 0
                    ELSE
                        CASE 
                            WHEN co.PIZZA_ID = 1 THEN 12
                            ELSE 10
                        END
                END) AS DINERO_GENERADO,
                SUM(ARRAY_SIZE(SPLIT(CO.EXTRAS, ','))) AS EXTRAS,
                SUM(ro.DISTANCE) AS KM_TOTALES
        FROM RUNNER_ORDERS_OK ro 
        LEFT JOIN CUSTOMER_ORDERS_OK co 
            ON co.ORDER_ID = ro.ORDER_ID
        WHERE ro.PICKUP_TIME IS NOT NULL
        GROUP BY co.ORDER_ID
        ORDER BY co.ORDER_ID));
