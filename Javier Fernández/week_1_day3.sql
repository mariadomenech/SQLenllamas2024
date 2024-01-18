USE SQL_EN_LLAMAS;
USE SCHEMA CASE01;

SELECT CUSTOMER_ID, ARRAY_AGG(IFNULL(PRODUCT_NAME,'NO FIRST ORDER')) AS FIRST_ORDER
FROM (
    SELECT M.CUSTOMER_ID, MEN.PRODUCT_NAME, MIN(S.ORDER_DATE) AS FIRST_ORDER_DATE
    FROM MEMBERS M
    LEFT JOIN SALES S
        ON M.CUSTOMER_ID = S.CUSTOMER_ID
    LEFT JOIN MENU MEN
        ON S.PRODUCT_ID = MEN.PRODUCT_ID
    GROUP BY M.CUSTOMER_ID, MEN.PRODUCT_NAME
)
GROUP BY CUSTOMER_ID ORDER BY CUSTOMER_ID;

/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/*

Me ha gustado que hagas uso de la función ARRAY_AGG(), mini punto extra por mejorar la visulaización del resultado.

Pero el resultado no es del todo correcto, me estás mostrando todos los menús que han pedido los clientes, para toda la fehas.
Aquí pedíamos el primer producto que ha pedido cada cliente.

Dale una vuelta al MIN(), de nada sirve que lo calcules si luego no haces uso de él a la hora filtrar los datos.

*/
