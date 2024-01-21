use database SQL_EN_LLAMAS;
use schema CASE01;

select * from members;
select * from sales;
select * from menu;

SELECT
  m.customer_id,
  COUNT(s.order_date,0) AS dias_visitados
FROM members m
LEFT JOIN sales s
ON m.customer_id = s.customer_id
GROUP BY m.customer_id
ORDER BY dias_visitados DESC;

------------------------------------------------------OUTPUT------------------------------

CUSTOMER_ID	DIAS_VISITADOS
A	6
B	6
C	3
D	0

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

El resultado no es del todo correcto, añadiría un distinct para no repetir días. Me ha gustado que muestres el output de la query y también que no des por hecho y añadas los use database y schema, ya que usas solo el nombre de las tablas en la select.
Respecto al count no se cuál es la finalidad del ",0" ya que no es necesario añadir una segunda expresión.

Mejoraría la legibilidad/visibilidad del código, esto es algo mas de gustos personales y hay varias formas de hacer más legible un código. Por mi parte lo formatería de la siguiente forma:

- Comas por delante de las columnas en el select.
SELECT
      m.customer_id
    , COUNT(distinct s.order_date) AS dias_visitados
FROM members m
    LEFT JOIN sales s
        ON m.customer_id = s.customer_id
GROUP BY m.customer_id
ORDER BY dias_visitados DESC;

- Comas por detrás de las columnas en el select.
SELECT
    m.customer_id,
    COUNT(distinct s.order_date) AS dias_visitados
FROM members m
    LEFT JOIN sales s
        ON m.customer_id = s.customer_id
GROUP BY m.customer_id
ORDER BY dias_visitados DESC;

Lo que si es común es tabular los JOINs y sus ONs correspondientes.

*/
