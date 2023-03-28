

--  Dla każdego klienta podaj liczbę zamówień w każdym z lat 1997, 98
select O.CustomerID, count(OrderID)
    from Customers
    left join Orders O on Customers.CustomerID = O.CustomerID
        and (year(O.OrderDate)=1997 or year(O.OrderDate)=1998)
    group by O.CustomerID


--  Dla każdego klienta podaj liczbę zamówień w każdym z miesięcy 1997, 98
select O.CustomerID, year(O.OrderDate) as year, month(O.OrderDate) as month, count(OrderID)
    from Customers
    left join Orders O on Customers.CustomerID = O.CustomerID
        and (year(O.OrderDate)=1997 or year(O.OrderDate)=1998)
    group by O.CustomerID, year(O.OrderDate), month(O.OrderDate)
    order by O.CustomerID;

select C.CustomerID, year(O.OrderDate)
    from Customers as C
    inner join Orders O on C.CustomerID = O.CustomerID
        where C.CustomerID='ALFKI'


-- Wybierz nazwy i numery telefonów klientów, którzy kupowali produkty z kategorii ‘Confections’
select distinct C.CompanyName, Ctg.CategoryName
    from Customers as C
    inner join Orders O on C.CustomerID = O.CustomerID
    inner join [Order Details] Od on O.OrderID = Od.OrderID
    inner join Products P on P.ProductID = Od.ProductID
    inner join Categories Ctg on Ctg.CategoryID = P.CategoryID
     where Ctg.CategoryName='Confections'


--  Wybierz nazwy i numery telefonów klientów, którzy nie kupowali produków z kategorii ‘Confections’
select distinct C.CustomerID, C.CompanyName, C.Phone, count(Ctg.CategoryName)
    from Customers as C
    left join Orders O on C.CustomerID = O.CustomerID
    left join [Order Details] Od on O.OrderID = Od.OrderID
    left join Products P on P.ProductID = Od.ProductID
    left join Categories Ctg on Ctg.CategoryID = P.CategoryID and (Ctg.CategoryName='Confections' or O.OrderDate is null)
    group by C.CustomerID, C.CompanyName, C.Phone
        having count(Ctg.CategoryName)=0
    order by C.CompanyName


-- Wybierz nazwy i numery telefonów klientów, którzy w 1997 kupowali produkty z kategorii ‘Confections’
select distinct C.CompanyName, Ctg.CategoryName
    from Customers as C
    inner join Orders O on C.CustomerID = O.CustomerID
    inner join [Order Details] Od on O.OrderID = Od.OrderID
    inner join Products P on P.ProductID = Od.ProductID
    inner join Categories Ctg on Ctg.CategoryID = P.CategoryID
     where Ctg.CategoryName='Confections' and year(O.OrderDate)=1997;


--  Wybierz nazwy i numery telefonów klientów, którzy w 1997 nie kupowali produków z kategorii ‘Confections’
select distinct C.CustomerID, C.CompanyName, Ctg.CategoryName, year(O.OrderDate) as rok, count(Ctg.CategoryName)
    from Customers as C
    left join Orders O on C.CustomerID = O.CustomerID and year(O.OrderDate)=1997
    left join [Order Details] Od on O.OrderID = Od.OrderID
    left join Products P on P.ProductID = Od.ProductID
    left join Categories Ctg on Ctg.CategoryID = P.CategoryID and Ctg.CategoryName='Confections'
    group by C.CustomerID, C.CompanyName, Ctg.CategoryName, year(O.OrderDate)
        having count(Ctg.CategoryName)=0 or year(O.OrderDate) is null;

-- Ma wyjść 89 - 68 = 31


