/*¿Cuáles son los importes de los percentiles 25, 50 y 75 para los ingresos por transacción? */

SELECT
  PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY income) :: float AS incomes_percentil_25
  ,PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY income) :: float AS incomes_percentil_50
  ,PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY income) :: float AS incomes_percentil_75
FROM(
    SELECT ( qty * price) * (1 - (discount/100)) as income
    FROM (SELECT DISTINCT * FROM case04.sales )
     );