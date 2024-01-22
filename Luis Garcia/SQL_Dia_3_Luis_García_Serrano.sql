--TABLAS DE ESTUDIO
--select * from sales
--select * from members
--select * from menu

--CONSIDERACIONES PREVIAS
--TABLA HECHOS SALES S
--TABLA DIMENSIONES MENU M
--TABLA DIMENSIONES MEMBERS MEM

-- PRIMER PRODUCTO QUE COMPRÓ CADA UNO
-- LO MISMO HAY UNA FORMA MAS ELEGANTE, PERO A MI SE ME OCURRE ESTO:
-- DE LA LÍNEA 14 A LA 27 UN INNER JOIN, QUE ASEGURA QUE EL ORDER_DATE COINCIDA CON LA MÍNIMA FECHA
SELECT distinct
S1.CUSTOMER_ID
,M.PRODUCT_NAME        --RESCATO EL PRODUCT NAME DESCRIPTIVO
,S1.ORDER_DATE
FROM SALES S1

INNER JOIN
(
select PRODUCT_ID
       ,min(ORDER_DATE) as MinFecha
       ,max(ORDER_DATE) as MaxFecha
       from SALES 
       group by PRODUCT_ID 
) S2 ON S1.ORDER_DATE=S2.MinFecha         -- AQUÍ NOS ASEGURAMOS LA PRIMERA FECHA

-- UNA VEZ TENEMOS LA MÍNIMA FECHA DE CADA PRODCUTO, RESCATO EL DESCRIPTIVO CON UN LEFT JOIN


LEFT JOIN MENU M
ON M.PRODUCT_ID=S1.PRODUCT_ID

-- MOLA PPORQUE SUSHI Y CURRY PARA EL CUSTOMER ID=A  SE REPITEN YA QUE SE COMPRA EL MISMO DÍA Y LO SACA

/*********************************/
/***** COMENTARIO JUAN PEDRO *****/
/*********************************/
/*
Resultado correcto pero se ha perdido una información. El A pidio dos platos y tienes ambos, pero el C también pero con el distint has perdido la información
de que su primer pedido fueron 2 ramen. Además sería interesante usar la función LISTAGG para tener a cada cliente en una sola fila aunque tuviera más de
un producto. Unos tips para limpieza de código, te reomiendo no usar saltos de linea en el código eso dificulta la lectura además de que algunos editores (no 
es el caso de snowflake) pueden no ejecutar bien si hay saltos de linea. Y los comentarios para explicar el código queda más limpio si se hacen a parte un parrafo
o varios en vez de intercalados, aunque esto son unos tips y una cuestión siempre muy debatible ya que es algo muy subjetivo la limpieza del código.
*/
