

-- 1)
-- Podaj listę dzieci będących członkami biblioteki, które w dniu '2001-12-14'
-- zwróciły do biblioteki książkę o tytule 'Walking'. Zbiór wynikowy powinien
-- zawierać imię i nazwisko oraz dane adresowe dziecka. (baza library)

select m.firstname, m.lastname, a.street, a.city,a.state
    from juvenile j
    inner join member m on m.member_no = j.member_no
    inner join loanhist lh on lh.member_no = j.member_no
    inner join title t on t.title_no = lh.title_no
    left join adult a on a.member_no = j.adult_member_no
    where year(lh.in_date)=2001 and month(lh.in_date)=12 and day(lh.in_date)=14 and t.title='Walking';



--
-- 2)
-- Podaj nazwy produktów należących do kategorii 'Dairy Products',
-- które w marcu 1997 nie były kupowane przez klientów z Francji.
-- Dla każdego takiego produktu podaj jego nazwę, cenę, oraz nazwę
-- dostawcy (dostawcy to suppliers). Zbiór wynikowy powinien zawierać
-- nazwę produktu, cenę, nazwę dostawcy. Zbiór wynikowy powinien być
-- uporządkowany wg nazwy produktu. (baza northwind)

select distinct P.ProductName, cast(P.UnitPrice as decimal(10, 2)), S.CompanyName
    from Products P
    inner join Categories C on C.CategoryID = P.CategoryID
    inner join Suppliers S on S.SupplierID = P.SupplierID
    inner join [Order Details] Od on P.ProductID = Od.ProductID
    left join Orders O on Od.OrderID = O.OrderID and year(O.OrderDate)=1997 and month(O.OrderDate)=3
    where C.CategoryName='Dairy Products' and
       P.ProductID not in (select P2.ProductID
                                from Orders O2
                                inner join Customers C2 on O2.CustomerID = C2.CustomerID
                                inner join [Order Details] Od2 on O2.OrderID = Od2.OrderID
                                inner join Products P2 on Od2.ProductID = P2.ProductID
                                where C2.Country='France' and year(O2.OrderDate)=1997 and month(O2.OrderDate)=3)
    order by P.ProductName;



-- 3)
-- Podaj liczbę̨ zamówień oraz wartość zamówień (uwzględnij opłatę za przesyłkę)
-- obsłużonych przez każdego pracownika w lutym 1997. Za datę obsłużenia zamówienia
-- należy uznać datę jego złożenia (orderdate). Jeśli pracownik nie obsłużył w
-- tym okresie żadnego zamówienia, to też powinien pojawić się na liście
-- (liczba obsłużonych zamówień oraz ich wartość jest w takim przypadku równa 0).
-- Zbiór wynikowy powinien zawierać: imię i nazwisko pracownika,
-- liczbę obsłużonych zamówień, wartość obsłużonych zamówień. (baza northwind)


select T.name, T.lname, count(T.oid), isnull(cast(sum(T.osam) as decimal(10, 2)), 0)
    from (select E.EmployeeID as eid,
                 E.FirstName  as name,
                 E.LastName   as lname,
                 O.OrderID    as oid,
                 sum(Od.UnitPrice * Od.Quantity * (1 - Od.Discount)) + O.Freight as osam
          from dbo.Employees E
                   left join dbo.Orders O
                             on E.EmployeeID = O.EmployeeID and year(O.OrderDate) = 1997 and month(O.OrderDate) = 2
                   left join dbo.[Order Details] Od on O.OrderID = Od.OrderID
          group by E.EmployeeID, E.FirstName, E.LastName, O.OrderID, O.Freight) T
    group by T.eid, T.name, T.lname
    order by count(T.oid);













