-- Día 3 ¿Cual es el primer producto que ha pedido cada cliente?

WITH CTE_RANKING AS (SELECT
    MEMBERS.CUSTOMER_ID AS CUSTOMER_ID,
    ORDER_DATE,
    NVL(MENU.PRODUCT_NAME,'No hizo pedido') AS PRODUCT_NAME,
    RANK() OVER (PARTITION BY MEMBERS.CUSTOMER_ID ORDER BY ORDER_DATE ASC) AS RANKING_PEDIDOS
FROM
    MEMBERS
LEFT JOIN
    SALES
ON MEMBERS.CUSTOMER_ID = SALES.CUSTOMER_ID
FULL JOIN
    MENU
ON SALES.PRODUCT_ID = MENU.PRODUCT_ID)


SELECT 
    CUSTOMER_ID,
    PRODUCT_NAME,
    ORDER_DATE  
FROM 
    CTE_RANKING
WHERE RANKING_PEDIDOS = 1;

-- Otra opción pero sin el usuario sin pedidos y menos escalable
SELECT 
    MEMBERS.CUSTOMER_ID,
    MENU.PRODUCT_NAME,
    SALES.ORDER_DATE  
FROM
    MEMBERS
LEFT JOIN
    SALES
ON MEMBERS.CUSTOMER_ID = SALES.CUSTOMER_ID
FULL JOIN
    MENU
ON SALES.PRODUCT_ID = MENU.PRODUCT_ID
WHERE SALES.ORDER_DATE IN(
    SELECT MIN(ORDER_DATE)
    FROM SALES
    GROUP BY CUSTOMER_ID);

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

El resultado es correcto, aunque no se pide la fecha del pedido. Me ha gustado la utilización de CTE y de la función RANK.
La utilización del FULL JOIN no es correcta, deberiamos utilizar un LEFT JOIN ya que, aunque en este caso no se nota, utilizar FULL JOIN perjudica el rendimiento cuando se tiene varios miles de registros.

Mejoraría la legibilidad/visibilidad del código como he comentado en los ejercicios anteriores. Tambien utilizaría alias en las tablas para evitar extender el código en casos en los que los nombres de las tablas
no sean cortos/sencillos.

-> Código corregido.

WITH CTE_RANKING AS (
    SELECT
          mb.CUSTOMER_ID AS CUSTOMER_ID
        , s.ORDER_DATE
        , NVL(mn.PRODUCT_NAME,'No hizo pedido') AS PRODUCT_NAME
        , RANK() OVER (PARTITION BY mb.CUSTOMER_ID ORDER BY s.ORDER_DATE ASC) AS RANKING_PEDIDOS
    FROM MEMBERS mb
    LEFT JOIN SALES s
        ON mb.CUSTOMER_ID = s.CUSTOMER_ID
    LEFT JOIN MENU mn
        ON s.PRODUCT_ID = mn.PRODUCT_ID
)

SELECT 
      CUSTOMER_ID
    , PRODUCT_NAME
FROM CTE_RANKING
WHERE RANKING_PEDIDOS = 1;

*/
