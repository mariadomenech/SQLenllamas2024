USE SQL_EN_LLAMAS;
USE SCHEMA CASE02;

SELECT TOPPING_NAME AS "NOMB_INGREDIENTE",
  COUNT(VALUE) AS VEC_REPETIDO
FROM PIZZA_RECIPES R,
LATERAL FLATTEN(INPUT=>SPLIT(TRIM(R.TOPPINGS), ','))
INNER JOIN PIZZA_TOPPINGS T
ON VALUE::INT = T.TOPPING_ID
GROUP BY 1
ORDER BY 2 DESC;

/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/* 

Perfecto, si te aburres algún día inténtalo con el UNPIVOT ;) 

*/
