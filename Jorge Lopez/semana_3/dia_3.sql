/*Día 3 Crear un procedimiento almacenado al que le introduzcas cliente y mes y te devuelva el total de compras que ha realizado 

He creado tres procedimientos, simples y fáciles, pero útiles para controlar todas las opciones.

Con el método busca_cliente controlo que no se introduzcan números de usuario inexistentes. 
El segundo método hace una conversión del resultado de un método propio para obtener el nombre del mes que se introduzca,
el problema de este método es que te devuelve el nombre abreviado y en ingés, mi método hace la traducción al castellano.

El último método realiza lo que se pide en este día, además de controlar todo lo anterior. He dejado tres ejemplos para 
que se compruebe la salida que da.

*/

CREATE OR REPLACE PROCEDURE jorgelopez_busca_cliente(cliente INTEGER)
    RETURNS INTEGER
    LANGUAGE SQL
AS
DECLARE 
    cliente_check INTEGER;
BEGIN
    SELECT
        DISTINCT C.CUSTOMER_ID INTO :cliente_check
    FROM 
        CASE03.CUSTOMER_TRANSACTIONS AS C
    WHERE 
        C.CUSTOMER_ID = :cliente;

    CASE 
        WHEN cliente_check IS NULL THEN cliente_check := -1;
    END CASE;
    RETURN cliente_check;
END;

CREATE OR REPLACE PROCEDURE jorgelopez_meses(mes INTEGER)
    RETURNS STRING
    LANGUAGE SQL
AS
DECLARE 
    nombre_mes STRING;
BEGIN
    nombre_mes := MONTHNAME(to_date('2020-' || mes || '-01'));
    CASE 
        WHEN nombre_mes = 'Jan' THEN nombre_mes := 'enero';
        WHEN nombre_mes = 'Feb' THEN nombre_mes := 'febrero';
        WHEN nombre_mes = 'Mar' THEN nombre_mes := 'marzo';
        WHEN nombre_mes = 'Apr' THEN nombre_mes := 'abril';
        WHEN nombre_mes = 'May' THEN nombre_mes := 'mayo';
        WHEN nombre_mes = 'Jun' THEN nombre_mes := 'junio';
        WHEN nombre_mes = 'Jul' THEN nombre_mes := 'julio';
        WHEN nombre_mes = 'Aug' THEN nombre_mes := 'agosto';
        WHEN nombre_mes = 'Sep' THEN nombre_mes := 'septiembre';
        WHEN nombre_mes = 'Oct' THEN nombre_mes := 'octubre';
        WHEN nombre_mes = 'Nov' THEN nombre_mes := 'noviembre';
        WHEN nombre_mes = 'Dec' THEN nombre_mes := 'diciembre';
        ELSE nombre_mes := CAST(mes AS STRING); 
    END CASE;
    RETURN nombre_mes;
END;

CREATE OR REPLACE PROCEDURE jorgelopez_cliente_compras(cliente INTEGER, mes INTEGER)
    RETURNS STRING
    LANGUAGE SQL
AS
DECLARE 
    primer_dia DATE;
    ultimo_dia DATE;
    total INTEGER;
    cliente_check INTEGER;
    resultado STRING;
    nombre_mes STRING;
BEGIN
    CALL jorgelopez_busca_cliente(:cliente) INTO cliente_check;
    CASE 
        WHEN mes < 1 OR mes > 12 THEN resultado := 'Número de mes incorrecto.';
        WHEN cliente_check = -1 THEN resultado := 'Número de cliente desconocido.';
        ELSE
            primer_dia := DATEADD(MONTH, mes - 1, '2020-01-01');
            ultimo_dia := LAST_DAY(DATEADD(MONTH, mes - 1, '2020-01-01'));
            CALL jorgelopez_meses(:mes) INTO nombre_mes;
            
            SELECT 
                SUM(C.TXN_AMOUNT) INTO :total
            FROM 
                CASE03.CUSTOMER_TRANSACTIONS AS C
            WHERE 
                C.CUSTOMER_ID = :cliente AND
                C.TXN_TYPE = 'Purchase' AND
                C.TXN_DATE BETWEEN :primer_dia AND :ultimo_dia;
                                
            CASE 
                WHEN total IS NULL THEN resultado := 'El cliente '|| cliente || ' no ha realizado compras durante el mes de ' || nombre_mes ||'.';
            ELSE
                 resultado := 'El cliente ' || cliente || ' se ha gastado un total de ' || total || ' EUR en compras de productos en el mes de ' || nombre_mes || '.';
            END CASE;
    END CASE;
    RETURN resultado;
END;

CALL jorgelopez_cliente_compras(429,8); -- Cliente sin compras para ese mes.
CALL jorgelopez_cliente_compras(429,1); -- Cliente con compras para ese mes.
CALL jorgelopez_cliente_compras(422342349,8); -- Número de cliente erróneo.
CALL jorgelopez_cliente_compras(429,15); -- Número de mes erróneo.


/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/* 

Me ha gustado mucho que lo hayas hecho dinámico!! Perfecto, solo un detalle de nada, TXN_TYPE = 'Purchase' nunca te va a devolver nada, porque el campo
viene como 'purchase', en minúscula. Puedes jugar con la función UPPER o LOWER para que no te la líen las mayúsculas y minúsculas.

*/
