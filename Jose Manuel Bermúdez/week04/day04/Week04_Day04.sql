USE SQL_EN_LLAMAS;
USE SCHEMA case04;

SELECT DISTINCT PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY ((qty * price) - ((qty * price * discount) / 100))) AS "Percentil 25",
				PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY ((qty * price) - ((qty * price * discount) / 100))) AS "Percentil 50",
				PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY ((qty * price) - ((qty * price * discount) / 100))) AS "Percentil 75"
FROM sales;



/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/* 
Tal y como lo has planetado has sacado los distintos percentiles por producto.

Para que sea por transacción como pedimos en el enunciado, debes calcular los ingresos por transacción previamente. 
Y después calcular los percentiles sobre esos importes.

La función que coges es la correcta!
*/
