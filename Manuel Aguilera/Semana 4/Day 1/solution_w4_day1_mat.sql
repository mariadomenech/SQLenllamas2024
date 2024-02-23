CREATE OR REPLACE PROCEDURE SQL_EN_LLAMAS.CASE04.PROCEDIMIENTO_DAY1_WEEK4_MAT(nombre_tabla STRING)
RETURNS VARCHAR
LANGUAGE SQL
AS
DECLARE
    DUPLICADOS INT;
    LISTA_COLUMNAS STRING;
    SQL_DINAMICA STRING;

BEGIN

LISTA_COLUMNAS  := (SELECT LISTAGG(column_name, ', ') WITHIN GROUP (ORDER BY ordinal_position)
            FROM INFORMATION_SCHEMA.COLUMNS 
            WHERE TABLE_CATALOG='SQL_EN_LLAMAS'
            AND TABLE_SCHEMA='CASE04'
            AND table_name = upper(:nombre_tabla));

IF (LISTA_COLUMNAS ='') THEN
    RETURN 'Por favor introduzca una tabla válida: PRODUCT_DETAILS, SALES, PRODUCT_HIERARCHY, PRODUCT_PRICES';
END IF; 

SQL_DINAMICA := 'SELECT COUNT(*) FROM SQL_EN_LLAMAS.CASE04.' || nombre_tabla ||
                 ' GROUP BY ' || LISTA_COLUMNAS||
                 ' HAVING COUNT(*) > 1';

EXECUTE IMMEDIATE SQL_DINAMICA;
                 
DUPLICADOS := ((SELECT count(*) FROM TABLE(RESULT_SCAN(LAST_QUERY_ID())))>0);

IF (DUPLICADOS > 0) THEN
    RETURN 'La tabla ' || :nombre_tabla || ' tiene duplicados.';
  ELSE
    RETURN 'La tabla ' || :nombre_tabla || ' no tiene duplicados.';
  END IF;
  
END;

--Llamada procedimiento
CALL SQL_EN_LLAMAS.CASE04.PROCEDIMIENTO_DAY1_WEEK4_MAT('PRODUCT_DETAILS');


/*
COMENTARIOS JUANPE:
Aunque correcto el código y la creación del procedimiento, tu procedimiento solo nos dice que tiene duplicados pero no nos dice cuantos.
*/
