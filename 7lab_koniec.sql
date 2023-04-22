

-- 1. Poćwiczyć konwersję data-napis-liczba
-- 2. Wypisać przydatne funkcje zewnętrzne
-- 3. Przygotować sobie wykres bazy northwind oraz library
-- 4. Kupić pyszne czekoladowe ciasteczko


-- podaj nazwy klientów którzy w marcu 1997 nie skladali zamówień
select C.CustomerID
    from dbo.Customers C
    left join Orders O on C.CustomerID = O.CustomerID and year(O.OrderDate)=1997
    where O.OrderDate is null;

--
select C.CustomerID
    from dbo.Customers C
except
select C.CustomerID
    from dbo.Orders O
    inner join Customers C on O.CustomerID = C.CustomerID
    where year(O.OrderDate)=1997;

--
select C.CustomerID
    from dbo.Customers C
    where C.CustomerID not in (select O.CustomerID
                                   from dbo.Orders O
                                    where year(O.OrderDate)=1997);



-- podaj nazwy klientów ktorym w marcu 1997 przesyłek nie przewoziła firma united package

select C.CustomerID
    from dbo.Customers C
    left join Orders O on C.CustomerID = O.CustomerID and year(O.OrderDate)=1997 and month(O.OrderDate)=3
    left join Shippers S on O.ShipVia = S.ShipperID and S.CompanyName='United Package'
    group by C.CustomerID
    having count(S.CompanyName)=0 or count(O.OrderDate)=0;

--
select C.CustomerID
    from dbo.Customers C
    where C.CustomerID not in (select distinct O.CustomerID
                                   from dbo.Orders O
                                    inner join Shippers S on S.ShipperID = O.ShipVia
                                    where year(O.OrderDate)=1997 and month(O.OrderDate)=3 and S.CompanyName='United Package');

--
select C.CustomerID
    from dbo.Customers C
except
    select O.CustomerID
        from dbo.Orders O
        inner join Shippers S on S.ShipperID = O.ShipVia
    where S.CompanyName='United Package' and year(O.OrderDate)=1997 and month(O.OrderDate)=3;

-- podaj nawy klientów którzy w marcu 1997 nie kupowali produków z kategorii confections

select C.CustomerID
    from Customers C
    where C.CustomerID not in (select O.CustomerID
                                   from dbo.Orders O
                                   inner join dbo.[Order Details] Od on O.OrderID = Od.OrderID
                                   inner join Products P on Od.ProductID = P.ProductID
                                   inner join Categories C2 on P.CategoryID = C2.CategoryID
                                   where C2.CategoryName='confections' and year(O.OrderDate)=1997 and month(O.OrderDate)=3);

select C.CustomerID--, O.OrderID, O.OrderDate, P.ProductName, C2.CategoryName
    from dbo.Customers C
    left join dbo.Orders O on C.CustomerID = O.CustomerID and year(O.OrderDate)=1997 and month(O.OrderDate)=3
    left join dbo.[Order Details] Od on O.OrderID = Od.OrderID
    left join dbo.Products P on P.ProductID = Od.ProductID
    left join Categories C2 on P.CategoryID = C2.CategoryID and C2.CategoryName='confections'
    group by C.CustomerID
    having count(O.OrderDate)=0 or count(C2.CategoryName)=0;


select C.CustomerID
    from dbo.Customers C
except
    select C.CustomerID
        from dbo.Customers C
        inner join dbo.Orders O on C.CustomerID = O.CustomerID
        inner join dbo.[Order Details] Od on O.OrderID = Od.OrderID
        inner join dbo.Products P on P.ProductID = Od.ProductID
        inner join dbo.Categories C2 on C2.CategoryID = P.CategoryID
        where year(O.OrderDate)=1997 and month(O.OrderDate)=3 and C2.CategoryName='confections';

select * from dbo.Customers;


-- Podaj nazwy produktów które w marcu 1997 nie były kupowane przez klientów z Francji.
-- Dla każdego takiego produktu podaj jego nazwę, nazwę kategorii do której należy ten produkt oraz jego cenę.
select distinct P.ProductName, C.CategoryName, P.UnitPrice
    from dbo.Products P
    inner join dbo.Categories C on C.CategoryID = P.CategoryID
    inner join [Order Details] Od on P.ProductID = Od.ProductID
    left join dbo.Orders O on O.OrderID = Od.OrderID and year(O.OrderDate)=1997 and month(O.OrderDate)=3
    left join Customers C2 on O.CustomerID = C2.CustomerID and C2.Country='France'
    group by P.ProductName, C.CategoryName, P.UnitPrice
        having count(C2.CustomerID)=0 or count(O.OrderID)=0;


select P.ProductName, C.CategoryName, P.UnitPrice
    from dbo.Products P
    inner join dbo.Categories C on C.CategoryID = P.CategoryID
    where P.ProductID not in (select Od.ProductID
                              from dbo.[Order Details] Od
                                where Od.OrderID in (select O.OrderID
                                                         from dbo.Orders O
                                                            inner join Customers C2 on O.CustomerID = C2.CustomerID
                                                                where (year(O.OrderDate)=1997 and month(O.OrderDate)=3 and C2.Country='France')
                                                                        ) );


select P.ProductName, P.UnitPrice, C.CategoryName
    from dbo.Products P
    inner join dbo.Categories C on C.CategoryID = P.CategoryID
    inner join dbo.[Order Details] Od on P.ProductID = Od.ProductID
    left join Orders O on Od.OrderID = O.OrderID and year(O.OrderDate)=1997 and month(O.OrderDate)=3
    left join Customers C2 on O.CustomerID = C2.CustomerID and C2.Country='France'
    group by P.ProductName, P.UnitPrice, C.CategoryName
    having count(C2.Country)=0 or count(O.OrderDate)=0;


select P.ProductName, P.UnitPrice, C.CategoryID
    from dbo.Products P
    inner join Categories C on P.CategoryID = C.CategoryID
    where P.ProductID not in (select Od.ProductID
                                  from dbo.[Order Details] Od
                                    inner join dbo.Orders O on O.OrderID = Od.OrderID
                                    inner join dbo.Customers C on O.CustomerID = C.CustomerID
                                    where year(O.OrderDate)=1997 and month(O.OrderDate)=3 and C.Country='France');


select P.ProductName, P.UnitPrice, C.CategoryName
    from dbo.Products P
    inner join dbo.Categories C on C.CategoryID = P.CategoryID

    except

select P.ProductName, P.UnitPrice, C.CategoryName
    from dbo.Products P
    inner join dbo.Categories C on C.CategoryID = P.CategoryID
    inner join dbo.[Order Details] Od on Od.ProductID = P.ProductID
    inner join Orders O on Od.OrderID = O.OrderID
    inner join dbo.Customers C2 on O.CustomerID = C2.CustomerID
    where C2.Country='France' and year(O.OrderDate)=1997 and month(O.OrderDate)=3;


select * from Customers;

-- Podaj nazwy produktów z kategorii confection, które w marcu 1997 nie były kupowane przez klientów z Francji.
-- Dla każdego takiego produktu podaj jego nazwę, nazwę kategorii do której należy ten produkt oraz jego cenę.

select P.ProductName
    from dbo.Products P
    inner join dbo.Categories C on C.CategoryID = P.CategoryID
    inner join dbo.[Order Details] Od on P.ProductID = Od.ProductID
    left join Orders O on Od.OrderID = O.OrderID and year(O.OrderDate)=1997 and month(O.OrderDate)=3
    left join Customers C2 on O.CustomerID = C2.CustomerID and C2.Country='France'
        where C.CategoryName='confections'
    group by P.ProductName
    having count(O.OrderDate)=0 or count(C2.Country)=0;

--
select P.ProductName
    from dbo.Products P
    inner join dbo.Categories C on C.CategoryID = P.CategoryID
    where C.CategoryName='confections' and P.ProductID not in (select Od.ProductID
                                                                   from dbo.[Order Details] Od
                                                                   inner join dbo.Orders O on O.OrderID = Od.OrderID
                                                                    inner join Customers C2 on O.CustomerID = C2.CustomerID
                                                                   where year(O.OrderDate)=1997 and month(O.OrderDate)=3 and C2.Country='France');

--
select P.ProductName
    from dbo.Products P
    inner join Categories C on P.CategoryID = C.CategoryID
    where C.CategoryName='confections'

except

    select P.ProductName
        from dbo.Products P
        inner join dbo.Categories C2 on C2.CategoryID = P.CategoryID
        inner join dbo.[Order Details] "[O D]" on P.ProductID = "[O D]".ProductID
        inner join dbo.Orders O on O.OrderID = "[O D]".OrderID
        inner join Customers C3 on O.CustomerID = C3.CustomerID
        where year(O.OrderDate)=1997 and month(O.OrderDate)=3 and C2.CategoryName='confections' and C3.Country='France';


-- Wyświetl nazwy produktów, kupionych między '1997-02-01' i '1997-05-01' przez co najmniej 6 różnych klientów

select P.ProductName
    from dbo.Products P
    inner join dbo.[Order Details] Od on Od.ProductID = P.ProductID
    inner join Orders O on Od.OrderID = O.OrderID
    inner join Customers C on O.CustomerID = C.CustomerID
    where O.OrderDate between '1997-02-01' and '1997-05-01'
    group by P.ProductName
    having count(C.CustomerID) >= 6


-- Dla każdego dorosłego czytelnika podaj sumę kar zapłaconych za
-- przetrzymywanie książek przez jego dzieci
-- interesują nas czytelnicy którzy mają dzieci


select j.adult_member_no, m.firstname, m.lastname, isnull(sum(fine_paid), 0)
    from juvenile j
    inner join loanhist l on j.member_no = l.member_no
    inner join adult a on a.member_no = j.adult_member_no
    inner join member m on m.member_no = a.member_no
    group by j.adult_member_no, m.firstname, m.lastname;

select m.member_no, m.firstname, m.lastname
    from member m
    where m.member_no = 115;

select j.member_no, j.adult_member_no
    from juvenile j
        where j.adult_member_no = 115;

select sum(l.fine_paid)
    from loanhist l
    where l.member_no in (116, 9620, 8638, 7240);

-- Podaj wartość sprzedanych produktów w każdym roku w latach 1995 do 1999

select P.ProductName, sum(Od.UnitPrice*Od.Quantity*(1-Od.Discount))
    from dbo.Products P
    left join dbo.[Order Details] Od on Od.ProductID = P.ProductID
    left join Orders O on Od.OrderID = O.OrderID
    where year(O.OrderDate) between 1995 and 1999
    group by P.ProductName;

select P.ProductName, sum(Od.UnitPrice*Od.Quantity*(1-Od.Discount))
    from dbo.Products P
    inner join dbo.[Order Details] Od on Od.ProductID = P.ProductID
    inner join Orders O on Od.OrderID = O.OrderID
    where year(O.OrderDate) between 1995 and 1999
    group by P.ProductName;


