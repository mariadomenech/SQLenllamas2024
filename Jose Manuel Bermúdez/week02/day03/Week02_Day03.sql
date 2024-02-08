USE sql_en_llamas;
USE SCHEMA case02;

-- Ganancias = Importe pizzas entregadas + Importe ingredientes extras pizzas entregadas - Pago runners km recorrido
SELECT ROUND((SUM(CASE WHEN pizza_id=1 THEN 12 WHEN pizza_id=2 THEN 10 END) +
        SUM(CASE WHEN extras <> 'null' AND extras <> '' AND extras IS NOT NULL THEN (len(extras) - len(replace(extras,',',''))+1) END) -
        (SUM(CASE WHEN regexp_replace(distance, '[^0-9.]', '') <> '' THEN CAST(regexp_replace(distance, '[^0-9.]', '') AS DECIMAL(15,2)) ELSE 0 END) * 0.3)),2) AS "Ganancias Giuseppe"
FROM runner_orders ro
INNER JOIN customer_orders co
    ON ro.order_id = co.order_id
WHERE NOT (ro.cancellation <> 'null' AND ro.cancellation <> '' AND ro.cancellation IS NOT NULL);



/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/* 

Has tenido un fallo que incluso yo tuve cuando planteé el ejercicio.

Si un  pedido tiene dos pizzas, la distancia solo la cuentas una vez. Ten cuidado porque has contado como si cada pizza fuera un viaje diferente.
El gasto total debe salir  43.56.

Por tanto, puedes hacerte un indicador que te diga cuántas pizzas hay por pedido, y te quedas solo con el registro cuando el contador sea 1.

Lo demás perfecto!
*/
