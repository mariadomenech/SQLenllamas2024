CREATE OR REPLACE PROCEDURE PROCEDIMIENTO_DAY4_WEEK3_MAT(customer INTEGER, mes INTEGER, calculo STRING)
RETURNS VARCHAR
LANGUAGE SQL
AS
DECLARE
  TOTAL_COMPRAS NUMERIC;
  MES_FINAL STRING;
  BALANCE NUMERIC;
  TIPO_CALCULO STRING;

BEGIN
    WITH CUSTOMER_TRANSACTIONS_PIVOT AS (
        SELECT *
        FROM SQL_EN_LLAMAS.CASE03.CUSTOMER_TRANSACTIONS
        PIVOT(SUM(TXN_AMOUNT) FOR TXN_TYPE IN('withdrawal','deposit', 'purchase')) AS p
        WHERE CUSTOMER_ID=:customer AND EXTRACT(MONTH, TXN_DATE)=:mes
        ORDER BY CUSTOMER_ID,TXN_DATE
    ),
    TRADUCCIONES_MES AS (
        SELECT DISTINCT EXTRACT(MONTH, TXN_DATE) AS MES, DECODE(EXTRACT(MONTH, TXN_DATE),
                                                            1,'Enero',
                                                            2,'Febrero',
                                                            3,'Marzo',
                                                            4,'Abril',
                                                            5,'Mayo',
                                                            6,'Junio',
                                                            7,'Julio',
                                                            8,'Agosto',
                                                            9,'Septiembre',
                                                            10,'Octubre',
                                                            11,'Noviembre', 
                                                            12,'Diciembre') AS MES_ES
        FROM SQL_EN_LLAMAS.CASE03.CUSTOMER_TRANSACTIONS
    )
    SELECT
        C.MES_ES, 
        CASE 
            WHEN :calculo='deposit' THEN NVL(SUM("'deposit'"),0)
            WHEN :calculo='withdrawal' THEN NVL(SUM("'withdrawal'"),0)
            WHEN :calculo='purchase' THEN NVL(SUM("'purchase'"),0)
        END AS TOTAL_CALCULO,
        NVL(SUM("'deposit'"),0)-NVL(SUM("'withdrawal'"),0)-NVL(SUM("'purchase'"),0) AS BALANCE
    INTO
        :MES_FINAL,
        :TOTAL_COMPRAS,
        :BALANCE
    FROM CUSTOMER_TRANSACTIONS_PIVOT A
    LEFT JOIN TRADUCCIONES_MES C ON (EXTRACT(MONTH, TXN_DATE)=C.MES)
    GROUP BY 1;


    --- Lógica de excepciones 
    IF (:TOTAL_COMPRAS IS NULL OR :MES_FINAL IS NULL) THEN 
        RETURN 'Cliente o mes no encontrado';
      END IF;
    
    IF (:calculo = 'deposit') THEN
        TIPO_CALCULO := 'deposito';
    ELSEIF (:calculo = 'purchase') THEN
        TIPO_CALCULO := 'compras';
    ELSEIF (:calculo = 'withdrawal') THEN
        TIPO_CALCULO := 'retiros';
    ELSE
        RETURN 'El tipo de calculo introducio no es válido. Por favor, introducir: deposit, purchase o withdrawal';
    END IF;
      

    RETURN 'El cliente ' || customer || ' tiene un total de  ' || :TOTAL_COMPRAS || 
         ' EUR en '|| :TIPO_CALCULO ||' en el mes de ' || :MES_FINAL || '. Siendo el balance total ' || :BALANCE || '.';
END;

--Llamada al procedimiento
CALL SQL_EN_LLAMAS.CASE03.PROCEDIMIENTO_DAY4_WEEK3_MAT(1,3,'purchase');