SELECT A.CUSTOMER_ID, LISTAGG(DISTINCT PRODUCT_NAME,',')
FROM(
SELECT M.CUSTOMER_ID AS CUSTOMER_ID, MIN(ORDER_DATE) AS ORDER_DATE-- OVER (PARTITION BY M.CUSTOMER_ID)
FROM MEMBERS M
FULL JOIN SALES S
ON M.customer_id= S.customer_id
GROUP BY 1
) A
JOIN SALES S
ON A.CUSTOMER_ID = S.CUSTOMER_ID
JOIN MENU M
ON M.PRODUCT_ID =S.PRODUCT_ID
WHERE S.ORDER_DATE = A.ORDER_DATE
GROUP BY 1;

/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/* 

Oye, muy guay que conozcas la función LISTAGG, si le das un alias... PERFECTO!!

Mismo comentario sobre los FULL JOIN y tabulaciones.

*/
