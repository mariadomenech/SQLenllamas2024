/*SEMANA 3 - DÍA 2*/
/*PARA CADA MES, ¿CUÁNTOS CLIENTES REALIZAN MÁS DE 1 DEPÓSITO Y 1 COMPRA Ó 1 RETIRO EN UN SOLO MES?*/

CREATE OR REPLACE TEMP TABLE COUNT_TRANS_TYPE
AS
SELECT CUSTOMER_ID AS CLIENTE,
   SUBSTR(TXN_DATE,6,2) AS MES,
    TXN_TYPE AS TIPO,
    COUNT(TXN_TYPE) AS NUM_TRANS,
    COUNT(CASE WHEN TIPO = 'purchase' THEN 1 END) AS NUM_COMPRAS, 
    COUNT(CASE WHEN TIPO = 'withdrawal' THEN 1 END) AS NUM_RETIROS,
    COUNT(CASE WHEN TIPO = 'deposit' THEN 1 END) AS NUM_DEPOSITOS
FROM CUSTOMER_TRANSACTIONS
GROUP BY CLIENTE, MES, TIPO;

SELECT MES,
    COUNT(CLIENTE) AS NUM_CLIENTES
FROM COUNT_TRANS_TYPE
WHERE (NUM_COMPRAS > 1 AND NUM_DEPOSITOS >1) OR NUM_RETIROS > 1
GROUP BY MES
ORDER BY MES ASC


/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/* 

Caaaaaaaasi Fran. Pero solo estás contando cuando NUM_RETIROS > 1, porque NUM_COMPRAS > 1 AND NUM_DEPOSITOS >1 nunca se va a dar.
Estas diciendo que para un cliente X en febrero, el registro que es TIPO = 'purchase'  sea también TIPO = 'deposit'. Nunca se va a dar.

Tu fallo está en que al crear la tabla temporal agrupas por TXT_TYPE, por tipo de transacción.Si quitas esa columna, te da el resultado corrrecto.

*/
