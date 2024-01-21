-- ¿Cuántos días ha visitado el restaurante cada cliente?
SELECT 
    members.customer_id
   ,COUNT(DISTINCT order_date) AS visited_days
FROM case01.sales
FULL JOIN case01.members
       ON sales.customer_id = members.customer_id       
GROUP BY members.customer_id;

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

El resultado es correcto, pero utilizas FULL JOIN lo cual no es recomendable ya que, en tablas con millones de registros, el rendimiento se ve drásticamente afectado (en nuestro caso no se nota diferencia
ya que tenemos pocos registros). En este caso, se debería de utilizar RIGHT JOIN para utilizar la tabla MEMBERS como principal:

SELECT 
     members.customer_id
   , COUNT(DISTINCT order_date) AS visited_days
FROM case01.sales
    RIGHT JOIN case01.members
       ON sales.customer_id = members.customer_id       
GROUP BY members.customer_id;

*/
