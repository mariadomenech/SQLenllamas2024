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
