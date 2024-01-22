--TABLAS DE ESTUDIO
--select * from sales
--select * from members
--select * from menu

--CONSIDERACIONES PREVIAS
--TABLA HECHOS SALES S
--TABLA DIMENSIONES MENU M
--TABLA DIMENSIONES MEMBERS MEM

-- PUNTOS FIDELIZACION POR CLIENTE
SELECT 
CUSTOMER_ID
,SUM(PUNTOS_FIDELIZACION) AS PUNTOS_FIDELIZACION         -- SE SUMA PARA LUEGO HACER EL GROUP BY POR CUSTOMER_ID
FROM (
SELECT                     
s.customer_id
--,M.PRODUCT_NAME
--,M.PRICE--SE UTILIZA EL DESCRIPTIVO  
--,COUNT(*) as VECES_REPETIDAS
--,case when product_name='sushi' then m.price*2 else price end as price_ponderado
,(count (*)*case when product_name='sushi' then m.price*2 else price end) as PUNTOS_FIDELIZACION  --ESTA ES LA CLAVE, MULTIPLICAR POR 2 CUANDO ES SUSHI
                                                                                                   -- CREO QUE SE PUEDE HACER MAS ELEGANTE
FROM SALES S 

LEFT JOIN MENU M
ON M.PRODUCT_ID=S.PRODUCT_ID

GROUP BY s.customer_id,M.PRODUCT_NAME,M.PRICE        
ORDER BY PUNTOS_FIDELIZACION DESC     -- SE ORDENA DESCENDENTEMENTE PARA VER LOS CLIENTES CON MAS PUNTOS
)
GROUP BY CUSTOMER_ID
/*********************************/
/***** COMENTARIO JUAN PEDRO *****/
/*********************************/
/*
Resultado casi correcto, te a faltado un x10, pues son 10 puntos y 20 el sushi. Por lo demás correcto, aunque un poco extraño, no es nesaria la subconsutla,
se puede hacer todo en una, pero no es eso lo que me resulta extraño , si no el como obtienes los puntos de fidelización, dijo extraño que no incorrecto,
es cierto que en la cabeza de cada uno puede parecer directo de una forma u otra. También te hago incampie en que los comentarios en mitad del código ensucian
mucho la lectura. Te pongo mi propuesta que hubiera hecho yo:
USE DATABASE SQL_EN_LLAMAS;
USE SCHEMA CASE01;

SELECT A.CUSTOMER_ID, 
       SUM(CASE WHEN C.PRODUCT_NAME = 'sushi' 
                THEN NVL(C.PRICE,0)*20
                ELSE NVL(C.PRICE,0)*10
                END) AS POINTS
FROM MEMBERS A
LEFT JOIN SALES B
       ON A.CUSTOMER_ID = B.CUSTOMER_ID
LEFT JOIN MENU C
       ON B.PRODUCT_ID = C.PRODUCT_ID
GROUP BY A.CUSTOMER_ID
ORDER BY CUSTOMER_ID;

Cruazo MEMBERS left SALES left MENU y agurpo por CUSTOMER_ID (de members) y sumamos el PRICE multiplicado por 20 o 10 según sea sushi o no.

En cualquier caso salvo por el x10 tu resultado es igualemnte correcto.
*/
