USE SQL_EN_LLAMAS;
USE SCHEMA case04;

SELECT DISTINCT PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY ((qty * price) - ((qty * price * discount) / 100))) AS "Percentil 25",
				PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY ((qty * price) - ((qty * price * discount) / 100))) AS "Percentil 50",
				PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY ((qty * price) - ((qty * price * discount) / 100))) AS "Percentil 75"
FROM sales;
