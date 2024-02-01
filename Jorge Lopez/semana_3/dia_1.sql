/* Día 1: ¿En cuaántos días de media se reasignan los clientes a un nodo diferente? 

Nota: He comprobado sin restar uno al resultado que cuenta el dia de inicio para realizar el cálculo, con lo que sale un día de más */

SELECT     
    CUSTOMER_ID,
    TO_CHAR(START_DATE, 'DD-MM-YYYY') AS START_DATE,
    TO_CHAR(END_DATE, 'DD-MM-YYYY') AS END_DATE,
    LEAD(START_DATE) OVER (PARTITION BY CUSTOMER_ID ORDER BY END_DATE) - START_DATE - 1 AS DIFF_DIAS
FROM CASE03.CUSTOMER_NODES
ORDER BY CUSTOMER_ID, DIFF_DIAS ASC; 
