/* Funcion para el calculo del balance total, la cual puedo reutilizar para los totales por tipo de transaccion*/
CREATE OR REPLACE FUNCTION balance_pmz(cust INTEGER, mes INTEGER)
RETURNS TABLE(type VARCHAR, amount NUMBER)
AS
$$
    SELECT txn_type,
        amount 
    FROM( 
        SELECT customer_id,
                MONTH(txn_date) tx_mes,
                txn_type,
                SUM(txn_amount) amount
            FROM   sql_en_llamas.case03.customer_transactions
            GROUP BY 1,2,3)
    WHERE customer_id = cust
    AND tx_mes = mes);
$$
;

/* Procedimiento Almacenado*/
CREATE OR REPLACE PROCEDURE day5_pmz(calculo VARCHAR,cust INTEGER, mes INTEGER)
RETURNS TABLE(type VARCHAR, amount NUMBER)
LANGUAGE SQL
EXECUTE AS CALLER
AS
DECLARE
    res RESULTSET;
BEGIN
    /*En funcion de la opcion muestro un calculo u otro*/
    IF (:calculo = 'Balance') THEN
        /*Balance total*/
        res := (SELECT * FROM TABLE(BALANCE_PMZ(:cust, :mes)));
        
        RETURN TABLE(res);
        
    ELSE
        /*Balance por tipo de transaccion*/
        res := (SELECT *
                FROM TABLE(BALANCE_PMZ(:cust, :mes))
                WHERE type=:calculo);
            
        RETURN TABLE(res);
        
    END IF;
  
END;

/*Ejecuciones para cada tipo de opcion*/

/*Balance*/
CALL day5_pmz('Balance',100,3);

/*Compras*/
CALL day5_pmz('purchase',100,3);

/*Depositos*/
CALL day5_pmz('deposit',100,3);

/*Retiros*/
CALL day5_pmz('withdrawal',100,3);

/*COMENTARIOS JUANPE: TODO CORRECTO*/
