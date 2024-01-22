SELECT customer_id AS CLIENTE,
COUNT(DISTINCT order_date) NUM_VISITAS
FROM SQL_EN_LLAMAS.CASE01.SALES
GROUP BY customer_id
ORDER BY 2 DESC


/*********************************/
/***** COMENTARIO JUAN PEDRO *****/
/*********************************/
/*
Para que estuviera del todo correcto haría falta sacar a todos los clientes de la tabla MEMBERS hayan realizado o no una compra. Por lo demás todo OK.
*/

