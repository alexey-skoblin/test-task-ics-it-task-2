-- Добавление скидки для покупок одного товара множество раз одним покупателем
create or alter trigger dbo.TR_Basket_insert_update on dbo.Basket
after insert
as
begin
    -- Обновление DiscountValue для ID_SKU, которые добавлены в количестве 2 и более за раз
    ;with cte_MultiInsertSKU as (
        select ID_SKU
        from inserted
        group by ID_SKU
        having count(*) >= 2
    )
    update b
    set b.DiscountValue = b.Value * 0.05
    from dbo.Basket as b
        inner join inserted as i on i.ID = b.ID
        inner join cte_MultiInsertSKU as mis on mis.ID_SKU = i.ID_SKU
    where b.ID = i.ID

    -- Обновление DiscountValue для остальных записей
    ;with cte_SingleInsertSKU as (
        select ID_SKU
        from inserted
        group by ID_SKU
        having count(*) = 1
    )
    update b
    set b.DiscountValue = 0
    from dbo.Basket b
        inner join inserted as i on i.ID = b.ID
        inner join cte_SingleInsertSKU as sis on sis.ID_SKU = i.ID_SKU
    where b.ID = i.ID
end
