/* Las tablas no están muy limpias, crea un procedimiento almacenado
que informando el nombre de la tabla, nos devuelva el número de posibles duplicados.*/

CREATE OR REPLACE PROCEDURE SQL_EN_LLAMAS.CASE04.BEA_EXPOSITO_DUPLICATES (table_name VARCHAR)
RETURNS VARCHAR
LANGUAGE SQL
AS 
DECLARE
        NUM_DUPLICATES NUMBER;
BEGIN
    CASE 
        WHEN UPPER(TRIM(table_name)) = 'SALES' THEN
             SELECT COUNT(*) INTO NUM_DUPLICATES
            FROM (
                    SELECT PROD_ID, QTY, PRICE,DISCOUNT,MEMBER,TXN_ID,START_TXN_TIME
                    FROM CASE04.SALES
                    GROUP BY PROD_ID, QTY, PRICE,DISCOUNT,MEMBER,TXN_ID,START_TXN_TIME
                    HAVING COUNT(*) > 1
                    );
        WHEN UPPER(TRIM(table_name)) = 'PRODUCT_DETAILS' THEN
             SELECT COUNT(*) INTO NUM_DUPLICATES
              FROM (
                    SELECT PRODUCT_ID, PRICE, PRODUCT_NAME, CATEGORY_ID, SEGMENT_ID, STYLE_ID, CATEGORY_NAME, SEGMENT_NAME, STYLE_NAME
                    FROM CASE04.PRODUCT_DETAILS
                    GROUP BY PRODUCT_ID, PRICE, PRODUCT_NAME, CATEGORY_ID, SEGMENT_ID, STYLE_ID, CATEGORY_NAME, SEGMENT_NAME, STYLE_NAME
                    HAVING COUNT(*) > 1
                    );
        ELSE  NUM_DUPLICATES := -1;
    END CASE;

    CASE 
        WHEN NUM_DUPLICATES = -1 THEN RETURN 'Inserte nombre de tabla correcto (SALES, PRODUCT_DETAILS).';
        ELSE RETURN 'La tabla ' || INITCAP(table_name) || ' tiene un total de ' || NUM_DUPLICATES || ' duplicados.';
    END CASE;
END;

CALL SQL_EN_LLAMAS.CASE04.BEA_EXPOSITO_DUPLICATES('SALES');

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

El resultado es correcto.

*/
