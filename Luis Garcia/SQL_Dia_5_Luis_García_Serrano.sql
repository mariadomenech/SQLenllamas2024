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
