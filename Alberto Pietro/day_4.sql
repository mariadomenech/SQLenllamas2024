SELECT
  IFNULL(p.product_name,'NINGÙN PRODUCTO') as product_name,
  COUNT(p.product_name) AS product_count
FROM members m
LEFT JOIN sales s
ON m.customer_id = s.customer_id
LEFT JOIN menu p
ON s.product_id = p.product_id
GROUP BY product_name
ORDER BY product_count DESC
LIMIT 1;

--------------------------------------------------OUTPUT----------------------------------------------------------

PRODUCT_NAME	PRODUCT_COUNT
ramen	        8


/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

El resultado es correcto, me ha gustado el control de nulos y el hecho mostrar el output de la query. También seguiría añadiendo los use de la database y del schema (aunque sea algo que no es global de SQL).
Destacar que el limit es correcto aunque tambien sería posible utilizar un TOP 1 (en el caso de Snowflake, esto puede variar dependiendo del motor de base de datos utilizado)

SELECT TOP 1
      IFNULL(p.product_name,'NINGÙN PRODUCTO') as product_name
    , COUNT(p.product_name) AS product_count
FROM members m
    LEFT JOIN sales s
        ON m.customer_id = s.customer_id
    LEFT JOIN menu p
        ON s.product_id = p.product_id
GROUP BY product_name
ORDER BY product_count DESC;


Lo único mejorable sería la legibilidad/visibilidad del código, esto es algo mas de gustos personales y hay varias formas de hacer más legible un código. Por mi parte lo formatería de la siguiente forma:

- Comas por delante de las columnas en el select (gusto personal).
SELECT
      IFNULL(p.product_name,'NINGÙN PRODUCTO') as product_name
    , COUNT(p.product_name) AS product_count
FROM members m
    LEFT JOIN sales s
        ON m.customer_id = s.customer_id
    LEFT JOIN menu p
        ON s.product_id = p.product_id
GROUP BY product_name
ORDER BY product_count DESC
LIMIT 1;

- Comas por detrás de las columnas en el select.
SELECT
    IFNULL(p.product_name,'NINGÙN PRODUCTO') as product_name,
    COUNT(p.product_name) AS product_count
FROM members m
    LEFT JOIN sales s
        ON m.customer_id = s.customer_id
    LEFT JOIN menu p
        ON s.product_id = p.product_id
GROUP BY product_name
ORDER BY product_count DESC
LIMIT 1;

Lo que si es común es tabular los JOINs y sus ONs correspondientes

*/
