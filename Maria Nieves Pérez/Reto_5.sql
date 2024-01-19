--He visto dos formas muy parecidas de resolverlo. Esta con CTE---

WITH primero AS (
    SELECT 
        distinct r.customer_id AS Cliente,
        product_name AS producto,
        SUM(PRICE) OVER (PARTITION BY r.customer_id, product_name) AS suma_precio
    FROM SQL_EN_LLAMAS.CASE01.SALES P
        INNER JOIN SQL_EN_LLAMAS.CASE01.MENU Q
            ON P.PRODUCT_ID=Q.PRODUCT_ID
        RIGHT JOIN SQL_EN_LLAMAS.CASE01.MEMBERS R
            ON P.CUSTOMER_ID=R.CUSTOMER_ID
),

segundo AS (
    SELECT 
        Cliente,
        producto,
        DECODE(suma_precio, NULL, 0, suma_precio) AS precio_cliente,
        precio_cliente*10 AS puntos_parciales,
        CASE WHEN producto = 'sushi' THEN puntos_parciales * 2
            ELSE puntos_parciales END AS puntos_totales
    FROM primero
    ORDER BY precio_cliente DESC
),

tercero AS (
    SELECT 
        Cliente AS "Cliente",
        SUM(puntos_totales) AS "Puntos"
    FROM segundo
    GROUP BY Cliente
    ORDER BY Cliente
)

SELECT * FROM tercero


--Y esta forma con subconsultas--

SELECT 
    Cliente AS "Cliente",
    SUM(puntos_totales) AS "Puntos"
FROM (
    SELECT 
        DISTINCT R.CUSTOMER_ID AS Cliente,
        product_name AS producto,
        DECODE(SUM(PRICE) OVER (PARTITION BY Cliente, producto), NULL, 0, SUM(PRICE) OVER (PARTITION BY Cliente, producto)) 
            AS precio_cliente,
        precio_cliente*10 AS puntos_parciales,
        CASE WHEN producto = 'sushi' THEN puntos_parciales * 2
            ELSE puntos_parciales END AS puntos_totales
    FROM SQL_EN_LLAMAS.CASE01.SALES P
        INNER JOIN SQL_EN_LLAMAS.CASE01.MENU Q
            ON P.PRODUCT_ID=Q.PRODUCT_ID
        RIGHT JOIN SQL_EN_LLAMAS.CASE01.MEMBERS R
            ON P.CUSTOMER_ID=R.CUSTOMER_ID
    ORDER BY precio_cliente, cliente DESC
)
GROUP BY Cliente
ORDER BY Cliente;

--A mi, personalmente, me gusta más la de las CTE, es más clara de entender--