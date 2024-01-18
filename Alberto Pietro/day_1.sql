---------------------------------------------------------------------------------DAY 1 SQL EN LLAMAS---------------------------------------------------------------------------------------------------------------
use database SQL_EN_LLAMAS;
use schema CASE01;

select * from members;
select * from sales;
select * from menu;

SELECT
  m.customer_id,
  SUM(IFNULL(p.price,0)) AS suma_gastos_cliente
FROM members m
LEFT JOIN sales s
ON m.customer_id = s.customer_id
LEFT JOIN menu p
ON s.product_id = p.product_id
GROUP BY m.customer_id
ORDER BY suma_gastos_cliente DESC;

-----------------------------------------------------------------------------------OUTPUT------------------------------------------------------------------------------------------------------------------------------
OUTPUT:
CUSTOMER_ID	SUMA_GASTOS_CLIENTE
A	76
B	74
C	36
D	0

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

El resultado es correcto, me ha gustado el ifnull de la suma, mostrar el output de la query y también añadir los use database y schema, ya que usas solo el nombre de las tablas en la select.

Lo único mejorable sería la legibilidad/visibilidad del código, esto es algo mas de gustos personales y hay varias formas de hacer más legible un código. Por mi parte lo formatería de la siguiente forma:

- Comas por delante de las columnas en el select.
SELECT
      m.customer_id
    , SUM(IFNULL(p.price,0)) AS suma_gastos_cliente
FROM members m
    LEFT JOIN sales s
        ON m.customer_id = s.customer_id
    LEFT JOIN menu p
        ON s.product_id = p.product_id
GROUP BY m.customer_id
ORDER BY suma_gastos_cliente DESC;

- Comas por detrás de las columnas en el select.
SELECT
    m.customer_id,
    SUM(IFNULL(p.price,0)) AS suma_gastos_cliente
FROM members m
    LEFT JOIN sales s
        ON m.customer_id = s.customer_id
    LEFT JOIN menu p
        ON s.product_id = p.product_id
GROUP BY m.customer_id
ORDER BY suma_gastos_cliente DESC;

Lo que si es común es tabular los JOINs y sus ONs correspondientes

*/
