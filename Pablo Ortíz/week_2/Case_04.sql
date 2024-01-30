-- En este caso usamos lateral flaten con split para separar los ingredientes en una columna. Necesitamos usar TRIM para eliminar espacios
-- ya que si no por ejemplo el ingrediente "4" en una fila salía con un espacio y en otra no, por lo que en el count no se agregaba.
with ingredientes as 

(
SELECT pizza_id
     , trim(b.value::string,' ') AS ingrediente
FROM pizza_recipes,
     LATERAL FLATTEN(input=>split(toppings, ',')) as b
     )
     
     select ingrediente
            ,COUNT(ingrediente) as Veces_Repetido
     from ingredientes
     group by ingrediente;
