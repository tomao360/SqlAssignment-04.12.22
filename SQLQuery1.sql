--Examples for between and case
select SupplierId,
	case
		when SupplierID between 1 and 5 then 'Class A'
		when SupplierID between 6 and 12 then 'Class B'
		when SupplierID between 13 and 15 then 'Class C'
		else 'Class Z'
	end as SupplierGroup --טור חדש שרלוונטי לדאטה סט הספציפי הזה
from Suppliers

--------------------------------
select EmployeeID,  
	case	
		when Notes like '%BA%' then 'Academic'
		else 'High School'
	end as Knowladge
from Employees
--------------------------------
select CustomerID, City,
	case	
		when Region is null then 'No Region'
		else Region
	end as Region
from Customers

-------------------------------------------------------------------
--Questions video 7
--Q1
select *,
	case
		when Substring(Country, 1, 1) like 'A%' then 'AAA'
		when Substring(Country, 1, 1) like 'B%' then 'BBB'
		when Substring(Country, 1, 1) like 'C%' then 'CCC'
		else 'ZZZ'
	end as COUNTRY_NICK
from Customers

--Q2
select *,
	case
		when UnitPrice < 5 then 'CHEAP'
		when UnitPrice between 5 and 10 then 'MEDIUM'
		when UnitPrice between 100 and 150 then 'EXPENSIVE'
		else 'NORMAL'
	end as PriceRec
from Products

-------------------------------------------------------------------
--Examples for sub select
select * from [Order Details]
where OrderID in (
select OrderID from Orders
where EmployeeID = 1 )
--------------------------------
--Examples for stored procedure
create procedure OrdersOfEmp1
as 
begin 
	select * from Orders where EmployeeID = 1
end 

exec OrdersOfEmp1
Drop procedure OrdersOfEmp1
--------------------------------
CREATE PROCEDURE getAllOrdersInSystem
as
begin
	select * from Orders
end

exec getAllOrdersInSystem
drop procedure getAllOrdersInSystem
--------------------------------
create procedure GetOrdersOfEmployee
	@param1 int
as 
begin 
	select * from Orders where EmployeeID = @param1
end 

exec GetOrdersOfEmployee @param1 = 2
exec GetOrdersOfEmployee @param1 = 3
exec GetOrdersOfEmployee @param1 = 1

Drop procedure GetOrdersOfEmployee
--------------------------------
create procedure testVar
as 
begin 
	declare @a int 
	declare @b int 
	declare @c int 

	set @a = 1
	set @b = 2
	set @c = @a + @b

	select @c
end 

exec testVar
Drop procedure testVar
-------------------------------------------------------------------
--Questions video 8
--Q1
select CustomerID from Orders
where OrderID in (
	select OrderID from [Order Details]
	where UnitPrice = 14)

--Q2
select C.CompanyName, C.City, E.FirstName from Customers C
inner join Employees E on E.City = C.City
where (C.City = 'Los Angeles' and E.City = 'Los Angeles')  or 
		(C.City = 'Seattle' and E.City = 'Seattle')  or 
		(C.City = 'New York' and E.City = 'New York')

--Q3
select ProductName from Products
where SupplierID in (
	select SupplierID from Suppliers
	where UnitPrice > 30 and (Country = 'USA' or Country = 'UK'))

--Q4
create procedure OrderDetailsById
	@param1 int
as 
begin
	select ProductID from [Order Details] where OrderID = @param1
end

exec OrderDetailsById @param1 = 10255
drop procedure OrderDetailsById

--Q5
create procedure ProductOrderById
	@param1 int
as 
begin
	select OrderID from [Order Details] where ProductID = @param1
end

exec ProductOrderById @param1 = 16
drop procedure ProductOrderById

--Q6
create procedure ProductByPrice
	@param1 money
as 
begin
	select ProductName from Products where UnitPrice = @param1
end

exec ProductByPrice @param1 = 2.5
drop procedure ProductByPrice

--Q7
create procedure OrderByShippers
	@param1 int
as 
begin
	select OrderID from Orders where ShipVia = @param1
end

exec OrderByShippers @param1 = 1
drop procedure OrderByShippers

-------------------------------------------------------------------
--Questions video about aggregation 
--Q0
select [UnitPrice], 
ProductsCount = COUNT(*),
AveragePricing = AVG([UnitPrice]), 
TotalPriceBYGroup = sum([UnitPrice]),
MinStock = Min([UnitsInStock]),
MaxStock = Max([UnitsInStock])
from [dbo].[Products]
where [UnitPrice] between 10 and 50
group by [UnitPrice]
having sum([UnitPrice]) > 30
order by MinStock asc

--Q1
select MaxPrice = MAX(UnitPrice) from Products

--Q2
select AveragePrice = AVG(UnitPrice) from Products

--Q3
select MinPrice = MIN(UnitPrice) from Products

--Q4
select ProductName from Products
where UnitPrice in (
	select MAX(UnitPrice) from Products)

--Q5
select ProductName from Products
where UnitPrice in (
	select MIN(UnitPrice) from Products)

--Q6
create procedure OrdersByCountry
	@param1 nvarchar(MAX)
as 
begin
	select COUNT(ShipCountry) as Deliveries from Orders where ShipCountry = @param1
end

exec OrdersByCountry @param1 = 'USA'
drop procedure OrdersByCountry

--Q7
create procedure ProductsToCountry
	@param1 nvarchar(MAX)
as 
begin
	select COUNT(OrderID) as ProductCount from [Order Details] 
	where OrderID in (
		select OrderID from Orders 
		where ShipCountry = @param1)
end

exec ProductsToCountry @param1 = 'France'
drop procedure ProductsToCountry