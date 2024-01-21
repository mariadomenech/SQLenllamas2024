SELECT 
    C.CUSTOMER_ID AS CLIENTE,
    COUNT(DISTINCT ORDER_DATE) AS DIAS_VISITADOS
FROM SALES S
FULL JOIN MEMBERS C
       ON S.CUSTOMER_ID = C.CUSTOMER_ID       
GROUP BY C.CUSTOMER_ID

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

El resultado es correcto pero el uso FULL JOIN es algo que se debe evitar ya que, en casos de tablas con miles o millones de registros, el rendimineto se ve afectado drasticamente.
Por ello, utilizaría LEFT o RIGHT JOIN

SELECT 
    C.CUSTOMER_ID AS CLIENTE,
    COUNT(DISTINCT ORDER_DATE) AS DIAS_VISITADOS
FROM SALES S
RIGHT JOIN MEMBERS C
       ON S.CUSTOMER_ID = C.CUSTOMER_ID       
GROUP BY C.CUSTOMER_ID;

*/
