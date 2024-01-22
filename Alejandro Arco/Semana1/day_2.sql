SELECT
    members.customer_id,
    COUNT(DISTINCT order_date) AS total_dias
FROM
    members
LEFT JOIN
    sales
ON members.customer_id = sales.customer_id
GROUP BY
    members.customer_id;

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

El resultado es correcto.

Lo único mejorable sería la legibilidad/visibilidad del código. Por mi parte lo formatería de la siguiente forma:

SELECT
      members.customer_id
    , COUNT(DISTINCT order_date) AS total_dias
FROM members
LEFT JOIN sales
    ON members.customer_id = sales.customer_id
GROUP BY members.customer_id;

*/
