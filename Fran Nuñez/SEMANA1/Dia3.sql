SELECT MEMBERS.CUSTOMER_ID AS "CLIENTE",  MENU.PRODUCT_NAME AS "PRODUCTO", SALES.ORDER_DATE AS "FECHA PRIMER PEDIDO"
FROM SALES
FULL JOIN MEMBERS
ON SALES.CUSTOMER_ID = MEMBERS.CUSTOMER_ID
JOIN MENU
ON SALES.PRODUCT_ID = MENU.PRODUCT_ID
WHERE ORDER_DATE=(SELECT MIN (ORDER_DATE) FROM SALES)
GROUP BY MEMBERS.CUSTOMER_ID, MENU.PRODUCT_NAME, SALES.ORDER_DATE

/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/* 


El resultado es correcto, Fran.

Un poco como los anteriores días, el tema de los FULL JOIN y tabulaciones.

Pero aquí ten cuidado con cómo has montado la subconsulta, porque en este caso, coincide que los 3 clientes pidieron por primera vez en el mismo día, pero 
y, ¿si no hubiera sido así?

Te propongo que le des una vuelta a cómo montarías esa misma subconsulta, para que coja la fecha mínima dependiendo del cliente.

Quizás como extra, porque lo que pedimos lo cumples, mejoraría la visualización de los resultados finales, de modo que sean más sencillos de interpretar
para alguien que vea el resultado en forma de tabla. Te invito a explorar la función LISTAGG.

*/
