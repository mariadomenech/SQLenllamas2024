--Dia 2 ¿Cuantos días ha visitado el restaurante cada cliente?

USE SQL_EN_LLAMAS;

SELECT  
        --IDs
        M.CUSTOMER_ID AS CLIENTE

        --Metricas
        ,COUNT(DISTINCT S.ORDER_DATE) AS TOT_DIAS_VISITA

FROM CASE01.SALES S
FULL JOIN CASE01.MEMBERS M
    ON S.CUSTOMER_ID = M.CUSTOMER_ID
GROUP BY 1;

/*********************************/
/***** COMENTARIO JUAN PEDRO *****/
/*********************************/
/*
Es correcto tanto el resutlado como el código, pero recuerda que es más conveniente no usar el FULL y usar un LEFT o RIGHT.
*/
