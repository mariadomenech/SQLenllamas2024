-- En este caso nos basta con las tablas Sales y Menu. Hacemos una primera consulta donde obtengamos las veces pedidas de cada
-- producto el orden de más a menos usando la función rank. Luego con una consulta sobre esta, elimino la columna del rank. 
-- Inicialmente lo iba a hacer usando top 1 directamente en una consulta y sin usar rank, pero al final no lo hice así
-- ya que haciendo eso, si hay dos productos que son los más pedidos con un mismo número de veces, solo veríamos uno de ellos.

select product_name as "Producto más pedido",veces as "Veces pedido"
    from
      (
      select 
      b.product_name 
      , count(b.product_name) as veces
      , RANK() OVER (order by count(b.product_name) desc) AS orden
      from Sales as a
      full join Menu as b
      on a.product_id=b.product_id
      group by 1
      )
    where orden = 1;
/*********************************/
/***** COMENTARIO JUAN PEDRO *****/
/*********************************/
/*
¡Todo correcto enhorabuena! muy bien por usar RANK y no el TOP, incluso dentro de las funciones ventana un ROW_NUMBER que podría ser otra alternativa ocurriría
lo mismo en caso de empate. Si algo tengo que matizarte es que el full aunque correcto, no es recomendable es siempre mejor usar LEFT.
Otra cosilla que comentarte sería la limpieza de código, este tema siempre es subjetivo peroi creo que se vería mejor si los campos de una select llevan alguna 
tabulación extra, pero esto siempre es cuestión de gustos. Enhorabuena por tu uso del RANK!
*/
