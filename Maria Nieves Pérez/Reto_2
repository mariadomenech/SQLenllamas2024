SELECT 
    m.customer_id,
    count(DISTINCT order_date) AS visitas
FROM SQL_EN_LLAMAS.CASE01.SALES s
    RIGHT JOIN SQL_EN_LLAMAS.CASE01.MEMBERS m 
        ON s.customer_id=m.customer_id
GROUP BY m.customer_id
ORDER BY m.customer_id;

/*********************************/
/***** COMENTARIO JUAN PEDRO *****/
/*********************************/
/*
¡Todo correcto enhorabuena
*/
