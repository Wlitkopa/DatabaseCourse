
/* Polecenie select - zadania z prezentacji */

/* Prostsze ---------------- */

select CompanyName, ContactName, Address from Customers;

select LastName, HomePhone from Employees;

select ProductName, UnitPrice from Products;

select CategoryName, Description from Categories;

select CompanyName, HomePage from Suppliers;

/* -------------------------- */

/* Pozostałe ---------------- */

-- 1. Wybierz nazwy i adresy wszystkich klientów mających siedziby w Londynie
select CompanyName, Address, Region, City, PostalCode, Country from Customers
    where City='London';

/* 2. Wybierz nazwy i adresy wszystkich klientów mających siedziby we Francji lub w
                                                                            Hiszpanii */
select CompanyName, Address, Country from Customers
    where Country='Spain' or Country='France';

select CompanyName, Country from Customers;

select ProductName, UnitPrice from Products
    where UnitPrice>=20.00 and UnitPrice<=30.00;

/* ====== */
select ProductName, UnitPrice from Products
    where CategoryID in (select Categories.CategoryID from Categories where CategoryName like '%Meat%');

-- LUB

-- Najpierw:
select CategoryID from Categories where CategoryName='%Meat%'
-- A następnie podane ID wprowadzić tutaj:
select  ProductName, UnitPrice from Products
    where CategoryID=N'Podane w wyniku wcześniejszej komendy ID';
                            -- Prefiks "N" umożliwia pisanie znaków Unicode
/* ===== */

/* 5. Wybierz nazwy produktów oraz inf. o stanie magazynu dla produktów
                                    dostarczanych przez firmę ‘Tokyo Traders’ */
select ProductName, UnitsInStock from Products
    where SupplierID in (select SupplierID from Suppliers where CompanyName = 'Tokyo Traders');

-- LUB

declare @id int;
set @id = (select SupplierID from Suppliers where CompanyName = 'Tokyo Traders');
select ProductName, UnitsInStock from Products
    where SupplierID = @id;


/* Komendy pomocnicze/sprawdzające */
select SupplierID, CompanyName from Suppliers where CompanyName='Tokyo Traders';
select ProductName, UnitPrice, SupplierID from Products where SupplierID=4;
select CategoryName, Description from Categories;
/* Koniec komend pomocniczych/sprawdzających */


select ProductName, UnitsInStock from Products
    where UnitsInStock=0;

/* -------------------------- */

/* Slajd 14 ----------------- */

-- 1. Szukamy informacji o produktach sprzedawanych w butelkach (‘bottle’)
select ProductName, QuantityPerUnit from Products
    where QuantityPerUnit like '%bottle%';

-- 2. Wyszukaj informacje o stanowisku pracowników, których nazwiska zaczynają się
-- na literę z zakresu od B do L
select Title, FirstName, LastName from Employees
    where LastName like '[B-L]%';

-- LUB
select Title, FirstName, LastName from Employees
    where left(LastName, 1) between 'B' and 'L';

-- LUB
select Title, FirstName, LastName from Employees
    where LastName > 'A' and LastName < 'M'

-- 3. Wyszukaj informacje o stanowisku pracowników, których nazwiska zaczynają się
-- na literę B lub L
select Title, FirstName, LastName from Employees
    where LastName like 'B%' or LastName like 'L%'


-- 4. Znajdź nazwy kategorii, które w opisie zawierają przecinek
select CategoryName, Description from Categories where Description like '%,%[^,]';

-- 5. Znajdź klientów, którzy w swojej nazwie mają w którymś miejscu słowo ‘Store’
select CompanyName, CustomerID from Customers where CompanyName like '%Store%';


-- • Napisz instrukcję select tak aby wybrać numer zlecenia, datę zamówienia, numer
--     klienta dla wszystkich niezrealizowanych jeszcze zleceń, dla których krajem
--      odbiorcy jest Argentyna
select orderID, OrderDate, EmployeeID from orders
    where (ShippedDate is null or ShippedDate > getdate()) and ShipCountry='Argentina'



-- 1. Wybierz nazwy i kraje wszystkich klientów, wyniki posortuj według kraju, w
--      ramach danego kraju nazwy firm posortuj alfabetycznie
select Country, CompanyName from Customers
    order by Country, CompanyName;

-- 2. Wybierz informację o produktach (grupa, nazwa, cena), produkty posortuj wg
--      grup a w grupach malejąco wg ceny
select Categories.CategoryName, Products.ProductName, Products.UnitPrice from Products
    inner join Categories on Products.CategoryID=Categories.CategoryID
    order by Categories.CategoryName, UnitPrice DESC;

-- 3. Wybierz nazwy i kraje wszystkich klientów mających siedziby w Japonii (Japan)
--      lub we Włoszech (Italy), wyniki posortuj tak jak w pkt 1
select CompanyName, Country from Customers
    where Country='Japan' or Country='Italy' order by Country, CompanyName


-- 1. Napisz polecenie, które oblicza wartość każdej pozycji zamówienia o numerze 10250
select *, round(UnitPrice*(1-Discount)*Quantity, 2) as [Total Value] from [Order Details]
    where OrderID=10250;

-- 2. Napisz polecenie które dla każdego dostawcy (supplier) pokaże pojedynczą
--      kolumnę zawierającą nr telefonu i nr faksu w formacie
--      (numer telefonu i faksu mają być oddzielone przecinkiem)
select CompanyName, Phone + ',' + Fax as 'Phone + Fax'
from Suppliers;

-- LUB
select CompanyName, concat(Phone, ', ', Fax)
from Suppliers;

-- LUB
select IIF(Fax IS NULL, Phone, concat(Phone, ', ', Fax))
from Suppliers;

-- LUB
select CompanyName, concat(Phone, ', ', Fax)
from Suppliers;

-- LUB
select concat(Phone, isnull(', ' + Fax, '')) as formatted from Suppliers;


-- pokaż zamówienia złożone w marcu 97
select OrderID, OrderDate from Orders
    where OrderDate<'1997-04-01' and OrderDate>='1997-03-01';

-- LUB
select OrderID, OrderDate from Orders
    where year(OrderDate)=1997 and month(OrderDate)=3;

-- Dla każdego zamówienia wyświetl ile dni upłynęło od daty zamówienia do daty wysyłki
select OrderDate, ShippedDate, datediff(day, OrderDate, ShippedDate) from Orders;

-- Pokaz przeterminowane zamówienia
select OrderID, RequiredDate, getdate() as DateToday, ShippedDate from Orders
    where RequiredDate<getdate() and ShippedDate is null;

-- Ile lat przepracował w firmie każdy z pracowników?
select concat(FirstName, ' ', LastName), datediff(year, HireDate, getdate()) as WorkYears
    from Employees;

-- Dla każdego pracownika wyświetl imię, nazwisko oraz wiek
select FirstName as Imie, LastName as Nazwisko, datediff(year, BirthDate, getdate()) as wiek
    from Employees;

-- Wyświetl wszystkich pracowników, którzy mają teraz więcej niż 25 lat.
select FirstName as Imie, LastName as Nazwisko, datediff(year, BirthDate, getdate()) as wiek
    from Employees
    where datediff(year, BirthDate, getdate())>25;

-- Policz średnią liczbę miesięcy przepracowanych przez każdego pracownika
select avg(datediff(month, HireDate, getdate())) from Employees;

-- LUB
select sum(datediff(month, HireDate, getdate()))/count(HireDate) from Employees;


-- Wyświetl dane wszystkich pracowników, którzy przepracowali w firmie co najmniej
--                                                  320 miesięcy, ale nie więcej niż 333
select * from Employees
    where datediff(month, HireDate, getdate()) between 320 and 333;

-- LUB
select * from Employees
    where datediff(month, HireDate, getdate())<=333 and 320<=datediff(month, HireDate, getdate());

-- Dla każdego pracownika wyświetl imię, nazwisko, rok urodzenia, rok, w którym został
--                              zatrudniony, oraz liczbę lat, którą miał w momencie zatrudnienia
select FirstName, LastName, year(BirthDate) as BirthYear, year(HireDate) as HireYear,
       datediff(year, BirthDate, HireDate) as HireAge
       from Employees;


-- Dla każdego pracownika wyświetl imię, nazwisko oraz rok, miesiąc i dzień jego
--                                  urodzenia oraz dzień tygodnia w jakim się urodził
select FirstName, LastName, left(BirthDate, 11), datename(weekday , BirthDate)
       from Employees;

-- Policz, z ilu liter składa się najkrótsze imię pracownika
select top 1 FirstName, LastName, len(FirstName)
       from Employees
        where len(FirstName) = (select min(len(FirstName)) from Employees);

select top 1 FirstName, LastName, len(FirstName)
    from Employees
    order by len(FirstName);

select min(len(FirstName)) from Employees;

-- Wyświetl, ile lat minęło od daty 1 stycznia 1990 roku.
select datediff(year, '01-01-1990', getdate())

