with nodos_previo_proximo as (
    select 
          *
        , LEAD(node_id) OVER (PARTITION BY customer_id ORDER BY end_date) as nodo_proximo
    from 
        SQL_EN_LLAMAS.CASE03.CUSTOMER_NODES
--- quitamos los que están activos ---        
    where 
        end_date <> ('9999-12-31')
)

select 
    cast(avg((end_date + 1) - start_date) as numeric(5,2)) as nodo_dias_media_cambio 
from nodos_previo_proximo
--- quitamos cuando el cambio es al mismo nodo ---
where 
    node_id <> nodo_proximo; 
