--SI CADA EURO GASTADO EQUIVALE A 10 PUNTOS Y EL SUSHI TIENE UN MULTIPLICADOR DE X2 PUNTOS ¿CUÁNTOS PUNTOS TENDRÍA CADA CLIENTE?

SELECT 
  A.customer_id,
  SUM(NVL(A.points,0)) AS total_points
FROM 
    (
      SELECT 
        members.customer_id,
          CASE 
            WHEN menu.product_name = 'sushi' THEN menu.price * 10 * 2
            ELSE menu.price * 10
          END AS points
      FROM case01.members 
      FULL JOIN case01.sales 
        ON members.customer_id = sales.customer_id
      LEFT JOIN case01.menu 
        ON menu.product_id = sales.product_id
    ) A   
GROUP BY 1
ORDER BY 2 DESC;


/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

El resultado es correcto, aunque se podria simplificar un poco la query.
Además, se utiliza FULL JOIN el cual se debe de evitar, por lo que se debería de sustituir por LEFT o RIGHT JOIN (LEFT JOIN en este caso).

SELECT 
      members.customer_id
    , SUM(IFNULL(IFF(menu.product_name = 'sushi', menu.price * 10 * 2, menu.price * 10), 0)) AS points
FROM case01.members 
LEFT JOIN case01.sales 
    ON members.customer_id = sales.customer_id
LEFT JOIN case01.menu 
    ON menu.product_id = sales.product_id
GROUP BY 1
ORDER BY 2 DESC;

*/
