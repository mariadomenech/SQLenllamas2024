--Dia 2 ¿Cuantos días ha visitado el restaurante cada cliente?

USE SQL_EN_LLAMAS;

SELECT  
        --IDs
        S.CUSTOMER_ID AS CLIENTE

        --Metricas
        ,COUNT(DISTINCT S.ORDER_DATE) AS TOT_DIAS_VISITA

FROM CASE01.SALES S
GROUP BY 1;