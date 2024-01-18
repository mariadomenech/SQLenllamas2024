--Dia 3 ¿Cuál es el primer producto que ha pedido cada cliente?
USE SQL_EN_LLAMAS;

SELECT 
        A.CLIENTE
        ,COALESCE(A.PEDIDO,'Sin pedido') AS PEDIDO
        ,COALESCE(CAST(A.FECHA_PEDIDO AS VARCHAR),'Aun no visitado') AS FECHA_PEDIDO
		--Faltaría poder concatenar de alguna manera los 2 primeros productos pedidos por el cliente A en un solo registro
FROM (
    SELECT  
            M.CUSTOMER_ID AS CLIENTE
            ,MU.PRODUCT_ID
            ,S.ORDER_DATE AS FECHA_PEDIDO
            ,MU.PRODUCT_NAME AS PRIMER_PEDIDO
            ,COUNT(PRIMER_PEDIDO) AS CANTIDAD
            ,CONCAT(CANTIDAD,' ',PRIMER_PEDIDO) AS PEDIDO
    FROM CASE01.SALES S
    FULL JOIN CASE01.MEMBERS M
        ON S.CUSTOMER_ID = M.CUSTOMER_ID
    FULL JOIN CASE01.MENU MU
        ON S.PRODUCT_ID = MU.PRODUCT_ID
    GROUP BY 1,2,3,4
    QUALIFY RANK() OVER(PARTITION BY M.CUSTOMER_ID ORDER BY S.ORDER_DATE ASC) = 1
) A
;
