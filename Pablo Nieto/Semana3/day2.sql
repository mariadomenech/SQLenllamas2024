/*
Extraemos los meses de las fechas, tengo en cuenta también el año porque, aunque en este caso solo hay datos de 2020, 
no es lo mismo, por ejemplo, abril de 2020 que abril de 2021.
*/
WITH meses AS (
 SELECT DISTINCT
        LEFT(DATE_TRUNC(MONTH, TXN_DATE), 7) AS mes
    FROM SQL_EN_LLAMAS.CASE03.CUSTOMER_TRANSACTIONS
),
/*
Creamos tres columnas auxiliares, para determinar si el movimient es una compra, retirada o depósito.
También limpio la fecha quedándome de nuevo con el mes y el año, columna que utilizaré para el futuro join.
*/
movimientos AS (
    SELECT
        customer_id,
        LEFT(DATE_TRUNC(MONTH, TXN_DATE), 7) AS mes,
        CASE
            WHEN TXN_TYPE = 'deposit' THEN 1
            ELSE 0
        END AS deposito,
        CASE
            WHEN TXN_TYPE = 'withdrawal' THEN 1
            ELSE 0
        END AS retirada,
        CASE
            WHEN TXN_TYPE = 'purchase' THEN 1
            ELSE 0
        END AS compra
    FROM SQL_EN_LLAMAS.CASE03.CUSTOMER_TRANSACTIONS
),
/*
Sumo todas las transacciones de un mismo tipo para cada cliente y mes, quedándome solo con aquellos clientes que cumplen las 
condiciones del enunciado.
*/
mov_mensuales AS (
    SELECT
        customer_id,
        mes,
        SUM(deposito) depositos_mensuales,
        SUM(retirada) retiradas_mensuales,
        SUM(compra) compras_mensuales
    FROM movimientos
    GROUP BY customer_id, mes
    HAVING (SUM(deposito) > 1 AND SUM(compra) > 1) OR (SUM(retirada) > 1)
)
--Finalmente cuento cuántos clientes cumplieron con las condiciones del enunciado para cada mes.
SELECT
    mes,
    COUNT(9) AS clientes
FROM meses
LEFT JOIN mov_mensuales USING (mes)
GROUP BY mes
ORDER BY mes;
