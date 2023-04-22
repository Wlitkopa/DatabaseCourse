
-- lab6

-- 1. Wybierz nazwy i numery telefonów klientów , którym w 1997 roku przesyłki
-- dostarczała firma United Package.
select C.CompanyName, C.Phone
    from dbo.Customers C
    where C.CustomerID in (select O.CustomerID
                               from dbo.Orders O
                                inner join Shippers S on S.ShipperID = O.ShipVia
                                where S.CompanyName='United Package' and year(O.ShippedDate)=1997);

-- 2. Wybierz nazwy i numery telefonów klientów, którzy kupowali produkty z kategorii
-- Confections.
select C.CompanyName, C.Phone
    from dbo.Customers C
    where C.CustomerID in (select O.CustomerID
                               from dbo.Orders O
                               inner join dbo.[Order Details] Od on O.OrderID = Od.OrderID
                               inner join Products P on Od.ProductID = P.ProductID
                               inner join Categories C2 on P.CategoryID = C2.CategoryID
                               where C2.CategoryName='confections')

-- 3. Wybierz nazwy i numery telefonów klientów, którzy nie kupowali produktów z
-- kategorii Confections.
select C.CompanyName, C.Phone
    from dbo.Customers C
    where C.CustomerID not in (select O.CustomerID
                               from dbo.Orders O
                               inner join dbo.[Order Details] Od on O.OrderID = Od.OrderID
                               inner join Products P on Od.ProductID = P.ProductID
                               inner join Categories C2 on P.CategoryID = C2.CategoryID
                               where C2.CategoryName='confections' )


-- 1. Dla każdego produktu podaj maksymalną liczbę zamówionych jednostek
select P.ProductName, P.ProductID, (select max(od.Quantity)
                           from dbo.[Order Details] Od
                            where P.ProductID = Od.ProductID)
    from dbo.Products P
    order by P.ProductID;

select Od.ProductID, max(Od.Quantity)
    from dbo.[Order Details] Od
    group by Od.ProductID
    order by Od.ProductID;

-- 2. Podaj wszystkie produkty których cena jest mniejsza niż średnia cena produktu
select P.ProductName, P.UnitPrice
    from dbo.Products P
        where P.UnitPrice > (select avg(P2.UnitPrice)
                                 from dbo.Products P2 );


-- 3. Podaj wszystkie produkty których cena jest mniejsza niż średnia cena produktu
-- danej kategorii


select T.ProductName, T.UnitPrice, T.CatAvg
    from (select P.ProductName,
                 P.UnitPrice,
                 (select avg(Pwew.UnitPrice)
                  from dbo.Products Pwew
                  where Pwew.CategoryID = P.CategoryID) as CatAvg
          from dbo.Products P) T
    where T.UnitPrice > T.CatAvg;


-- 1. Dla każdego produktu podaj jego nazwę, cenę, średnią cenę wszystkich
-- produktów oraz różnicę między ceną produktu a średnią ceną wszystkich
-- produktów

with T as
    (select P.ProductName as name,
             P.UnitPrice as Price,
             (select avg(Pwew.UnitPrice)
              from dbo.Products Pwew) as aver
      from dbo.Products P)
select T.name, T.Price, T.aver, (T.Price - T.aver) as diff
    from T;

-- 2. Dla każdego produktu podaj jego nazwę kategorii, nazwę produktu, cenę, średnią
-- cenę wszystkich produktów danej kategorii oraz różnicę między ceną produktu a
-- średnią ceną wszystkich produktów danej kategorii
select C.CategoryName, P.ProductName, P.UnitPrice, T.CatAvg, (P.UnitPrice - T.CatAvg) as diff
    from (select P.CategoryID as TCatId, avg(P.UnitPrice) as CatAvg
              from dbo.Products P
              group by P.CategoryID) as T
    inner join dbo.Products P on T.TCatId = P.CategoryID
    inner join dbo.Categories C on C.CategoryID = T.TCatId;

-- except
select C.CategoryName, P.ProductName, P.UnitPrice,
       (select avg(Pwew.UnitPrice)
            from dbo.Products Pwew
            where Pwew.CategoryID = P.CategoryID) as CatAvg,
        (P.UnitPrice - (select avg(Pwew.UnitPrice)
            from dbo.Products Pwew
            where Pwew.CategoryID = P.CategoryID)) as diff
    from dbo.Products P
    inner join dbo.Categories C on C.CategoryID = P.CategoryID;

select * from dbo.Categories;



-- 1. Podaj łączną wartość zamówienia o numerze 1025 (uwzględnij cenę za przesyłkę)
select O.OrderID, (select sum(Od.Quantity*Od.UnitPrice*(1-Od.Discount))
            from dbo.[Order Details] Od
            where Od.OrderID = O.OrderID) + O.Freight
    from dbo.Orders O
    where O.OrderID=10250;

-- 2. Podaj łączną wartość zamówień każdego zamówienia (uwzględnij cenę za
-- przesyłkę)
select O.OrderID, (select sum(Od.Quantity*Od.UnitPrice*(1-Od.Discount))
            from dbo.[Order Details] Od
            where Od.OrderID = O.OrderID) + O.Freight
    from dbo.Orders O;

-- 3. Czy są jacyś klienci którzy nie złożyli żadnego zamówienia w 1997 roku, jeśli tak
-- to pokaż ich dane adresowe
select C.CustomerID, C.Country, C.Region, C.Address, C.PostalCode
    from dbo.Customers C
    left join Orders O on C.CustomerID = O.CustomerID and year(O.OrderDate)=1997
    where O.OrderDate is null;

-- 4. Podaj produkty kupowane przez więcej niż jednego klienta
select distinct P.ProductName, count(distinct C.CustomerID)
    from dbo.Products P
    inner join dbo.[Order Details] Od on P.ProductID = Od.ProductID
    inner join dbo.Orders O on O.OrderID = Od.OrderID
    inner join Customers C on O.CustomerID = C.CustomerID
    group by P.ProductName
    having count(distinct C.CustomerID) > 20;


-- 1. Dla każdego pracownika (imię i nazwisko) podaj łączną wartość zamówień
-- obsłużonych przez tego pracownika (przy obliczaniu wartości zamówień
-- uwzględnij cenę za przesyłkę

select T.EmployeeID, T.FirstName, T.LastName, sum(OrdSum)
    from (
select E.EmployeeID, E.FirstName, E.LastName, ((select sum(Od.UnitPrice*Od.Quantity*(1-Od.Discount))
                                                   from dbo.[Order Details] Od
                                                   where Od.OrderID = O.OrderID) + O.Freight ) as OrdSum
    from dbo.Employees E
    inner join dbo.Orders O on E.EmployeeID = O.EmployeeID
    ) T
group by T.EmployeeID, T.FirstName, T.LastName;


-- 2. Który z pracowników obsłużył najaktywniejszy (obsłużył zamówienia o
-- największej wartości) w 1997r, podaj imię i nazwisko takiego pracownika

select top 1 E.FirstName, E.LastName, (select sum(Od.UnitPrice*Od.Quantity*(1-Od.Discount))
                                     from dbo.Orders O
                                     inner join dbo.[Order Details] Od on O.OrderID = Od.OrderID
                                        where O.EmployeeID = E.EmployeeID and year(O.OrderDate)=1997) + (select sum(O2.Freight)
                                                                                  from dbo.Orders O2
                                                                                    where O2.EmployeeID = E.EmployeeID and year(O2.OrderDate)=1997) as Sum
    from dbo.Employees E
    order by Sum desc;


-- 3. Ogranicz wynik z pkt 1 tylko do pracowników
-- a) którzy mają podwładnych
select distinct E.FirstName, E.LastName, (select sum(Od.UnitPrice*Od.Quantity*(1-Od.Discount))
                                     from dbo.Orders O
                                     inner join dbo.[Order Details] Od on O.OrderID = Od.OrderID
                                        where O.EmployeeID = E.EmployeeID) + (select sum(O2.Freight)
                                                                                  from dbo.Orders O2
                                                                                    where O2.EmployeeID = E.EmployeeID) as Sum
    from dbo.Employees E
    left join dbo.Employees Epr on E.EmployeeID = Epr.ReportsTo
    where Epr.ReportsTo is not null;

-- b) którzy nie mają podwładnych
select E.FirstName, E.LastName, (select sum(Od.UnitPrice*Od.Quantity*(1-Od.Discount))
                                     from dbo.Orders O
                                     inner join dbo.[Order Details] Od on O.OrderID = Od.OrderID
                                        where O.EmployeeID = E.EmployeeID) + (select sum(O2.Freight)
                                                                                  from dbo.Orders O2
                                                                                    where O2.EmployeeID = E.EmployeeID) as Sum
    from dbo.Employees E
    left join dbo.Employees Epr on E.EmployeeID = Epr.ReportsTo
    where Epr.ReportsTo is null
    order by E.FirstName;


-- 4. Zmodyfikuj rozwiązania z pkt 3 tak aby dla pracowników pokazać jeszcze datę
-- ostatnio obsłużonego zamówienia

-- a) którzy mają podwładnych
select distinct E.FirstName, E.LastName, (select sum(Od.UnitPrice*Od.Quantity*(1-Od.Discount))
                                     from dbo.Orders O
                                     inner join dbo.[Order Details] Od on O.OrderID = Od.OrderID
                                        where O.EmployeeID = E.EmployeeID) + (select sum(O2.Freight)
                                                                                  from dbo.Orders O2
                                                                                    where O2.EmployeeID = E.EmployeeID) as Sum,
    (select max(O.OrderDate)
        from dbo.Orders O
            where O.EmployeeID = E.EmployeeID) as LastOrder
    from dbo.Employees E
    left join dbo.Employees Epr on E.EmployeeID = Epr.ReportsTo
    where Epr.ReportsTo is not null;

-- b) którzy nie mają podwładnych
select E.FirstName, E.LastName, (select sum(Od.UnitPrice*Od.Quantity*(1-Od.Discount))
                                     from dbo.Orders O
                                     inner join dbo.[Order Details] Od on O.OrderID = Od.OrderID
                                        where O.EmployeeID = E.EmployeeID) + (select sum(O2.Freight)
                                                                                  from dbo.Orders O2
                                                                                    where O2.EmployeeID = E.EmployeeID) as Sum,
    (select max(O.OrderDate)
        from dbo.Orders O
            where O.EmployeeID = E.EmployeeID) as LastOrder
    from dbo.Employees E
    left join dbo.Employees Epr on E.EmployeeID = Epr.ReportsTo
    where Epr.ReportsTo is null
    order by E.FirstName;



-- lab5

-- 1. Dla każdego zamówienia podaj łączną liczbę zamówionych jednostek towaru oraz
-- nazwę klienta.
select O.OrderID, C.CustomerID, sum(Od.Quantity)
    from dbo.Orders O
    inner join Customers C on O.CustomerID = C.CustomerID
    inner join dbo.[Order Details] Od on O.OrderID = Od.OrderID
    group by O.OrderID, C.CustomerID;


-- 2. Zmodyfikuj poprzedni przykład, aby pokazać tylko takie zamówienia, dla których
-- łączna liczbę zamówionych jednostek jest większa niż 250
select O.OrderID, C.CustomerID, sum(Od.Quantity)
    from dbo.Orders O
    inner join Customers C on O.CustomerID = C.CustomerID
    inner join dbo.[Order Details] Od on O.OrderID = Od.OrderID
    group by O.OrderID, C.CustomerID
    having sum(Od.Quantity)>250;


-- 3. Dla każdego zamówienia podaj łączną wartość tego zamówienia oraz nazwę
-- klienta.
select O.OrderID, C.CompanyName, sum(Od.Quantity*Od.UnitPrice*(1-Od.Discount))
    from dbo.Orders O
    inner join dbo.[Order Details] Od on Od.OrderID = O.OrderID
    inner join Customers C on O.CustomerID = C.CustomerID
    group by O.OrderID, C.CompanyName;

-- 4. Zmodyfikuj poprzedni przykład, aby pokazać tylko takie zamówienia, dla których
-- łączna liczba jednostek jest większa niż 250.
select O.OrderID, C.CompanyName, sum(Od.Quantity*Od.UnitPrice*(1-Od.Discount))
    from dbo.Orders O
    inner join dbo.[Order Details] Od on Od.OrderID = O.OrderID
    inner join Customers C on O.CustomerID = C.CustomerID
    group by O.OrderID, C.CompanyName
    having sum(Od.Quantity) > 250;


-- 5. Zmodyfikuj poprzedni przykład tak żeby dodać jeszcze imię i nazwisko
-- pracownika obsługującego zamówienie
select O.OrderID, C.CompanyName, E.FirstName, E.LastName, sum(Od.Quantity*Od.UnitPrice*(1-Od.Discount))
    from dbo.Orders O
    inner join dbo.[Order Details] Od on Od.OrderID = O.OrderID
    inner join Customers C on O.CustomerID = C.CustomerID
    inner join dbo.Employees E on E.EmployeeID = O.EmployeeID
    group by O.OrderID, C.CompanyName, E.FirstName, E.LastName
    having sum(Od.Quantity) > 250;


--  Dla każdego klienta podaj liczbę zamówień w każdym z lat 1997, 98
select C.CompanyName,  count(O.OrderID)
    from dbo.Customers C
    left join dbo.Orders O on C.CustomerID = O.CustomerID and (year(O.OrderDate) in (1997, 1998))
    group by C.CompanyName;


with rec as
    (select 1997 as x
        union all
        select x + 1
        from rec
        where x<1998)
 select C.CompanyName, x, count(O.OrderDate) from rec
    cross join Customers C
    left join dbo.Orders O on x = year(O.OrderDate) and O.CustomerID = C.CustomerID
    group by C.CompanyName, x
    order by C.CompanyName;

--  Dla każdego klienta podaj liczbę zamówień w każdym z miesięcy 1997, 98

with rec as (
    select cast('1997-01-01' as date) as x
    union all
    select dateadd(month, 1, x) from rec where (month(x) < 12 or year(x) < 1998)
)
select C.CompanyName, substring(cast(x as varchar), 1, 7), count(O.OrderDate) from rec
cross join dbo.Customers C
left join Orders O on (month(x) = month(O.OrderDate) and year(x) = year(O.OrderDate)) and C.CustomerID = O.CustomerID
group by C.CompanyName, substring(cast(x as varchar), 1, 7)
order by  C.CompanyName;


-- 1. Dla każdej kategorii produktu (nazwa), podaj łączną liczbę zamówionych przez
-- klientów jednostek towarów z tek kategorii.
select C.CategoryName, sum(Od.Quantity)
    from dbo.Categories C
    inner join dbo.Products P on C.CategoryID = P.CategoryID
    inner join dbo.[Order Details] Od on P.ProductID = Od.ProductID
    group by C.CategoryName;

-- 2. Dla każdej kategorii produktu (nazwa), podaj łączną wartość zamówionych przez
-- klientów jednostek towarów z tek kategorii.
select C.CategoryName, sum(Od.Quantity*od.UnitPrice*(1-Od.Discount))
    from dbo.Categories C
    inner join dbo.Products P on C.CategoryID = P.CategoryID
    inner join dbo.[Order Details] Od on P.ProductID = Od.ProductID
    group by C.CategoryName;


-- 3. Posortuj wyniki w zapytaniu z poprzedniego punktu wg:
-- a) łącznej wartości zamówień
select C.CategoryName, sum(Od.Quantity*od.UnitPrice*(1-Od.Discount))
    from dbo.Categories C
    inner join dbo.Products P on C.CategoryID = P.CategoryID
    inner join dbo.[Order Details] Od on P.ProductID = Od.ProductID
    group by C.CategoryName
    order by sum(Od.Quantity*od.UnitPrice*(1-Od.Discount));

-- b) łącznej liczby zamówionych przez klientów jednostek towarów.
select C.CategoryName, cast(sum(Od.Quantity*od.UnitPrice*(1-Od.Discount)) as decimal(10, 2))
    from dbo.Categories C
    inner join dbo.Products P on C.CategoryID = P.CategoryID
    inner join dbo.[Order Details] Od on P.ProductID = Od.ProductID
    group by C.CategoryName
    order by sum(Od.Quantity);


-- 4. Dla każdego zamówienia podaj jego wartość uwzględniając opłatę za przesyłkę
select O.OrderID, sum(Od.UnitPrice*Od.Quantity*(1-Od.Discount)) + O.Freight
    from dbo.Orders O
    inner join dbo.[Order Details] Od on Od.OrderID = O.OrderID
    group by O.OrderID, O.Freight;


-- 1. Dla każdego przewoźnika (nazwa) podaj liczbę zamówień które przewieźli w 1997r
select S.ShipperID, S.CompanyName, count(O.OrderID)
    from dbo.Shippers S
    left join Orders O on S.ShipperID = O.ShipVia and year(O.ShippedDate)=1997
    group by S.ShipperID, S.CompanyName


-- 2. Który z przewoźników był najaktywniejszy (przewiózł największą liczbę
-- zamówień) w 1997r, podaj nazwę tego przewoźnika
select top 1 S.ShipperID, S.CompanyName, count(O.OrderID)
    from dbo.Shippers S
    left join Orders O on S.ShipperID = O.ShipVia and year(O.ShippedDate)=1997
    group by S.ShipperID, S.CompanyName
    order by count(O.OrderID) desc

-- 3. Dla każdego pracownika (imię i nazwisko) podaj łączną wartość zamówień
-- obsłużonych przez tego pracownika
select E.FirstName, E.LastName, cast(sum(Od.Quantity*Od.UnitPrice*(1-Od.Discount)) as decimal(10, 2))
    from dbo.Employees E
    inner join dbo.Orders O on E.EmployeeID = O.EmployeeID
    inner join dbo.[Order Details] Od on Od.OrderID = O.OrderID
    group by E.FirstName, E.LastName
    order by E.FirstName, E.LastName;


-- 4. Który z pracowników obsłużył największą liczbę zamówień w 1997r, podaj imię i
-- nazwisko takiego pracownika
select top 1 E.FirstName, E.LastName, count(O.OrderID)
    from dbo.Employees E
    inner join dbo.Orders O on E.EmployeeID = O.EmployeeID
    where year(O.OrderDate)=1997
    group by E.FirstName, E.LastName
    order by count(O.OrderID) desc;


-- 5. Który z pracowników obsłużył najaktywniejszy (obsłużył zamówienia o
-- największej wartości) w 1997r, podaj imię i nazwisko takiego pracownika
select top 1 E.FirstName, E.LastName, cast(sum(Od.Quantity*Od.UnitPrice*(1-Od.Discount)) as decimal(10, 2))
    from dbo.Employees E
    inner join dbo.Orders O on E.EmployeeID = O.EmployeeID
    inner join dbo.[Order Details] Od on Od.OrderID = O.OrderID
    where year(O.OrderDate)=1997
    group by E.FirstName, E.LastName
    order by cast(sum(Od.Quantity*Od.UnitPrice*(1-Od.Discount)) as decimal(10, 2)) desc;


-- 1.
-- Dla każdego pracownika (imię i nazwisko) podaj łączną wartość zamówień
-- obsłużonych przez tego pracownika
-- – Ogranicz wynik tylko do pracowników
-- a) którzy mają podwładnych

select distinct E.FirstName, E.LastName, sum(Od.UnitPrice*Od.Quantity*(1-Od.Discount))
    from dbo.Employees E
    inner join dbo.Orders O on E.EmployeeID = O.EmployeeID
    inner join dbo.[Order Details] Od on O.OrderID = Od.OrderID
    left join dbo.Employees Ep on E.EmployeeID = Ep.ReportsTo
        where Ep.EmployeeID is not null
    group by E.FirstName, E.LastName, Ep.EmployeeID
    order by E.FirstName

-- Andrew - 166537.75497817993

-- b) którzy nie mają podwładnych

select E.FirstName, E.LastName, sum(Od.UnitPrice*Od.Quantity*(1-Od.Discount))
    from dbo.Employees E
    inner join dbo.Orders O on E.EmployeeID = O.EmployeeID
    inner join dbo.[Order Details] Od on O.OrderID = Od.OrderID
    left join dbo.Employees Ep on E.EmployeeID = Ep.ReportsTo
        where Ep.EmployeeID is null
    group by E.FirstName, E.LastName
