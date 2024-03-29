--NO CORREGIR AÚN, QUIERO DARLE UNA VUELTA CUANDO TENGA UN HUECO
--------------------------------------------------------------DIA_1----------------------------------------------------------

WITH AUX AS (
    SELECT
        CASE
            WHEN END_DATE = TO_DATE('9999-12-31', 'YYYY-MM-DD')
                THEN NULL
            WHEN NODE_ID != LEAD(NODE_ID) OVER (ORDER BY CUSTOMER_ID, START_DATE) AND END_DATE != TO_DATE('9999-12-31', 'YYYY-MM-DD')
                THEN DATEDIFF(DAY, START_DATE, END_DATE)
            WHEN NODE_ID = LEAD(NODE_ID) OVER (ORDER BY CUSTOMER_ID, START_DATE) AND LEAD(END_DATE) OVER (ORDER BY CUSTOMER_ID, START_DATE) != TO_DATE('9999-12-31', 'YYYY-MM-DD')
                THEN DATEDIFF(DAY, START_DATE, (LEAD(END_DATE) OVER (ORDER BY CUSTOMER_ID, START_DATE)))
        END AS DIAS_X_NODO
    FROM CUSTOMER_NODES)
SELECT
    ROUND(AVG(DIAS_X_NODO)) AS DIAS_X_NODO_MEDIA
FROM AUX;
