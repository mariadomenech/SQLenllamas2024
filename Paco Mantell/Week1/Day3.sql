SELECT DISTINCT A.customer_id CLIENTE,
A.order_date FECHA,
B.product_name PRODUCTO
FROM SQL_EN_LLAMAS.CASE01.SALES A
JOIN SQL_EN_LLAMAS.CASE01.MENU B
ON A.PRODUCT_ID=B.PRODUCT_ID
WHERE order_date=(SELECT MIN(order_date)
FROM SQL_EN_LLAMAS.CASE01.SALES)

/*********************************/
/***** COMENTARIO JUAN PEDRO *****/
/*********************************/
/*
Piensa que el cliente C pidio dos platos de ramen y esa información la has perdido con el distinct, el A pidio dos productos en su primer pedido 
pero al ser distintos no te ha ocurrido esa perdida de información.
Otra cosa es la visualización de los datos, tal vez con la función LISTAGG sería visualemtne más correcto pues agurparias en una sola fila cada cliente.
Si no te cuadra lo que te digo no dudes en preguntar.
*/
