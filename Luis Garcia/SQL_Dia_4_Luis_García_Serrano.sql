--TABLAS DE ESTUDIO
--select * from sales
--select * from members
--select * from menu

--CONSIDERACIONES PREVIAS
--TABLA HECHOS SALES S
--TABLA DIMENSIONES MENU M
--TABLA DIMENSIONES MEMBERS MEM

-- PRODUCTO MÁS PEDIDO DEL MENU Y CUANTAS VECES SE HA PEDIDO

SELECT TOP 1                    -- SE UTILIZA UN TOP 1 PARA SACAR EL QUE MAS

M.PRODUCT_NAME                   --SE UTILIZA EL DESCRIPTIVO  
,COUNT(*) as VECES_REPETIDAS
FROM SALES S 

LEFT JOIN MENU M
ON M.PRODUCT_ID=S.PRODUCT_ID

GROUP BY M.PRODUCT_NAME           -- SE AGREGA POR EL DESCRITPIVO
ORDER BY VECES_REPETIDAS DESC     -- SE ORDENA DESCENDENTEMENTE PARA RESOLVER LA PETICIÓN

/*********************************/
/***** COMENTARIO JUAN PEDRO *****/
/*********************************/
/*
¡Todo correcto enhorabuena! PERO OJO, usar TOP puede que en caso de empate en el producto más repetido solo te saque uno en vez de tantos como obtengan el primer 
puesto. Lo mejor hubiera sido una función ventana RANK o tirar de una serie de filtros usando subselect. Si tienes interes en como hacer esto y no te sale no dudes 
en pregutnar.
*/
