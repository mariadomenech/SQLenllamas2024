/* Crea un procedimiento almacenado que al introducir el identificador del cliente y el mes, calcule el total de compras (purchase)
y que te devuelva el siguiente mensaje :El cliente 1 se ha gastado un total de 1.276 euros en compras de productos en el mes de marzo*/

CREATE OR REPLACE TEMPORARY TABLE ESPECIALIDAD_SQL_BRONZE_DB_BEA.RETO.MONTHS AS
    SELECT DISTINCT
        MONTH(txn_date) as month_num                                               
        ,DECODE(MONTH(txn_date),
        1,'ENERO',
        2,'FEBRERO',
        3,'MARZO',
        4,'ABRIL',
        5,'MAYO',
        6,'JUNIO',
        7,'JULIO',
        8,'AGOSTO',
        9,'SEPTIEMBRE',
        10,'OCTUBRE',
        11,'NOVIEMBRE',
        12,'DICIEMBRE') as month_name_sp
    FROM case03.customer_transactions
    ORDER BY 1;



CREATE OR REPLACE PROCEDURE SQL_EN_LLAMAS.CASE03.BEA_EXPOSITO_TOTAL_PURCHASE (customer_ident NUMBER, month_name VARCHAR)
RETURNS VARCHAR
LANGUAGE SQL
AS 
DECLARE 
    amount VARCHAR;
BEGIN 
    SELECT COALESCE(SUM(txn_amount),0) INTO amount
    FROM (
            SELECT customer_id 
                   ,MONTH (txn_date ) AS month_num
                   ,INITCAP(B.month_name_sp) AS month_name_sp
                   ,txn_amount
            FROM case03.customer_transactions A
    LEFT JOIN ESPECIALIDAD_SQL_BRONZE_DB_BEA.RETO.MONTHS B
        ON MONTH (A.txn_date )  = B.month_num
    WHERE A.txn_type = 'purchase' 
        AND A.customer_id = :customer_ident
        AND B.month_name_sp = UPPER(:month_name)
         );
 RETURN 'El cliente ' || :customer_ident || ' se ha gastado un total de ' || :amount ||' eur en compras de productos en el mes de ' || INITCAP(:month_name) || '.';

END;

CALL SQL_EN_LLAMAS.CASE03.BEA_EXPOSITO_TOTAL_PURCHASE (1, 'marzo');

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

El resultado es correcto. 

*/
