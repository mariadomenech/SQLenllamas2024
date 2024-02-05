
--DAY 1-- 
/*crea un procedimiento almacenado
que informando el nombre de la tabla, nos devuelva el número de posibles duplicados.*/

CREATE OR REPLACE PROCEDURE SQL_EN_LLAMAS.CASE04.MRA_CALCULO_DUPLICADOS(tabla STRING)
RETURNS VARCHAR
LANGUAGE SQL
EXECUTE AS OWNER
AS 
DECLARE

    existe_tabla INT;
    reg_duplicados INT;
    columnas_tabla STRING;
    query STRING;

BEGIN

    existe_tabla :=  (SELECT 
                           COUNT(*)
                      FROM INFORMATION_SCHEMA.TABLES
                      WHERE TABLE_CATALOG='SQL_EN_LLAMAS'
                      AND TABLE_SCHEMA='CASE04'
                      AND TABLE_NAME = UPPER(:tabla));
    

    IF (existe_tabla = 0) THEN
        RETURN 'LA TABLA ' || tabla || ' NO EXISTE.';
    END IF;
    
    columnas_tabla := (SELECT 
                            LISTAGG(COLUMN_NAME, ', ')
                      FROM INFORMATION_SCHEMA.COLUMNS
                      WHERE TABLE_CATALOG='SQL_EN_LLAMAS'
                      AND TABLE_SCHEMA='CASE04'
                      AND table_name = UPPER(TRIM(:tabla)));

    USE SCHEMA SQL_EN_LLAMAS.CASE04;

    query := '
                SELECT 
                    '||columnas_tabla||'
                    ,COUNT(*) AS CONTEO
                FROM '||tabla||'
                GROUP BY '||columnas_tabla||'
                HAVING COUNT(*) > 1';

    EXECUTE IMMEDIATE query;

    reg_duplicados := (SELECT COUNT(*) FROM TABLE(RESULT_SCAN(LAST_QUERY_ID())));
    
    IF (:reg_duplicados > 0) 
        THEN RETURN 'LA TABLA ' || :tabla || ' TIENE ' || :reg_duplicados || ' REGISTROS DUPLICADOS.';
    ELSE
        RETURN 'LA TABLA ' || :tabla || ' NO TIENE REGISTROS DUPLICADOS.';
    END IF;

END;

--LLAMADAS--
CALL SQL_EN_LLAMAS.CASE04.MRA_CALCULO_DUPLICADOS('PRODUCT_DETAILS');
CALL SQL_EN_LLAMAS.CASE04.MRA_CALCULO_DUPLICADOS('SALES');
CALL SQL_EN_LLAMAS.CASE04.MRA_CALCULO_DUPLICADOS('QWEQ');
