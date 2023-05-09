
-- 1)
-- Podaj listę dzieci będących członkami biblioteki, które w dniu '2001-12-14' zwróciły do biblioteki
-- książkę o tytule 'Walking'


select *
    from loanhist l
    inner join juvenile j on l.member_no = j.member_no
    inner join adult a on a.member_no = j.adult_member_no
    inner join title t on t.title_no = l.title_no
    where a.expr_date < getdate() and t.title='Walking' and datediff(day, cast('2001-12-14' as date), l.in_date)=0;

select * from loanhist l
    inner join juvenile j on j.member_no = l.member_no;


-- 2)
-- Pokaż nazwy produktów, które nie by z kategorii 'Beverages' które nie były kupowane w
-- okresie od '1997.02.20' do '1997.02.25'. Dla każdego takiego produktu podaj jego nazwę,
-- nazwę dostawcy (supplier), oraz nazwę kategorii.
-- Zbiór wynikowy powinien zawierać nazwę produktu, nazwę dostawcy oraz nazwę kategorii

select P.ProductName, O.OrderID, O.OrderDate, S.CompanyName
    from dbo.Products P
    inner join dbo.Categories C on C.CategoryID = P.CategoryID
    inner join dbo.[Order Details] Od on P.ProductID = Od.ProductID
    left join dbo.Orders O on O.OrderID = Od.OrderID and O.OrderDate between cast('1997-02-20' as date) and cast('1997-02-25' as date)
    left join Shippers S on S.ShipperID = O.ShipVia

select distinct P.ProductName, C.CategoryName, S.CompanyName
    from dbo.Products P
    inner join dbo.Categories C on C.CategoryID = P.CategoryID
    inner join dbo.[Order Details] Od on P.ProductID = Od.ProductID
    inner join dbo.Orders O on O.OrderID = Od.OrderID
    inner join dbo.Suppliers S on S.SupplierID = P.SupplierID
    where P.ProductID not in (select P2.ProductID
                                  from dbo.Products P2
                                        inner join dbo.Categories C2 on C2.CategoryID = P2.CategoryID
                                        inner join dbo.[Order Details] Od2 on P2.ProductID = Od2.ProductID
                                        inner join dbo.Orders O2 on O2.OrderID = Od2.OrderID
                                        where (O2.OrderDate between cast('1997-02-20' as date) and cast('1997-02-25' as date))
                                            or C2.CategoryName='Beverages');

select P.ProductName, C.CategoryName, S.CompanyName
    from dbo.Products P
    inner join dbo.Suppliers S on S.SupplierID = P.SupplierID
    inner join dbo.Categories C on C.CategoryID = P.CategoryID
    inner join dbo.[Order Details] Od on P.ProductID = Od.ProductID
    left join Orders O on Od.OrderID = O.OrderID and O.OrderDate between cast('1997-02-20' as date) and cast('1997-02-25' as date)
    group by P.ProductName, C.CategoryName, S.CompanyName
    having count(O.OrderDate)=0 and C.CategoryName!='Beverages';

-- 3)
-- Podaj liczbę̨ zamówień oraz wartość zamówień (uwzględnij opłatę za przesyłkę) obsłużonych
-- przez każdego pracownika w lutym 1997. Za datę obsłużenia zamówienia należy uznać datę
-- jego złożenia (orderdate). Jeśli pracownik nie obsłużył w tym okresie żadnego zamówienia, to
-- też powinien pojawić się na liście (liczba obsłużonych zamówień oraz ich wartość jest w takim
-- przypadku równa 0).
-- Zbiór wynikowy powinien zawierać: imię i nazwisko pracownika, liczbę obsłużonych
-- zamówień, wartość obsłużonych zamówień


select T.id, T.name, T.lname, isnull(count(T.oid), 0), isnull(cast(sum(T.osum) as decimal(10, 2)), 0)
    from (select E.EmployeeID                                                                           as id,
                 E.FirstName                                                                            as name,
                 E.LastName                                                                             as lname,
                 O.OrderID                                                                              as oid,
                 (sum(Od.Quantity * Od.UnitPrice * (1 - Od.Discount)) + (select sum(O2.Freight)
                                                                         from dbo.Employees E2
                                                                                  inner join dbo.Orders O2 on E2.EmployeeID = O2.EmployeeID
                                                                         where O2.OrderID = O.OrderID and E.EmployeeID=E2.EmployeeID)) as osum
          from dbo.Employees E
                   left join dbo.Orders O
                             on E.EmployeeID = O.EmployeeID and year(O.OrderDate) = 1997 and month(O.OrderDate) = 2
                   left join dbo.[Order Details] Od on O.OrderID = Od.OrderID
          group by E.EmployeeID, E.FirstName, E.LastName, O.OrderID) T
    group by T.id, T.name, T.lname
    order by count(T.oid);

select T.id, T.name, T.lname, isnull(count(T.oid), 0), isnull(cast(sum(T.osum) as decimal(10, 2)), 0)
    from (select E.EmployeeID                                                                           as id,
                 E.FirstName                                                                            as name,
                 E.LastName                                                                             as lname,
                 O.OrderID                                                                              as oid,
                 (sum(Od.Quantity * Od.UnitPrice * (1 - Od.Discount)) + (select O2.Freight
                                                                         from dbo.Employees E2
                                                                                  inner join dbo.Orders O2 on E2.EmployeeID = O2.EmployeeID
                                                                         where O2.OrderID = O.OrderID and E.EmployeeID=E2.EmployeeID)) as osum
          from dbo.Employees E
                   left join dbo.Orders O
                             on E.EmployeeID = O.EmployeeID and year(O.OrderDate) = 1997 and month(O.OrderDate) = 2
                   left join dbo.[Order Details] Od on O.OrderID = Od.OrderID
          group by E.EmployeeID, E.FirstName, E.LastName, O.OrderID) T
    group by T.id, T.name, T.lname
    order by count(T.oid);



select E.EmployeeID, E.FirstName as name, E.LastName as lname, count(distinct O.OrderID) as amount
    from dbo.Employees E
      left join dbo.Orders O on E.EmployeeID = O.EmployeeID and year(O.OrderDate) = 1997 and month(O.OrderDate) = 2
      group by E.EmployeeID, E.FirstName, E.LastName
        order by amount


-- 1)
-- Podaj listę dzieci będących członkami biblioteki, dla każdego z tych dzieci podaj:
-- Imię, nazwisko, imię rodzica (opiekuna), nazwisko rodzica (opiekuna)
select mj.firstname, mj.lastname, m.firstname, m.lastname, j.adult_member_no, m.member_no
    from juvenile j
    inner join adult a on a.member_no = j.adult_member_no
    inner join member m on m.member_no = a.member_no
    inner join member mj on mj.member_no = j.member_no
    where a.expr_date < getdate()
    order by m.member_no;



-- 2)
-- Wyświetl wszystkich pracowników, którzy nie mają podwładnych. Dla każdego z takich
-- pracowników podaj wartość obsłużonych przez niego zamówień w 1997r (sama wartość
-- zamówień bez opłaty za przesyłkę)

select distinct T.name, T.lname, cast(T.sum as decimal(10, 2))
    from (select E.EmployeeID as id, E.FirstName as name, E.LastName as lname, sum(Od.UnitPrice * Od.Quantity * (1 - Od.Discount)) as sum
          from dbo.Employees E
                   inner join dbo.Orders O on E.EmployeeID = O.EmployeeID
                   inner join dbo.[Order Details] Od on O.OrderID = Od.OrderID
          group by E.EmployeeID, E.FirstName, E.LastName) T
    left join dbo.Employees E2 on T.id = E2.ReportsTo
    where E2.FirstName is not null


-- 3)
-- Wyświetl nr zamówień złożonych w marcu 1997, które nie zawierały produktów z kategorii
-- "confections"

select O.OrderID
    from dbo.Orders O
    where year(O.OrderDate)=1997 and month(O.OrderDate)=3 and O.OrderID not in (select Od.OrderID
                                                                                    from dbo.[Order Details] Od
                                                                                        inner join dbo.Products P on P.ProductID = Od.ProductID
                                                                                        inner join dbo.Categories C on C.CategoryID = P.CategoryID
                                                                                        where C.CategoryName='confections');


-- Podaj listę wszystkich dorosłych, którzy mieszkają w Arizonie i mają dwójkę dzieci zapisanych do biblioteki oraz listę dorosłych,
-- mieszkających w Kalifornii  i mają 3 dzieci.
-- Dla każdej z tych osób podaj liczbę książek przeczytanych w grudniu 2001 przez tę osobę i jej dzieci.
-- (Arizona - 'AZ', Kalifornia - 'CA')

select T.aid, T.name, T.lname, (select count(in_date)
                                    from loan l
                                    inner join loanhist lh on lh.out_date = l.out_date and l.copy_no = lh.copy_no and l.isbn = lh.isbn
                                    where ((year(l.out_date)=2001) and month(l.out_date)=12 and year(lh.in_date)=2001 and month(lh.in_date)=12)
                                      and ((lh.member_no = T.aid) or (lh.member_no in (select j2.member_no
                                                                                           from juvenile j2
                                                                                           where j2.adult_member_no = T.aid)))
                                        )
    from (select a.member_no        as aid,
                 m.firstname        as name,
                 m.lastname         as lname,
                 a.state            as state,
                 count(j.member_no) as bab
          from adult a
                   inner join juvenile j on j.adult_member_no = a.member_no
                   inner join member m on m.member_no = a.member_no
          group by a.member_no, m.firstname, m.lastname, a.state
          having (count(j.member_no) = 2 and a.state = 'AZ')
              or (count(j.member_no) = 3 and a.state = 'CA')) T;



-- 1 Imie nazwisko i adres czytelnika, ile książek wypożyczył aktualnie. Jesli żadnej to też ma sie pojawić
select m.firstname, m.lastname, a.street, a.city, a.state, count(l.out_date)
    from member m
    inner join adult a on m.member_no = a.member_no
    left join loan l on l.member_no = m.member_no
    group by m.member_no, m.firstname, m.lastname, a.street, a.city, a.state
union all

select m.firstname, m.lastname, a.street, a.city, a.state, count(l.out_date)
    from member m
    inner join juvenile j on j.member_no = m.member_no
    inner join adult a on a.member_no = j.adult_member_no
    left join loan l on l.member_no = m.member_no
    group by m.member_no, m.firstname, m.lastname, a.street, a.city, a.state;



-- 2 Liczba i ilość zamówień dla każdego klienta w lutym 1997. Jeśli nie składał, też ma być na liście

select C.CustomerID, C.CompanyName, count(O.OrderID)
    from dbo.Customers C
    left join dbo.Orders O on C.CustomerID = O.CustomerID and year(O.OrderDate)=1997 and month(O.OrderDate)=2
    group by C.CustomerID, C.CompanyName;



-- 3. Klienci którzy nigdy nie zamówili produktu z kat. 'Seafood'

select C.CustomerID, C.CompanyName
    from dbo.Customers C
    where C.CustomerID not in (select O.CustomerID
                                   from dbo.Orders O
                                    inner join dbo.[Order Details] Od on O.OrderID = Od.OrderID
                                    inner join dbo.Products P on P.ProductID = Od.ProductID
                                    inner join dbo.Categories C2 on C2.CategoryID = P.CategoryID
                                    where C2.CategoryName='Seafood')

select O.OrderID, C.CategoryName
    from dbo.Products P
    inner join dbo.Categories C on C.CategoryID = P.CategoryID
    inner join dbo.[Order Details] Od on P.ProductID = Od.ProductID
    left join Orders O on Od.OrderID = O.OrderID and C.CategoryName='Seafood';


select C.CustomerID, C.CompanyName
    from dbo.Customers C
    left join Orders O on C.CustomerID = O.CustomerID
    left join  dbo.[Order Details] Od on O.OrderID = Od.OrderID
    left join dbo.Products P on P.ProductID = Od.ProductID
    left join Categories C2 on P.CategoryID = C2.CategoryID and C2.CategoryName='Seafood'
    group by C.CustomerID, C.CompanyName
    having count(C2.CategoryName)=0 or count(O.OrderID)=0;

select * from dbo.Customers;



-- 1. Imiona i nazwiska pacowników, którzy mają podwładnych oraz mają przełożonych

select distinct E.FirstName, E.LastName
    from dbo.Employees E
    left join dbo.Employees Ep on E.EmployeeID = Ep.ReportsTo
    where Ep.FirstName is not null and E.EmployeeID not in (select E2.EmployeeID
                                                  from dbo.Employees E2
                                                    where E2.ReportsTo is null);


select distinct E.FirstName, E.LastName
    from dbo.Employees E
    left join dbo.Employees Ep on E.EmployeeID = Ep.ReportsTo
    where E.ReportsTo is not null and Ep.EmployeeID is not null;

-- 2. Dla każdego przewoźnika wyświetl nazwy klientów, których zamówienia miały opóźnienie
select distinct S.CompanyName, C.CompanyName
    from dbo.Orders O
    inner join Shippers S on O.ShipVia = S.ShipperID
    inner join Customers C on O.CustomerID = C.CustomerID
    where O.RequiredDate < O.ShippedDate;


-- 3. Wyświetl listę dzieci, które mają przeterminowane wypożyczenia (imiona i nazwiska)

select distinct m.member_no, m.firstname, m.lastname
    from juvenile j
    inner join member m on j.member_no = m.member_no
    inner join loan l on l.member_no = m.member_no
    where l.due_date < getdate();
















