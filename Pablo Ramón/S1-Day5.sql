--Dia 5
--Si cada euro gastado equivale a 10 puntos y el sushi tiene un mulitplicador de x2
--¿Cuantos puntos tiene cada cliente?
USE SQL_EN_LLAMAS;


SELECT 
        A.CUSTOMER_ID AS CLIENTE_ID,
        IFNULL(SUM(A.PUNTOS),0) AS TOTAL_PUNTOS
FROM (
    SELECT 
            M.CUSTOMER_ID, 
            CASE WHEN Me.PRODUCT_ID != 1 THEN (Me.PRICE*10)
            ELSE (Me.PRICE*20)
            END AS PUNTOS
    FROM CASE01.MEMBERS M
    FULL JOIN CASE01.SALES S
        ON M.CUSTOMER_ID = S.CUSTOMER_ID
    LEFT JOIN CASE01.MENU Me
        ON Me.PRODUCT_ID = S.PRODUCT_ID
) A
GROUP BY 1;

/*********************************/
/***** COMENTARIO JUAN PEDRO *****/
/*********************************/
/*
¡Todo correcto enhorabuena! Pero el full no es recomendable usarlo (aunque si correcto) era mejor un LEFT. 
Aprovecho para comentarte el uso de las tablas temporales por medio del with. A veces es útil usarlas cuando se hacen subconsultas no son necesarias 
pero échales un ojo.
*/

/*********************************/
/*****   COMENTARIO PABLO    *****/
/*********************************/
Gracias! Lo tendré en cuenta para los futuros ejericios, por costumbre con el cliente que siempre pide FULL ya lo uso por defecto.
