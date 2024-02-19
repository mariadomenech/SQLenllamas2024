--------------------------------------------------------------DIA_2----------------------------------------------------------

CREATE OR REPLACE TEMP TABLE TXN_PIVOT AS
    SELECT
        *
    FROM CUSTOMER_TRANSACTIONS
        PIVOT (COUNT(TXN_TYPE)
                 FOR TXN_TYPE IN ('deposit','purchase','withdrawal'))
                    AS A (CUSTOMER_ID, TXN_DATE, TXN_AMOUNT, DEPOSIT, PURCHASE, WITHDRAWAL);

WITH AUX AS (
    SELECT
        CUSTOMER_ID,
        MONTHNAME(TXN_DATE) AS MES
    FROM TXN_PIVOT 
    GROUP BY CUSTOMER_ID, MES
    HAVING (SUM(DEPOSIT)>1 AND SUM(PURCHASE)>1) OR SUM(WITHDRAWAL)>1)
SELECT
    MES,
    COUNT(CUSTOMER_ID)
FROM AUX
GROUP BY MES;

/*COMENTARIOS JUANPE

RESULTADO: CORRECTO

CÓDIGO: CORRECTO. Y muy bien el uso del pivot.

LEGIBILIDAD: CORRECTA

EXTRA: Me ha gustado el uso del pivot para resolver el ejercicio
*/
