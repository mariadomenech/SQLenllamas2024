SELECT 
      customer_id
    , product_name
FROM (
        SELECT
              s.customer_id
            , m.product_name
            , s.order_date
            , RANK() OVER (PARTITION BY s.customer_id
                        ORDER BY s.order_date)
                    AS PRIMERA_CONSUMICION
        FROM
            SQL_EN_LLAMAS.CASE01.SALES S
        JOIN SQL_EN_LLAMAS.CASE01.MENU M
            ON S.product_id = M.product_id 
    )
WHERE PRIMERA_CONSUMICION = 1

/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/

/* 

Me parece muy guay que hagas uso de una función de ventana como es el RANK. Así veo que las entiendes.

Quizás como extra, porque lo que pedimos lo cumples, mejoraría la visualización de los resultados finales, de modo que sean más sencillos de interpretar
para alguien que vea el resultado en forma de tabla.

*/
