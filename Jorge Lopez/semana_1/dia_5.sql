//Día 5: Si cada euro gastado equivale a 10 punto y el sushi a 20 ¿Cuántos puntos tiene cada cliente?
//Para ser totalmente honesto, me he ayudado de la correción de María del ejercicio del dia 1
SELECT 
    A.CUSTOMER_ID AS CLIENTES, 
    SUM(CASE 
            WHEN S.CUSTOMER_ID IS NULL THEN 0
            WHEN S.PRODUCT_ID = 1 THEN M.PRICE * 20
            ELSE M.PRICE * 10
        END) AS TOTAL_PUNTOS
FROM 
    CASE01.MEMBERS A
LEFT JOIN 
    CASE01.SALES S ON A.CUSTOMER_ID = S.CUSTOMER_ID
LEFT JOIN 
    CASE01.MENU M ON S.PRODUCT_ID = M.PRODUCT_ID
GROUP BY 
    CLIENTES;
