SELECT DISTINCT A.CUSTOMER_ID, B.PRODUCT_NAME
FROM (
    SELECT 
        CUSTOMER_ID,
        PRODUCT_ID,
        RANK() OVER (PARTITION BY CUSTOMER_ID ORDER BY ORDER_DATE) AS rank_num
    FROM SQL_EN_LLAMAS.CASE01.SALES
) A
INNER JOIN SQL_EN_LLAMAS.CASE01.MENU B ON (A.PRODUCT_ID=B.PRODUCT_ID)
WHERE rank_num = 1;

/*********************************/
/***** COMENTARIO JUAN PEDRO *****/
/*********************************/
/*
Sería interesante mostrar también al cliente que no ha hecho ningun pedido y admeás el cliente C pidio dos platos de ramen y esa información 
la has perdido con el distinct, el A pidio dos productos en su primer pedido pero al ser distintos no te ha ocurrido esa perdida de información.
Otra cosa es la visualización de los datos, tal vez con la función LISTAGG sería visualemtne más correcto pues agurparias en una sola fila cada cliente.
Si no te cuadra lo que te digo no dudes en preguntar.
*/
