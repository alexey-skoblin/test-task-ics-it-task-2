-- Расчет стоимости передаваемого продукта
create or alter function dbo.udf_GetSKUPrice(
    @ID_SKU int
)
returns decimal(18, 2)
as
begin
    return (
        select case
                when sum(quantity) > 0
                    then sum(value) / sum(quantity)
                else 0
            end
        from dbo.Basket
        where ID_SKU = @ID_SKU
    )
end
