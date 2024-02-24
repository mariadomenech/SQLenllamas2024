/* Day 1
    Las tablas no están muy limpias, crea un procedimiento almacenado que, informando el nombre de la tabla, nos devuelva el número de posibles duplicados
*/

USE SQL_EN_LLAMAS;
USE SCHEMA CASE04;

CREATE OR REPLACE PROCEDURE aas_duplicados (nombre_tabla VARCHAR(40))
RETURNS VARCHAR
LANGUAGE SQL
AS
DECLARE
    mensaje VARCHAR(200);
    contador_duplicados INTEGER;
BEGIN

    CASE UPPER(:nombre_tabla)
        WHEN 'SALES' THEN
            SELECT COUNT(*) INTO :contador_duplicados
            FROM
                (SELECT 
                    count($1)
                FROM  SALES
                GROUP BY $1,$2,$3,$4,$5,$6,$7
                HAVING count($1) > 1);
        WHEN 'PRODUCT_DETAILS' THEN
            SELECT COUNT(*) INTO :contador_duplicados
            FROM
                (SELECT 
                    count($1)
                FROM  SALES
                GROUP BY $1,$2,$3,$4,$5,$6,$7,$8,$9
                HAVING count($1) > 1);
        WHEN 'PRODUCT_HIERARCHY' THEN
            SELECT COUNT(*) INTO :contador_duplicados
            FROM
                (SELECT 
                    count($1)
                FROM  SALES
                GROUP BY $1,$2,$3,$4
                HAVING count($1) > 1);

        WHEN 'PRODUCT_PRICES' THEN
            SELECT COUNT(*) INTO :contador_duplicados
            FROM
                (SELECT 
                    count($1)
                FROM  SALES
                GROUP BY $1,$2,$3
                HAVING count($1) > 1);
        
        ELSE
            RETURN nombre_tabla || ' no existe.';

    END CASE;
    
    mensaje := 'La tabla ' || nombre_tabla || ' tiene ' || contador_duplicados || ' duplicados.';
    
    RETURN mensaje;

END;

CALL aas_duplicados ('product_prices'); -- Ejemplo

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

El resultado para la tabla SALES es correcto pero para el resto no, ya que usas siempre en el código la tabla SALES, en lugar de parametrizar el from con la tabla introducida en la llamada del procedimiento. 
Yo lo que haría seria crear una consulta que tenga la tabla del from parametrizada, y con un rank() identificar los duplicados para contarlos posteriormente.

*/
