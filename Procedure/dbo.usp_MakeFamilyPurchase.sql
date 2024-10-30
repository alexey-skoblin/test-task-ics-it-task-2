-- Процедура вычитания общей стоимости покупок из семейного счета
create or alter procedure dbo.usp_MakeFamilyPurchase
	@FamilySurName varchar(255)
as
set nocount on
begin
    if not exists (
        select 1
        from dbo.Family as f
        where f.SurName = @FamilySurName
    )
    begin
        raiserror('Ошибка: Семейство с фамилией %s не существует.', 16, 1, @FamilySurName)
        return;
    end

    update f
    set BudgetValue = cast(BudgetValue as decimal(18, 2)) - (
        select sum(Value)
        from dbo.Basket b
        where b.ID_Family = f.ID
    )
    from dbo.Family f
    where f.Surname = @FamilySurName;
end
