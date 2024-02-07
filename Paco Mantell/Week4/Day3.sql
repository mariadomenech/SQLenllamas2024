
SELECT A.product_id,
    A.price,
    B.level_text || ' ' || C.level_text || ' - ' || D.level_text product_name,
    D.id category_id,
    C.id segment_id,
    B.id style_id,
    D.level_text category_name,
    C.level_text segment_name,
    B.level_text style_name
FROM sql_en_llamas.case04.product_prices A
LEFT JOIN sql_en_llamas.case04.product_hierarchy B
    ON A.id=B.ID
LEFT JOIN sql_en_llamas.case04.product_hierarchy C
    ON B.parent_id=C.ID
LEFT JOIN sql_en_llamas.case04.product_hierarchy D
    ON C.parent_id=D.ID
