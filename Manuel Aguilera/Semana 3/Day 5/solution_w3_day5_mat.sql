---FUNCION 1: FUNCION_CALCULO_MAT
CREATE OR REPLACE FUNCTION SQL_EN_LLAMAS.CASE03.FUNCION_CALCULO_MAT (customer INTEGER, mes INTEGER, calculo STRING)
  RETURNS NUMERIC 
  AS 
  $$
  SELECT
    NVL(SUM(TXN_AMOUNT),0) AS TOTAL_COMPRAS
  FROM
    SQL_EN_LLAMAS.CASE03.CUSTOMER_TRANSACTIONS
  WHERE
    CUSTOMER_ID = customer
    AND TXN_TYPE = calculo
    AND EXTRACT(MONTH, TXN_DATE) = mes
  $$
  ;

---FUNCION 2: FUNCION_BALANCE_MAT
CREATE OR REPLACE FUNCTION SQL_EN_LLAMAS.CASE03.FUNCION_BALANCE_MAT (customer INTEGER, mes INTEGER)
  RETURNS NUMERIC 
  AS 
  $$
   WITH CUSTOMER_TRANSACTIONS_PIVOT AS (
        SELECT *
        FROM SQL_EN_LLAMAS.CASE03.CUSTOMER_TRANSACTIONS
        PIVOT(SUM(TXN_AMOUNT) FOR TXN_TYPE IN('withdrawal','deposit', 'purchase')) AS p
        WHERE CUSTOMER_ID=customer AND EXTRACT(MONTH, TXN_DATE)=mes
        ORDER BY CUSTOMER_ID,TXN_DATE
    )
    SELECT
        NVL(SUM("'deposit'"),0)-NVL(SUM("'withdrawal'"),0)-NVL(SUM("'purchase'"),0) AS BALANCE
    FROM CUSTOMER_TRANSACTIONS_PIVOT A
  $$
  ;

---PROCEDURE: PROCEDIMIENTO_DAY5_WEEK3_MAT
CREATE OR REPLACE PROCEDURE PROCEDIMIENTO_DAY5_WEEK3_MAT(customer INTEGER, mes INTEGER, calculo STRING)
RETURNS VARCHAR
LANGUAGE SQL
AS
DECLARE
  TOTAL_COMPRAS NUMERIC;
  MES_FINAL STRING;
  BALANCE NUMERIC;
  TIPO_CALCULO STRING;

BEGIN

     /*----
     Lógica de excepciones de los parametros introducidos 
     -----*/
 
     --Tipo de calculo
    IF (:calculo = 'deposit') THEN
        TIPO_CALCULO := 'deposito';
    ELSEIF (:calculo = 'purchase') THEN
        TIPO_CALCULO := 'compras';
    ELSEIF (:calculo = 'withdrawal') THEN
        TIPO_CALCULO := 'retiros';
    ELSE
        RETURN 'El tipo de calculo introducio no es válido. Por favor, introducir: deposit, purchase o withdrawal';
    END IF;

     --Mes introducido
    IF (:mes BETWEEN 1 AND 12) THEN
      MES_FINAL := decode(:mes,
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
                                            12,'Diciembre'
                                        );  
    ELSE   
        RETURN 'Mes incorrecto. Por favor introduzca un mes válido (1:Enero, ...12:Diciembre)';
    END IF;

     --Cliente no valido
    IF ((SELECT COUNT(*) FROM SQL_EN_LLAMAS.CASE03.CUSTOMER_TRANSACTIONS WHERE CUSTOMER_ID=:customer)=0) THEN
        RETURN 'Cliente no encontrado. Por favor introduzca un cliente válido';      
    END IF;

   --Llamada funcion total calculo
    SELECT SQL_EN_LLAMAS.CASE03.FUNCION_CALCULO_MAT (:customer,:mes,:calculo)
    INTO :TOTAL_COMPRAS;


    -- Llamada funcion calculo balance
    SELECT SQL_EN_LLAMAS.CASE03.FUNCION_BALANCE_MAT (:customer,:mes)
    INTO :BALANCE;

                                     
    RETURN 'El cliente ' || customer || ' tiene un total de  ' || :TOTAL_COMPRAS || 
         ' EUR en '|| :TIPO_CALCULO ||' en el mes de ' || :MES_FINAL || '. Siendo el balance total ' || :BALANCE || '.';
END;

/*COMENTARIOS JUANPE: TODO CORRECTO Y BIEN ORGANIZADO EL CÓDIGO*/
