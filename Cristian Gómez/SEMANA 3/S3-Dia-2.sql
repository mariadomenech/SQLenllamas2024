SELECT
    AUX.Y_MES AS FECHA_MES
    , COUNT(AUX.CLIENTE) AS NUMERO_CLIENTES
FROM ( 
    SELECT
        DATE_PART(YEAR, TXN_DATE) || '-' || LPAD(DATE_PART(MONTH, TXN_DATE), 2, '0') AS Y_MES -- saco año y mes de la fecha y los junto (lpad añade un 0 si tiene 1 digito el mes)
        , CUSTOMER_ID AS CLIENTE
        , COUNT(CASE WHEN TXN_TYPE = 'purchase' THEN 1 END) AS CONTEO_COMPRAS 
        , COUNT(CASE WHEN TXN_TYPE = 'withdrawal' THEN 1 END) AS CONTEO_RETIROS
        , COUNT(CASE WHEN TXN_TYPE = 'deposit' THEN 1 END) AS CONTEO_DEPOSITOS
    FROM CUSTOMER_TRANSACTIONS
    GROUP BY 1, 2 
) AS AUX
WHERE (AUX.CONTEO_COMPRAS > 1 AND AUX.CONTEO_RETIROS >1) OR AUX.CONTEO_RETIROS > 1
GROUP BY 1 
ORDER BY 1 ASC

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

El resultado no es correcto. 

En lugar de hacer el calculo sobre los clientes que quedan al filtrar, haría el cálculo sobre los conteadores creados (sin filtrarlos):

    SUM(CASE 
			WHEN (
                CONTEO_DEPOSITOS > 1
                AND CONTEO_COMPRAS > 1
                )
            OR CONTEO_RETIROS > 1
            THEN 1
        ELSE 0
        END) NUM_CLIENTES

*/
