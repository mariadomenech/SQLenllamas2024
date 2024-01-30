select topping_name,count(*) num_rep
from (
    select
      pizza_id,
      trim(value::string) as toppings
    from pizza_recipes,
      lateral flatten(INPUT => split(replace(toppings,' ',''),',')) as top
    ) topping
full join pizza_toppings name
    on topping.toppings = name.topping_id
group by topping_name;