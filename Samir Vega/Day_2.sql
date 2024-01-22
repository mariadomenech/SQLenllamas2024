--------------------------------------------------------------DIA_2----------------------------------------------------------

SELECT
    B.CUSTOMER_ID,
    COUNT(DISTINCT ORDER_DATE) AS DIAS_VISITADOS
FROM SALES A
FULL JOIN MEMBERS B
    ON A.CUSTOMER_ID = B.CUSTOMER_ID
GROUP BY B.CUSTOMER_ID;

/*********************************/
/***** COMENTARIO JUAN PEDRO *****/
/*********************************/
/*
El resultado es correcto y el código también, pero recuerda que siempre es más conveniente usar el LEFT que el FULL.
*/
