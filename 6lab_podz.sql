
select * from dbo.Products
SELECT productname, unitprice,
       ( SELECT AVG(unitprice) FROM products as p_wew
WHERE p_zewn.CategoryID = p_wew.categoryid ) AS average
FROM products as p_zewn
WHERE Unitprice > ( SELECT AVG(unitprice) FROM products as p_wew
WHERE p_zewn.CategoryID = p_wew.categoryid )


-- 1. Wybierz nazwy i numery telefonów klientów , którym w 1997 roku przesyłki
-- dostarczała firma United Package.
select distinct C.CompanyName, C.Phone
    from dbo.Customers as C
        where C.CustomerID in (select O.CustomerID
                                   from dbo.Orders as O
                                        where exists (select * from dbo.Shippers as S
                                                            where S.ShipperID = O.ShipVia and
                                                                S.CompanyName='United Package' and
                                                                  year(O.OrderDate)=1997 ))

select distinct C.CompanyName, C.Phone
    from dbo.Customers as C
        where C.CustomerID in (select O.CustomerID
                                   from dbo.Orders as O
                                        where O.ShipVia in (select S.ShipperID from dbo.Shippers as S
                                                            where S.CompanyName='United Package' and year(O.OrderDate)=1997 ))
select distinct C.CompanyName, C.Phone
    from dbo.Customers as C
    inner join dbo.Orders O on C.CustomerID = O.CustomerID
    inner join Shippers S on S.ShipperID = O.ShipVia
    where S.CompanyName='United Package' and year(O.OrderDate)=1997;


-- 2. Wybierz nazwy i numery telefonów klientów, którzy kupowali produkty z kategorii
-- Confections.
select distinct C.CompanyName, C.Phone
    from dbo.Customers as C
        where exists (select * from Orders as O
                        where C.CustomerID=O.CustomerID and O.OrderID in (select Od.OrderID
                                                                              from dbo.[Order Details] as Od
                                                                                where exists (select * from dbo.Products as P
                                                                                                    where P.ProductID=Od.ProductID and P.CategoryID in (select Ct.CategoryID
                                                                                                                                                            from dbo.Categories as Ct
                                                                                                                                                                where Ct.CategoryName='Confections'))) )
    order by C.CompanyName, C.Phone;


select distinct C.CompanyName, C.Phone
    from dbo.Customers as C
    inner join dbo.Orders O on C.CustomerID = O.CustomerID
    inner join dbo.[Order Details] Od on O.OrderID = Od.OrderID
    inner join Products P on Od.ProductID = P.ProductID
    inner join dbo.Categories Ct on Ct.CategoryID = P.CategoryID
        where Ct.CategoryName='Confections'
    order by C.CompanyName, C.Phone;


-- 3. Wybierz nazwy i numery telefonów klientów, którzy nie kupowali produktów z
-- kategorii Confections.
select C.CompanyName, C.Phone
    from dbo.Customers as C
        where C.CustomerID not in (select O.CustomerID from dbo.Orders as O
                        where O.OrderID in (select Od.OrderID
                                              from dbo.[Order Details] as Od
                                                where exists (select * from dbo.Products as P
                                                                where P.ProductID=Od.ProductID and P.CategoryID in (select Ct.CategoryID
                                                                                                                            from dbo.Categories as Ct
                                                                                                                                where Ct.CategoryName='Confections'))))

select distinct C.CompanyName, C.Phone, O.OrderID
    from dbo.Products as P
    inner join dbo.Categories as Ct on P.CategoryID = Ct.CategoryID and Ct.CategoryName='Confections'
    inner join dbo.[Order Details] as Od on P.ProductID = Od.ProductID
    inner join dbo.Orders as O on O.OrderID = Od.OrderID
    right join dbo.Customers as C on C.CustomerID = O.CustomerID
    where O.OrderID is null;



-- 1. Dla każdego produktu podaj maksymalną liczbę zamówionych jednostek
select zewP.ProductName, (select max(Quantity)
                            from dbo.[Order Details] as Od
                                where Od.ProductID=zewP.ProductID) as maxQuantity
    from dbo.Products as zewP
    order by zewP.ProductName

select P.ProductName, max(Od.Quantity) as maxQuantity
    from dbo.Products as P
    inner join dbo.[Order Details] Od on P.ProductID = Od.ProductID
    group by P.ProductName
    order by P.ProductName

select zewP.ProductID, (select max(Quantity)
                            from dbo.[Order Details] as Od
                                where Od.ProductID=zewP.ProductID) as maxQuantity
    from dbo.Products as zewP
    order by zewP.ProductID

SELECT DISTINCT productid, quantity
FROM [order details] AS ord1
WHERE quantity = ( SELECT MAX(quantity)
FROM [order details] AS ord2
WHERE ord1.productid =
ord2.productid )
order by ProductID

-- 2. Podaj wszystkie produkty których cena jest mniejsza niż średnia cena produktu
select zewP.ProductName, zewP.UnitPrice, (select avg(wewP.UnitPrice)
                                            from dbo.Products as wewP) as TotalAverage
    from dbo.Products as zewP
    where zewP.UnitPrice < (select avg(wewP.UnitPrice)
                                from dbo.Products as wewP)


-- 3. Podaj wszystkie produkty których cena jest mniejsza niż średnia cena produktu
-- danej kategorii
select zewP.ProductName, zewP.UnitPrice,
       (select avg(wewP.UnitPrice)
            from dbo.Products as wewP
                where wewP.CategoryID = zewP.CategoryID) as CatAverage,
        zewP.CategoryID
    from dbo.Products as zewP
    where zewP.UnitPrice < (select avg(wewP.UnitPrice)
                                            from dbo.Products as wewP
                                                where wewP.CategoryID = zewP.CategoryID)

-- Sprawdzenie --
select avg(wewP.UnitPrice)
    from dbo.Products as wewP
        where wewP.CategoryID = 1
-- 37.9791 - średnia cena kategorii 1
select P.ProductName, P.UnitPrice
    from dbo.Products as P
        where P.UnitPrice < 37.9791 and P.CategoryID = 1
-- 10 produktów, tych samych co zwróciło rozwiązanie zadania
-----------------


-- 1. Dla każdego produktu podaj jego nazwę, cenę, średnią cenę wszystkich
-- produktów oraz różnicę między ceną produktu a średnią ceną wszystkich
-- produktów

-- iif(P.UnitPrice > (select avg(UnitPrice) from dbo.Products as wewP), P.UnitPrice - (select avg(wewP.UnitPrice) from dbo.Products as wewP),
--         (select avg(UnitPrice) from dbo.Products as wewP) - P.UnitPrice)


select P.ProductName, P.UnitPrice, (select avg(UnitPrice)
                                     from dbo.Products as wewP) as TotalAverage,
    P.UnitPrice - (select avg(wewP.UnitPrice) from dbo.Products as wewP) as 'P.UnitPrice - TotalAverage'
    from dbo.Products as P

-- Sprawdzenie --
select avg(UnitPrice)
    from dbo.Products
-- 28.8663 - średnia cena wszystkich produktów
select ProductName, UnitPrice, 28.8663 as TotalAverage, UnitPrice - 28.8663 as 'P.UnitPrice - TotalAverage'
    from dbo.Products
-- wyniki są takie same
-----------------

-- 2. Dla każdego produktu podaj jego nazwę kategorii, nazwę produktu, cenę, średnią
-- cenę wszystkich produktów danej kategorii oraz różnicę między ceną produktu a
-- średnią ceną wszystkich produktów danej kategorii
select C.CategoryName, zewP.ProductName, zewP.UnitPrice,
       (select avg(wewP.UnitPrice)
            from dbo.Products as wewP
                where wewP.CategoryID = zewP.CategoryID) as CatAverage,
        zewP.UnitPrice - (select avg(wewP.UnitPrice) from dbo.Products as wewP where wewP.CategoryID = zewP.CategoryID) as CatDifference
    from dbo.Products as zewP
    inner join dbo.Categories C on C.CategoryID = zewP.CategoryID
    order by C.CategoryName, zewP.ProductName

-- Sprawdzenie --
select C.CategoryId
    from dbo.Categories as C
        where C.CategoryName='Beverages'
-- Kategoria o id równym 1 zawiera produkty, których nazwa kategorii to Beverages
select avg(UnitPrice)
            from dbo.Products
                where CategoryID = 1
-- 37.9791 - średnia cena produktów należących do kategorii o id równym 1
select 'Beverages', ProductName, UnitPrice, 37.9791 as CatAverage, UnitPrice - 37.9791 as CatDifference
       from dbo.Products
        where CategoryID = 1
        order by ProductName
-- Wyniki wydają się być takie same
------------------


-- 1. Podaj łączną wartość zamówienia o numerze 1025(0) (uwzględnij cenę za przesyłkę)
select OrderID, (select sum(Od.Quantity*Od.UnitPrice*(1-Od.Discount)) + O.Freight
                     from dbo.[Order Details] as Od
                            where Od.OrderID=10250) as TotalValue
    from dbo.Orders as O
    where O.OrderID=10250

-- Sprawdzenie --
select sum(Od.Quantity*Od.UnitPrice*(1-Od.Discount))
    from dbo.[Order Details] as Od
    where Od.OrderID=10250
-- 1552.6000366210938 - wartość zamówienia 10250 bez przesyłki
select Freight
    from dbo.Orders
        where OrderID=10250
-- 65.8300 - wartość przesyłki dla zamówienia 10250
select 65.8300 + 1552.6000366210938 as TotalValue
-- 1618.4300366210938 - łączna wartość zamówienia 10250 razem z przesyłką, taka sama jak w głównym zapytaniu

-- LUB
select sum(Od.Quantity*Od.UnitPrice*(1-Od.Discount)) + O.Freight
    from dbo.[Order Details] as Od
    inner join dbo.Orders O on O.OrderID = Od.OrderID
    where Od.OrderID=10250 and O.OrderID=10250
    group by O.Freight
-- 1618.4300366210937 - taka sama wartość


-- 2. Podaj łączną wartość zamówień każdego zamówienia (uwzględnij cenę za
-- przesyłkę)
select O.OrderID,
       (select sum(Od.UnitPrice*Od.Quantity*(1-Od.Discount))
                    from dbo.[Order Details] as Od
                        where O.OrderID=Od.OrderID) + O.Freight as TotalValue
    from dbo.Orders as O

-- Sprawdzenie --
-- wartość zamówienia jest taka sama jak w poprzednim ćwiczeniu, więc to zapytanie wydaje się poprawne
-----------------


-- 3. Czy są jacyś klienci którzy nie złożyli żadnego zamówienia w 1997 roku, jeśli tak
-- to pokaż ich dane adresowe
select C.CompanyName, C.Address, C.City, C.Region, C.PostalCode
    from dbo.Customers as C
        where C.CustomerID not in (select O.CustomerId
                                    from dbo.Orders as O
                                        where year(O.OrderDate)=1997)
    order by C.CompanyName

-- Sprawdzenie --
select C.CompanyName, C.Address, C.City, C.Region, C.PostalCode
    from dbo.Customers as C
    left join dbo.Orders O on C.CustomerID = O.CustomerID and year(O.OrderDate)=1997
    where O.OrderID is null
    order by C.CompanyName
-- Wynik jest taki sam
-----------------



-- 4. Podaj produkty kupowane przez więcej niż jednego klienta


select T.ProductName, T.ProductID
    from (select P.ProductName, P.ProductID
              from dbo.[Order Details] as Od
              inner join dbo.Orders O on O.OrderID = Od.OrderID
              inner join dbo.Products P on P.ProductID = Od.ProductID
                group by P.ProductName, P.ProductID
                having count(O.CustomerID) > 20) as T
    order by T.ProductName

-- To co jest poniżej daje identyczny rezultat, co jest dla mnie trochę nielogiczne, bo to jest de facto fragment
--          przedstawionego rozwiązania
select P.ProductName, P.ProductID
              from dbo.[Order Details] as Od
              inner join dbo.Orders O on O.OrderID = Od.OrderID
              inner join dbo.Products P on P.ProductID = Od.ProductID
                group by P.ProductName, P.ProductID
                having count(O.CustomerID) > 20
                order by P.ProductName

-- Sprawdzenie --
select P.ProductName, P.ProductID, count(C.CustomerID) as CusSum
    from dbo.Products as P
    inner join dbo.[Order Details] Od on P.ProductID = Od.ProductID
    inner join dbo.Orders O on O.OrderID = Od.OrderID
    inner join Customers C on O.CustomerID = C.CustomerID
    group by P.ProductName, P.ProductID
    having count(*) > 20
    order by P.ProductName

select distinct P.ProductName, count(*) as CusSum
    from dbo.Products as P
    inner join dbo.[Order Details] Od on P.ProductID = Od.ProductID
    inner join dbo.Orders O on O.OrderID = Od.OrderID
    inner join Customers C on O.CustomerID = C.CustomerID
    group by P.ProductName
    order by P.ProductName

select count(*) from dbo.Products;
-- Wygląda na to, że każdy produkt został zamówiony przez więcej niż jednego klienta.
--  Jednakże zdarzało się, że jeden klient zamawiał jakiś produkt w kilku zamówieniach

-- Sprawdzenie z internetu
select ProductName, COUNT(CustomerID) AS Ile
    from [Order Details] as od
    join Products as pr on pr.ProductID = od.ProductID
    join orders as o on o.orderid = od.orderid
    group by ProductName
    order by ProductName

-- Zła wersja:
select P.ProductName, P.ProductID, (select count(*)
                from dbo.Customers as C
                    where C.CustomerID in (select distinct O.CustomerID
                                            from dbo.Orders as O
                                                where O.OrderID in (select Od.OrderID from dbo.[Order Details] as Od
                                                        where Od.ProductID=17))) as CusSum
    from dbo.Products as P
        where (select count(*)
                from dbo.Customers as C
                    where C.CustomerID in (select distinct O.CustomerID
                                            from dbo.Orders as O
                                                where O.OrderID in (select Od.OrderID from dbo.[Order Details] as Od
                                                        where Od.ProductID=P.ProductID))) > 1
    order by ProductName

-----------------


-- 1. Dla każdego pracownika (imię i nazwisko) podaj łączną wartość zamówień
-- obsłużonych przez tego pracownika (przy obliczaniu wartości zamówień
-- uwzględnij cenę za przesyłkę


select E.FirstName, E.LastName, (select sum(Od.UnitPrice * Od.Quantity * (1 - Od.Discount))
                                    from Orders as O
                                    inner join dbo.[Order Details] Od on O.OrderID = Od.OrderID
                                        where O.EmployeeID = E.EmployeeID) + (select sum(O.Freight)
                                                                                from Orders as O
                                                                                    where O.EmployeeID = E.EmployeeID)
    from dbo.Employees as E
    order by E.FirstName


-- Sprawdzenie --

-- Andrew, Fuller, 166537.75497817993 - bez przesyłki
-- Andrew, Fuller, 8696.4100 - suma przesyłek
-- Andrew, Fuller, 175234.16497817993 - suma wszystkiego
select 166537.75497817993 + 8696.4100

select T.FirstName, T.LastName, T.TotalValue
from (select E.FirstName, E.LastName, sum(O.Freight) as TotalValue
      from dbo.Employees as E
               inner join Orders O on E.EmployeeID = O.EmployeeID
      group by E.FirstName, E.LastName) as T
order by T.FirstName;

select E.FirstName, E.LastName, sum(Od.UnitPrice*Od.Quantity*(1-Od.Discount)) as sum
    from Orders as O
    inner join [Order Details] Od on O.OrderID = Od.OrderID
    inner join Employees E on E.EmployeeID = O.EmployeeID
    group by E.FirstName, E.LastName, E.EmployeeID
    order by E.FirstName;






-- Próby
-- select E.FirstName, E.LastName, (select (select sum(Od.Quantity*Od.UnitPrice*(1-Od.Discount)) + O.Freight
--                                              from dbo.[Order Details] as Od
--                                                 where O.OrderID=Od.OrderID)
--                                      from dbo.Orders as O
--                                         where O.EmployeeID = E.EmployeeID)
--     from dbo.Employees as E
--
-- select Od.OrderID, sum(Od.Quantity*Od.UnitPrice*(1-Od.Discount)) + O.Freight
--     from dbo.[Order Details] as Od
--     inner join dbo.Orders O on O.OrderID = Od.OrderID
--     group by Od.OrderID, O.Freight
--
-- select sum ((select sum(Od.Quantity*Od.UnitPrice*(1-Od.Discount)) + O.Freight
--                                              from dbo.[Order Details] as Od
--                                                 where O.OrderID=Od.OrderID))
--                                      from dbo.Orders as O
--                                         where O.EmployeeID=1
-- select Od.OrderID, (sum(Od.Quantity*Od.UnitPrice*(1-Od.Discount)) + O.Freight)
--     from [Order Details] as Od
--     inner join Orders O on Od.OrderID = O.OrderID
--     group by Od.OrderID, O.Freight;
--
-- select T.FirstName, T.LastName, T.TotalValue
-- from (select E.FirstName, E.LastName, sum(Od.UnitPrice * Od.Quantity * (1 - Od.Discount)) as TotalValue
--       from dbo.Employees as E
--                inner join Orders O on E.EmployeeID = O.EmployeeID
--                inner join dbo.[Order Details] Od on O.OrderID = Od.OrderID
--       group by E.FirstName, E.LastName) as T
-- order by T.FirstName;


----------------


-- 2. Który z pracowników obsłużył najaktywniejszy (obsłużył zamówienia o
-- największej wartości) w 1997r, podaj imię i nazwisko takiego pracownika
select top 1 E.FirstName, E.LastName, (select sum(Od.UnitPrice * Od.Quantity * (1 - Od.Discount))
                                    from Orders as O
                                    inner join dbo.[Order Details] Od on O.OrderID = Od.OrderID
                                        where O.EmployeeID = E.EmployeeID and year(O.OrderDate)=1997)
                                    + (select sum(O.Freight)
                                        from Orders as O
                                            where O.EmployeeID = E.EmployeeID and year(O.OrderDate)=1997) as TotalValue
    from dbo.Employees as E
    order by TotalValue desc;

-- Sprawdzenie --
select E.FirstName, E.LastName, E.EmployeeID, cast(sum(Od.UnitPrice*Od.Quantity*(1-Od.Discount)) as decimal (10, 2)) as sum
    from Orders as O
    inner join [Order Details] Od on O.OrderID = Od.OrderID
    inner join Employees E on E.EmployeeID = O.EmployeeID
    left outer join Employees as Ep on E.EmployeeID = Ep.ReportsTo
            where Ep.FirstName is null and year(O.OrderDate)=1997
    group by E.FirstName, E.LastName, E.EmployeeID
    order by sum(Od.UnitPrice*Od.Quantity*(1-Od.Discount));
-- Wyjąwszy Freight wszystko się zgadza
-- Margaret Peacock ma ID = 4
-- 6648.6000 - łączna wartość opłat za przesyłki zamówień Margaret Peacock
-- 135458.3900 - łączna wartość, jest taka sama jak w rozwiązaniu zadania
select 6648.6000 + 128809.79
select sum(O.Freight) from Orders as O where O.EmployeeID = 4 and year(O.OrderDate)=1997
select E.FirstName, E.LastName, E.EmployeeID
    from dbo.Employees as E

----------------

-- 3. Ogranicz wynik z pkt 1 tylko do pracowników
-- a) którzy mają podwładnych
select E.FirstName, E.LastName, (select sum(Od.UnitPrice * Od.Quantity * (1 - Od.Discount))
                                    from Orders as O
                                    inner join dbo.[Order Details] Od on O.OrderID = Od.OrderID
                                        where O.EmployeeID = E.EmployeeID) + (select sum(O.Freight)
                                                                                from Orders as O
                                                                                    where O.EmployeeID = E.EmployeeID) as TotalValue
    from dbo.Employees as E
        where E.EmployeeID in (select Ep.ReportsTo
                                   from dbo.Employees as Ep)
    order by E.FirstName


-- b) którzy nie mają podwładnych
select E.FirstName, E.LastName, (select sum(Od.UnitPrice * Od.Quantity * (1 - Od.Discount))
                                    from Orders as O
                                    inner join dbo.[Order Details] Od on O.OrderID = Od.OrderID
                                        where O.EmployeeID = E.EmployeeID) + (select sum(O.Freight)
                                                                                from Orders as O
                                                                                    where O.EmployeeID = E.EmployeeID) as TotalValue
    from dbo.Employees as E
        where E.EmployeeID not in (select distinct Ep.ReportsTo
                                       from dbo.Employees as Ep
                                            where Ep.ReportsTo is not null)
    order by E.FirstName

-- 4. Zmodyfikuj rozwiązania z pkt 3 tak aby dla pracowników pokazać jeszcze datę
-- ostatnio obsłużonego zamówienia

-- a)
select E.FirstName, E.LastName, (select sum(Od.UnitPrice * Od.Quantity * (1 - Od.Discount))
                                    from Orders as O
                                    inner join dbo.[Order Details] Od on O.OrderID = Od.OrderID
                                        where O.EmployeeID = E.EmployeeID) + (select sum(O.Freight)
                                                                                from Orders as O
                                                                                    where O.EmployeeID = E.EmployeeID) as TotalValue,
            (select top 1 O.OrderDate
                 from dbo.Orders as O
                    where E.EmployeeID = O.EmployeeID
                        order by O.OrderDate desc) as LastOrder
    from dbo.Employees as E
        where E.EmployeeID in (select Ep.ReportsTo
                                   from dbo.Employees as Ep)
    order by E.FirstName



-- b)
select E.FirstName, E.LastName, (select sum(Od.UnitPrice * Od.Quantity * (1 - Od.Discount))
                                    from Orders as O
                                    inner join dbo.[Order Details] Od on O.OrderID = Od.OrderID
                                        where O.EmployeeID = E.EmployeeID) + (select sum(O.Freight)
                                                                                from Orders as O
                                                                                    where O.EmployeeID = E.EmployeeID) as TotalValue,
            (select top 1 O.OrderDate
                 from dbo.Orders as O
                    where E.EmployeeID = O.EmployeeID
                        order by O.OrderDate desc) as LastOrder
    from dbo.Employees as E
        where E.EmployeeID not in (select distinct Ep.ReportsTo
                                   from dbo.Employees as Ep
                                        where Ep.ReportsTo is not null)
    order by E.FirstName



