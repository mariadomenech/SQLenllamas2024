/* Día 1: Crear un procedimiento que informando el nombre de la tabla nos devuelve el número de duplicados. */

USE SQL_EN_LLAMAS;
USE SCHEMA CASE04;

CREATE OR REPLACE PROCEDURE jorgelopez_duplicados_tabla(tabla VARCHAR)
    RETURNS STRING
    LANGUAGE SQL
AS
DECLARE 
    total INTEGER;
    resultado VARCHAR(250);
BEGIN
    CASE 
        WHEN UPPER(tabla) = 'SALES' THEN
            SELECT COUNT(*) INTO :total 
            FROM (
                SELECT 
                    PROD_ID,
                    QTY, 
                    PRICE, 
                    DISCOUNT, 
                    MEMBER, 
                    TXN_ID, 
                    START_TXN_TIME
                FROM CASE04.SALES
                GROUP BY 
                    PROD_ID,
                    QTY, 
                    PRICE, 
                    DISCOUNT, 
                    MEMBER, 
                    TXN_ID, 
                    START_TXN_TIME
                HAVING COUNT(*) > 1
            );
        WHEN UPPER(tabla) = 'PRODUCT_DETAILS' THEN
            SELECT COUNT(*) INTO :total 
            FROM (
                SELECT 
                    PRODUCT_ID, 
                    PRICE, 
                    PRODUCT_NAME, 
                    CATEGORY_ID, 
                    SEGMENT_ID, 
                    STYLE_ID, 
                    CATEGORY_NAME,
                    SEGMENT_NAME, 
                    STYLE_NAME
                FROM CASE04.PRODUCT_DETAILS
                GROUP BY 
                    PRODUCT_ID, 
                    PRICE, 
                    PRODUCT_NAME, 
                    CATEGORY_ID, 
                    SEGMENT_ID, 
                    STYLE_ID, 
                    CATEGORY_NAME,
                    SEGMENT_NAME, 
                    STYLE_NAME
                HAVING COUNT(*) > 1
            );
        ELSE 
            total := -1;
    END CASE;
    CASE 
        WHEN total = -1 THEN
         resultado := 'Nombre de tabla incorrecto.';
        ELSE
         resultado := 'El número de registros duplicados es ' || total || '.';
    END CASE;
RETURN resultado;
END;

CALL jorgelopez_duplicados_tabla('SALES');
CALL jorgelopez_duplicados_tabla('PRODUCT_DETAILS');
CALL jorgelopez_duplicados_tabla('ASD');
