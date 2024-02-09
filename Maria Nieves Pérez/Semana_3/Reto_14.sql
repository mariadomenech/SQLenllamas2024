------EL PROCEDIMIENTO CARGA, PERO HAY ALGO MAL Y NO SE EJECUTA LUEGO. NO SE QUE PUEDE SER...-------

USE SQL_EN_LLAMAS; 
USE SCHEMA CASE03;

CREATE OR REPLACE PROCEDURE MNievesPerez_informe_cliente (cliente INT, mes INT, tipo_calculo VARCHAR)
RETURNS VARCHAR 
LANGUAGE SQL
AS
DECLARE 
    mensaje VARCHAR;

BEGIN

SELECT
    CASE WHEN :tipo_calculo = 'purchase' THEN mensaje_compras
        WHEN :tipo_calculo = 'withdrawal' THEN mensaje_retiros
        WHEN :tipo_calculo = 'deposit' THEN mensaje_depositos
        END as mensaje
FROM (
    SELECT   
        concat('El cliente ', :cliente, ' ha depositado un total de ', NVL(:total,0), ' EUR en la entidad en el mes de ', nombre_mes, '.') as mensaje_depositos,
        concat('El cliente ', :cliente, ' ha retirado un total de ', NVL(:total,0), ' EUR de la entidad en el mes de ', nombre_mes, '.') as mensaje_retiros,
        concat('El cliente ', :cliente, ' se ha gastado un total de ', NVL(:total,0), ' EUR en compras de productos en el mes de ', nombre_mes, '.') as mensaje_compras    
    FROM
    (
        SELECT 
            distinct customer_id AS cliente,
            txn_type AS tipo,
            month (txn_date)::int AS mes,
            CASE 
                WHEN (month (txn_date)::int) = 1 THEN 'Enero'
                WHEN (month (txn_date)::int) = 2 THEN 'Febrero'
                WHEN (month (txn_date)::int) = 3 THEN 'Marzo'
                WHEN (month (txn_date)::int) = 4 THEN 'Abril' END AS nombre_mes,
            SUM(txn_amount) AS total
            
        FROM SQL_EN_LLAMAS.CASE03.CUSTOMER_TRANSACTIONS
        WHERE tipo = :tipo_calculo
        --where tipo = 'purchase'
        GROUP BY cliente, tipo, mes
        ORDER BY cliente, mes
    )
)
WHERE cliente = :cliente AND mes = :mes AND tipo = :tipo_calculo;

RETURN mensaje;     
END;


CALL MNievesPerez_informe_cliente (6,3,'purchase');
