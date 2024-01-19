/* JOSEP QUIERE REPARTIR TARJETAS DE FIDELIZACION A SUS CLIENTES.
SI CADA EURO GASTADO EQUIVALE A 10 PUNTOS Y EL SUSHI TIENE UN MULTIPLICADOR DE X2 PUNTOS,
  ¿CUÁNTOS PUNTOS TENDRÍA CADA CLIENTE?*/
SELECT
     A.CLIENTE
    ,SUM(A.GASTO_RECALCULADO*10) AS PUNTOS_TOTALES
FROM (
        SELECT 
             MEMBERS.CUSTOMER_ID AS CLIENTE
            ,SALES.PRODUCT_ID
            ,IFNULL(SUM(MENU.PRICE),0) AS TOTAL_GASTADO
            ,CASE WHEN SALES.PRODUCT_ID = 1 THEN TOTAL_GASTADO*2
                  ELSE TOTAL_GASTADO
                  END AS GASTO_RECALCULADO
        FROM CASE01.SALES
        LEFT JOIN CASE01.MENU
               ON SALES.PRODUCT_ID = MENU.PRODUCT_ID
        RIGHT JOIN CASE01.MEMBERS 
            ON SALES.CUSTOMER_ID = MEMBERS.CUSTOMER_ID
        GROUP BY 1,2
        ORDER BY 1)A
GROUP BY 1;
