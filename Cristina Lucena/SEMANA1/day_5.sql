SELECT CUSTOMER_ID, SUM(GASTO) FROM(
  SELECT A.CUSTOMER_ID
      ,CASE WHEN C.PRODUCT_NAME = 'sushi' THEN IFNULL(SUM(C.PRICE*10*2),0)
          ELSE IFNULL(SUM(C.PRICE*10),0) END AS GASTO
  FROM SQL_EN_LLAMAS.CASE01.MEMBERS A
  LEFT JOIN SQL_EN_LLAMAS.CASE01.SALES B
  ON A.CUSTOMER_ID = B.CUSTOMER_ID
  LEFT JOIN SQL_EN_LLAMAS.CASE01.MENU C
  ON B.PRODUCT_ID = C.PRODUCT_ID
  GROUP BY A.CUSTOMER_ID, C.PRODUCT_NAME)
GROUP BY CUSTOMER_ID;

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

El resultado es correcto. Lo comentado previamente de utilizar IFNULL dentro de la suma y no fuera, y mejoraría un poco la legibilidad.
Además, se podria utilizar IFF en lugar de CASE. Por lo general, utilizo CASE cuando hay varios casos que controlar o cuando en un único caso pero con una condición más compleja.

SELECT 
      CUSTOMER_ID
    , SUM(GASTO) AS GASTO
FROM (
    SELECT 
          A.CUSTOMER_ID
        , IFF(C.PRODUCT_NAME = 'sushi', SUM(IFNULL(C.PRICE,0)*10*2), SUM(IFNULL(C.PRICE,0)*10)) AS GASTO
    FROM SQL_EN_LLAMAS.CASE01.MEMBERS A
    LEFT JOIN SQL_EN_LLAMAS.CASE01.SALES B
        ON A.CUSTOMER_ID = B.CUSTOMER_ID
    LEFT JOIN SQL_EN_LLAMAS.CASE01.MENU C
        ON B.PRODUCT_ID = C.PRODUCT_ID
    GROUP BY A.CUSTOMER_ID, C.PRODUCT_NAME
    )
GROUP BY CUSTOMER_ID;

*/
