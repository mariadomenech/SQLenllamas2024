-- ¿Cuál es el primer producto que ha pedido cada cliente?
SELECT
    A.customer_id
   ,A.first_order_date
   ,LISTAGG(DISTINCT A.product_name ||' (' || product_count||')', ', ')  AS orders_placed
FROM
    (
    SELECT 
        sales.customer_id
        ,menu.product_name
        ,sales.order_date as first_order_date
        ,COUNT( DISTINCT menu.product_name) OVER (PARTITION BY sales.customer_id,
                                                               sales.order_date,
                                                               menu.product_name
                                                  ) AS product_count       
    FROM case01.members
    LEFT JOIN case01.sales
    INNER JOIN (SELECT product_id, product_name 
                FROM case01.menu
                ) AS menu
           ON sales.product_id = menu.product_id 
    WHERE order_date in (select min (order_date) 
                         from case01.sales)
    ) A
GROUP BY A.customer_id,A.first_order_date


/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

El resultado es correcto, pero no se pide la fecha del pedido y el cruce LEFT JOIN con SALES no tiene coindición establecida (ON members.customer_id = sales.customer_id). 

Otro detalle es que cuando haces el filtro "order_date in (select min (order_date) from case01.sales)" sacas una unica fecha por lo que solo te mostraría registros
de esa única fecha en específico. Te recomendaría utilizar la función de ventana RANK, échale un vistazo.

SELECT
      A.customer_id
    , A.first_order_date
    , LISTAGG(DISTINCT A.product_name ||' (' || ranking ||')', ', ')  AS orders_placed
FROM (
    SELECT 
          sales.customer_id
        , menu.product_name
        , sales.order_date as first_order_date
        , RANK() OVER (PARTITION BY sales.customer_id ORDER BY sales.order_date asc) AS ranking       
    FROM case01.members
    LEFT JOIN case01.sales
        ON members.customer_id = sales.customer_id
    INNER JOIN case01.menu
        ON sales.product_id = menu.product_id
    ) A
WHERE A.ranking = 1
GROUP BY A.customer_id, A.first_order_date
ORDER BY A.customer_id;

Un detalle que me ha gustado mucho es la utilización de LISTAGG para hacer la salida de la query más limpia.

*/
