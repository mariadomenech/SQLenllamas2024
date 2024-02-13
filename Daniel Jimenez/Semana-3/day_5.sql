
/*Guarda el cálculo del balance, total depositado, total de compras y total de retiros en distintas funciones y aplícalas en el procedimiento de ayer. Recordatorio: El procedimiento debe dejarnos elegir la operación, el mes y el cliente.*/


CREATE OR REPLACE FUNCTION total_balance_djr (customer INT , mes INT)
RETURNS TABLE (
    tipo_transaccion VARCHAR
,   total NUMBER)
AS
$$
    SELECT  TIPO_TRANSACCION
        ,   TOTAL
    FROM (
        SELECT  CUSTOMER_ID
            ,   MONTH (TXN_DATE) AS TXN_MES
            ,   SUM(TXN_AMOUNT) AS TOTAL
            ,   TXN_TYPE AS TIPO_TRANSACCION
        FROM SQL_EN_LLAMAS.CASE03.CUSTOMER_TRANSACTIONS
        GROUP BY 1,2,4)
    WHERE CUSTOMER_ID = customer
    AND TXN_MES = mes);
$$;


CREATE OR REPLACE PROCEDURE calculos_daniel_jimenez(operacion VARCHAR, customer INT , mes INT)
RETURNS TABLE (
    tipo_transaccion VARCHAR
,   total NUMBER
)
LANGUAGE SQL
EXECUTE AS CALLER -- He aprendido por las malas que es mejor establecer esta línea para que el PROCEDURE se ejecute con los permisos míos, de quien lo llama en este caso.
AS
DECLARE
    res RESULTSET; -- Me he fijado en los compañeros con mas experiencia para aprender el RESULTSET como variable que almacena un conjunto de resultados para recurrir a los mismos posteriormente
BEGIN
    IF (:operacion = 'Balance') THEN
        res := (SELECT * FROM TABLE(total_balance_djr(:customer, :mes)));
        RETURN TABLE (res);

    ELSE
        res := (SELECT *
                FROM TABLE(total_balance_djr(:customer , :mes))
                WHERE tipo_transaccion=:operacion);
        RETURN TABLE (res);
    END IF;
END;

CALL calculos_daniel_jimenez('Balance' ,  250, 2);
CALL calculos_daniel_jimenez('purchase' ,  250, 2);
CALL calculos_daniel_jimenez('deposit' ,  250, 2);
CALL calculos_daniel_jimenez('withdrawal' ,  250, 2);
