/*SEMANA 4 - DÍA 4*/

CREATE OR REPLACE DATABASE SQL_EN_LLAMAS_FNM CLONE SQL_EN_LLAMAS;

CREATE SCHEMA SQL_EN_LLAMAS_FNM.CASE04 CLONE SQL_EN_LLAMAS.CASE04;

CREATE OR REPLACE TEMP TABLE CLEAN_SALES_TABLE
AS
SELECT *
FROM SALES
GROUP BY PROD_ID,
    QTY,
    PRICE,
    DISCOUNT,
    MEMBER,
    TXN_ID,
    START_TXN_TIME;

CREATE OR REPLACE TEMP TABLE PERC_TABLE
AS
SELECT PROD_ID,
    TXN_ID,
    SUM(PRICE*QTY*(1-DISCOUNT/100)) AS TOTAL
FROM CLEAN_SALES_TABLE
GROUP BY 1,2;

/*FINALMENTE TRAS CREAR LAS TABLAS TEMPORALES NECESARIAS, HAGO EL SELECT DE LO QUE NECESITO CON LOS PERCENTILES*/

SELECT TXN_ID,
    PERCENTILE_CONT(0.25)WITHIN GROUP (ORDER BY TOTAL) AS PERC_25,
    PERCENTILE_CONT(0.50)WITHIN GROUP (ORDER BY TOTAL) AS PERC_50,
    PERCENTILE_CONT(0.75)WITHIN GROUP (ORDER BY TOTAL) AS PERC_75
FROM PERC_TABLE
GROUP BY TXN_ID;

/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/* 

Muy bien Fran, ten cuidado con la fórmula del TOTAL debe ser. SUM(PRICE*QTY*((100-DISCOUNT)/100)) AS TOTAL
Los descuentos no está en puntos porcentuales sino sobre 100, entonces es 100-DISCOUNT, no 1-DISCOUNT.

Como el total debe ser por transacción, porque el enunciado pide los percentiles por transacción. Quitamos de PERC_TABLE la columna PROD_ID.


*/
