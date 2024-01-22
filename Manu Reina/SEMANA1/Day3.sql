-- ¿Cuál es el primer producto que ha pedido cada cliente? -- 
SELECT 
     A.CLIENTE
    ,LISTAGG(DISTINCT A.PRODUCTO, ', ') AS LISTA_PRODUCTOS
    ,PRIMER_PEDIDO
FROM(
    SELECT 
         MEMBERS.CUSTOMER_ID AS CLIENTE
        ,MENU.PRODUCT_NAME AS PRODUCTO
        ,SALES.ORDER_DATE AS PRIMER_PEDIDO
    FROM CASE01.SALES
    RIGHT JOIN CASE01.MEMBERS
           ON SALES.CUSTOMER_ID = MEMBERS.CUSTOMER_ID
    INNER JOIN CASE01.MENU
           ON SALES.PRODUCT_ID = MENU.PRODUCT_ID
    WHERE (SALES.ORDER_DATE) IN (SELECT MIN(ORDER_DATE)
                                   FROM CASE01.SALES)
    GROUP BY MEMBERS.CUSTOMER_ID, MENU.PRODUCT_NAME,SALES.ORDER_DATE)A
GROUP BY A.CLIENTE, A.PRIMER_PEDIDO
ORDER BY A.CLIENTE;

/*********************************/
/***** COMENTARIO JUAN PEDRO *****/
/*********************************/
/*
¡Todo correcto pero casi perfecto! has perdido la información en el cliente C de que pidios dos productos en su primer pedido, podrias o no haber usado el distinct
para que te saliera dos veces el ramen o bien habertelas ideado para obtener un resultado talque así: C: "2 ramen", A: "1 sushi, 1 curry".
Además siempre interesa sacar a todos incluido al que no pidió pero esta en la tabla de MEMBERS.
*/
