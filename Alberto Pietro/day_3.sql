with prod_client_1 AS( SELECT
  m.customer_id AS customer_id,
  IFNULL(p.product_name,'NINGÙN PRODUCTO') as product_name,
  RANK() OVER (PARTITION BY m.customer_id ORDER BY s.order_date) AS earlier_order_date
FROM members m
LEFT JOIN sales s
ON m.customer_id = s.customer_id
LEFT JOIN menu p
ON s.product_id = p.product_id
GROUP BY m.customer_id,product_name,s.order_date
ORDER BY m.customer_id)

SELECT 
    customer_id,
    product_name
FROM 
    prod_client_1
WHERE earlier_order_date = 1;

----------------------------------------------------------OUTPUT-----------------------------

CUSTOMER_ID	PRODUCT_NAME
A	          sushi
A         	curry
B	          curry
C	          ramen
D	          NINGÙN PRODUCTO

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

El resultado es correcto, me ha gustado la utilización de CTEs y el hecho de mostrar el output de la query.

Lo único mejorable sería la legibilidad/visibilidad del código, esto es algo mas de gustos personales y hay varias formas de hacer más legible un código. Por mi parte lo formatería de la siguiente forma:

- Comas por delante de las columnas en el select (gusto personal).
with prod_client_1 AS (
    SELECT
          m.customer_id AS customer_id
        , IFNULL(p.product_name,'NINGÙN PRODUCTO') as product_name
        , RANK() OVER (PARTITION BY m.customer_id ORDER BY s.order_date) AS earlier_order_date
    FROM members m
        LEFT JOIN sales s
            ON m.customer_id = s.customer_id
        LEFT JOIN menu p
            ON s.product_id = p.product_id
    GROUP BY m.customer_id,product_name,s.order_date
    ORDER BY m.customer_id
)

SELECT 
      customer_id
    , product_name
FROM prod_client_1
WHERE earlier_order_date = 1;

- Comas por detrás de las columnas en el select.
with prod_client_1 AS (
    SELECT
        m.customer_id AS customer_id,
        IFNULL(p.product_name,'NINGÙN PRODUCTO') as product_name,
        RANK() OVER (PARTITION BY m.customer_id ORDER BY s.order_date) AS earlier_order_date
    FROM members m
        LEFT JOIN sales s
            ON m.customer_id = s.customer_id
        LEFT JOIN menu p
            ON s.product_id = p.product_id
    GROUP BY m.customer_id,product_name,s.order_date
    ORDER BY m.customer_id
)

SELECT 
    customer_id,
    product_name
FROM prod_client_1
WHERE earlier_order_date = 1;

Las definiciones de una CTE personalmente las prefiero tabluadas un nivel y por debajo del with.
Lo que si es común es tabular los JOINs y sus ONs correspondientes.

*/
