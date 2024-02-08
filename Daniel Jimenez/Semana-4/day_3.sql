/*Replicar PRODUCT_DETAILS transformando PRODUCT_HIERARCHY Y PRODUCT_PRICES*/

WITH CATEGORY AS (
  SELECT    ID AS CATEGORY_ID
        ,   LEVEL_TEXT AS CATEGORY_NAME
  FROM PRODUCT_HIERARCHY
  WHERE LEVEL_NAME = 'Category'
),

SEGMENT AS (
  SELECT     ID AS SEGMENT_ID
        ,    LEVEL_TEXT AS SEGMENT_NAME
        ,    PARENT_ID AS CATEGORY_ID
  FROM PRODUCT_HIERARCHY
  WHERE LEVEL_NAME = 'Segment'
),

STYLE AS (
  SELECT    CAST(ID AS VARCHAR) AS STYLE_ID 
        ,   LEVEL_TEXT AS STYLE_NAME
        ,   PARENT_ID AS SEGMENT_ID
  FROM PRODUCT_HIERARCHY
  WHERE LEVEL_NAME = 'Style'
)

SELECT  CAST(P.PRODUCT_ID AS VARCHAR) AS PRODUCT_ID 
    ,   P.PRICE 
    ,   CONCAT(S.STYLE_NAME, ' ', SEG.SEGMENT_NAME, ' - ', C.CATEGORY_NAME) AS PRODUCT_NAME
    ,   C.CATEGORY_ID
    ,   SEG.SEGMENT_ID
    ,   S.STYLE_ID
    ,   C.CATEGORY_NAME
    ,   SEG.SEGMENT_NAME
    ,   S.STYLE_NAME
FROM 
  PRODUCT_PRICES P
LEFT JOIN 
  STYLE S ON S.STYLE_ID = P.ID 
LEFT JOIN 
  SEGMENT SEG ON S.SEGMENT_ID = SEG.SEGMENT_ID
LEFT JOIN 
  CATEGORY C ON SEG.CATEGORY_ID = C.CATEGORY_ID;
