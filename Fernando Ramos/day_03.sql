SELECT 
      customer_id
    , product_name
FROM (
        SELECT
              s.customer_id
            , m.product_name
            , s.order_date
            , RANK() OVER (PARTITION BY s.customer_id
                        ORDER BY s.order_date)
                    AS PRIMERA_CONSUMICION
        FROM
            SQL_EN_LLAMAS.CASE01.SALES S
        JOIN SQL_EN_LLAMAS.CASE01.MENU M
            ON S.product_id = M.product_id 
    )
WHERE PRIMERA_CONSUMICION = 1
