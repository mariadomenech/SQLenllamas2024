SELECT SALES.CUSTOMER_ID AS CLIENTE,
       SALES.ORDER_DATE AS FECHA_PEDIDO,
       MENU.PRODUCT_NAME AS PRODUCTO
FROM SQL_EN_LLAMAS.CASE01.SALES AS SALES
JOIN 
    (SELECT CUSTOMER_ID AS CLIENTE, MIN(ORDER_DATE) AS MIN_FECHA
     FROM SQL_EN_LLAMAS.CASE01.SALES
     GROUP BY CUSTOMER_ID
    ) AS MIN_DATE
ON SALES.ORDER_DATE = MIN_DATE.MIN_FECHA
JOIN SQL_EN_LLAMAS.CASE01.MENU AS MENU
ON SALES.PRODUCT_ID = MENU.PRODUCT_ID
GROUP BY SALES.CUSTOMER_ID, SALES.ORDER_DATE, MENU.PRODUCT_NAME
ORDER BY CLIENTE

/*********************************/
/***** COMENTARIO JUAN PEDRO *****/
/*********************************/
/*
El cruce con la tabla MENU es más conveniente un LEFT (pero no obligatorio). 

Lo otro si es importante, en el primer cruce te falta una condicón, pues estás cruzando solo por fecha, pero tu tabla del from con tu tabla del primer JOIN 
debe cruzar también por cliente, es decir, después del primer ON te faltaría AND SALES.CUSTOMER_ID = MIN_DATE.CLIENTE.

Por último el cliente C pone que pidio ramen, pero realmente pidio dos ramen esa información se ha perdido, igual que el cliente A pidio dos platos 
solo que en su caso son distintos y no se ha perdido esa información. Además es interesante mostrar los resultados en una sola linea por cliente usando 
la función LISTAGG en la select, LISTAGG(MENU.PRODUCT_NAME,'-') y por tanto el group by solo SALES.CUSTOMER_ID.

Además también es interesante sacar al cliente D ya que esta en la tabla de members aúnque no haya pedido nada.

Cualquier cosa que no te cuadre de lo que te digo no dudes en preguntarme.
*/
