-- Создание представления vw_SKUPrice
create or alter view dbo.vw_SKUPrice
as
select
    s.*
    ,dbo.udf_GetSKUPrice(s.ID) as UnitPrice
from dbo.SKU as s;
