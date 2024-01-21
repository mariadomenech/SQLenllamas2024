--¿Cuánto ha gastado en total cada cliente en el restaurante?
SELECT 
     members.customer_id
    ,COALESCE(SUM(menu.price),0) AS total_spend
FROM case01.sales
JOIN case01.menu
        ON sales.product_id = menu.product_id
FULL JOIN case01.members 
        ON sales.customer_id = members.customer_id
GROUP BY members.customer_id;

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

El resultado es correcto, pero utilizas FULL JOIN lo cual no es recomendable ya que, en tablas con millones de registros, el rendimiento se ve drásticamente afectado (en nuestro caso no se nota diferencia
ya que tenemos pocos registros). En este caso, se debería de utilizar RIGHT JOIN:

SELECT 
      members.customer_id
    , COALESCE(SUM(menu.price),0) AS total_spend
FROM case01.sales
    INNER JOIN case01.menu
        ON sales.product_id = menu.product_id
    RIGHT JOIN case01.members 
        ON sales.customer_id = members.customer_id
GROUP BY members.customer_id;

Como recomendación, empezaría a utilizar alias siempre que se hagan cruces de tablas, ya que en muchos casos los nombres de las tablas son largos o poco claros.

*/
