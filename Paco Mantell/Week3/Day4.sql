/* Establecemos BBDD y esquema donde almacenar el procedimiento*/
USE SQL_EN_LLAMAS;
USE SCHEMA CASE03;
CREATE OR REPLACE PROCEDURE customer_purchase_pmz(calculo VARCHAR,cust INTEGER, mes INTEGER)
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
        res := (SELECT txn_type,
            amount 
            FROM( 
            (SELECT customer_id,
                    MONTH(txn_date) tx_mes,
                    txn_type,
                    SUM(txn_amount) amount
                FROM   sql_en_llamas.case03.customer_transactions
                GROUP BY 1,2,3)
        )
        WHERE customer_id = :cust
        AND tx_mes = :mes);
        
        RETURN TABLE(res);
        
    ELSE
        /*Balance por tipo de transaccion*/
        res := (SELECT txn_type,
            amount 
            FROM( 
            (SELECT customer_id,
                    MONTH(txn_date) tx_mes,
                    txn_type,
                    SUM(txn_amount) amount
                FROM   sql_en_llamas.case03.customer_transactions
                GROUP BY 1,2,3)
        )
        WHERE customer_id = :cust
            AND tx_mes = :mes
            AND txn_type = :calculo);
            
        RETURN TABLE(res);
        
    END IF;
  
END;

/*Ejecuciones para cada tipo de opcion*/

/*Balance*/
CALL customer_purchase_pmz('Balance',100,3);

/*Compras*/
CALL customer_purchase_pmz('purchase',100,3);

/*Depositos*/
CALL customer_purchase_pmz('deposit',100,3);

/*Retiros*/
CALL customer_purchase_pmz('withdrawal',100,3);
