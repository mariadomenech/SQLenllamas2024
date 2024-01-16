SELECT 
      CUSTOMER_ID
    , COUNT (DISTINCT(order_date)) as Visitas_al_Restaurante
FROM SQL_EN_LLAMAS.CASE01.SALES
GROUP BY 1
