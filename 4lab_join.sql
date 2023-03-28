
-- 1. Wybierz nazwy i ceny produktów (baza northwind) o cenie jednostkowej
-- pomiędzy 20.00 a 30.00, dla każdego produktu podaj dane adresowe dostawcy
select  S.CompanyName, S.Address, S.City, S.Region, S.PostalCode, S.PostalCode, ProductName, P.UnitPrice
    from Products as P
    inner join Suppliers S on P.SupplierID = S.SupplierID
    where P.UnitPrice between 20 and 30
    order by P.UnitPrice;

-- 2. Wybierz nazwy produktów oraz inf. o stanie magazynu dla produktów
-- dostarczanych przez firmę ‘Tokyo Traders’
select ProductName, P.UnitsInStock
    from Products as P
    inner join Suppliers S on P.SupplierID = S.SupplierID
    where S.CompanyName='Tokyo Traders'

-- 3. Czy są jacyś klienci którzy nie złożyli żadnego zamówienia w 1997 roku, jeśli tak
-- to pokaż ich dane adresowe
-- C.Address, C.City, C.Region, C.PostalCode, C.Country,
select distinct C.CompanyName, C.CustomerID, C.Address, C.City, C.Region, C.PostalCode, C.Country
    from Customers as C
    where C.CustomerID not in (select O.CustomerID from Orders O where year(O.OrderDate)='1997')
                        -- left outer join Orders as O on C.CustomerID = O.CustomerID
                        -- where year(O.OrderDate)='1997')

select C.CompanyName, C.CustomerID, C.Address, C.City, C.Region, C.PostalCode, C.Country
    from Customers as C
    left join Orders O on C.CustomerID = O.CustomerID and year(O.OrderDate)=1997
        where OrderID is null



select C.CompanyName, O.OrderDate, O.CustomerID
    from Customers as C
    left outer join Orders as O on C.CustomerID = O.CustomerID
    where (year(OrderDate)=1997) and C.CustomerID='FISSA';


-- 4. Wybierz nazwy i numery telefonów dostawców, dostarczających produkty,
-- których aktualnie nie ma w magazynie
select Suppliers.CompanyName, Suppliers.Phone, P.UnitsInStock
    from Suppliers
    inner join Products P on Suppliers.SupplierID = P.SupplierID
    where P.UnitsInStock=0;


-- 1. Napisz polecenie, które wyświetla listę dzieci będących członkami biblioteki (baza
-- library). Interesuje nas imię, nazwisko i data urodzenia dziecka.
select j.birth_date, m.firstname, m.lastname
    from juvenile as j
    inner join member as m on j.member_no = m.member_no

-- 2. Napisz polecenie, które podaje tytuły aktualnie wypożyczonych książek
select distinct t.title
    from copy as c
    inner join title t on c.title_no = t.title_no
    where c.on_loan='Y';

-- 3. Podaj informacje o karach zapłaconych za przetrzymywanie książki o tytule ‘Tao
-- Teh King’. Interesuje nas data oddania książki, ile dni była przetrzymywana i jaką
-- zapłacono karę
select t.title, l.in_date, datediff(day, l.in_date, l.due_date), l.fine_paid
    from loanhist as l
    inner join title t on l.title_no = t.title_no
    where t.title='Tao Teh King'
    and fine_paid is not null;

-- 4. Napisz polecenie które podaje listę książek (mumery ISBN) zarezerwowanych
-- przez osobę o nazwisku: Stephen A. Graff
select m.firstname, m.lastname, r.isbn
    from reservation as r
    inner join member m on m.member_no = r.member_no
    where (m.lastname like 'Graff') and (m.firstname like 'Stephen')


-- 1. Wybierz nazwy i ceny produktów (baza northwind) o cenie jednostkowej
-- pomiędzy 20.00 a 30.00, dla każdego produktu podaj dane adresowe dostawcy,
-- interesują nas tylko produkty z kategorii ‘Meat/Poultry’
select ProductName, P.UnitPrice
    from Products as P
    inner join Suppliers S on S.SupplierID = P.SupplierID
    inner join Categories C on C.CategoryID = P.CategoryID
    where (P.UnitPrice between 20 and 30) and (C.CategoryName like 'Meat/Poultry')

select * from Categories where CategoryName like '%Meat%';
select * from Products where CategoryID=6 and UnitPrice between 20 and 30;

-- 2. Wybierz nazwy i ceny produktów z kategorii ‘Confections’ dla każdego produktu
-- podaj nazwę dostawcy.
select S.CompanyName, P.ProductName, P.UnitPrice
    from Products as P
    inner join Categories C on C.CategoryID = P.CategoryID
    inner join Suppliers S on P.SupplierID = S.SupplierID
    where C.CategoryName='Confections'

-- 3. Wybierz nazwy i numery telefonów klientów , którym w 1997 roku przesyłki
-- dostarczała firma ‘United Package’
select S.CompanyName, C.CompanyName, C.Phone
    from Customers as C
    inner join Orders as O on O.CustomerID = C.CustomerID
    inner join Shippers S on S.ShipperID = O.ShipVia
    where year(O.OrderDate)=1997 and S.CompanyName='United Package';

-- 4. Wybierz nazwy i numery telefonów klientów, którzy kupowali produkty z kategorii
-- ‘Confections’
select distinct Cat.CategoryName, C.CompanyName, C.Phone
    from Customers as C
    inner join Orders O on C.CustomerID = O.CustomerID
    inner join [Order Details] "[O D]" on O.OrderID = "[O D]".OrderID
    inner join Products P on P.ProductID = "[O D]".ProductID
    inner join Categories as Cat on P.CategoryID = Cat.CategoryID
    where Cat.CategoryName='Confections';


-- 1. Napisz polecenie, które wyświetla listę dzieci będących członkami biblioteki (baza
-- library). Interesuje nas imię, nazwisko, data urodzenia dziecka i adres
-- zamieszkania dziecka.
select j.birth_date, m.firstname, m.lastname, concat(a.street, ', ', a.city, ', ', a.state) as 'Adres zamieszkania'
    from juvenile as j
    inner join member as m on j.member_no = m.member_no
    inner join adult a on a.member_no = j.adult_member_no


-- 2. Napisz polecenie, które wyświetla listę dzieci będących członkami biblioteki (baza
-- library). Interesuje nas imię, nazwisko, data urodzenia dziecka, adres
-- zamieszkania dziecka oraz imię i nazwisko rodzica.
select j.birth_date, concat(m.firstname, ' ', m.lastname) as 'Dziecko',
       concat(a.street, ', ', a.city, ', ', a.state) as 'Adres zamieszkania',
       concat(m2.firstname, ' ', m2.lastname) as 'Rodzic'
    from juvenile as j
    inner join member as m on j.member_no = m.member_no
    inner join adult a on a.member_no = j.adult_member_no
    inner join member as m2 on a.member_no = m2.member_no


-- 1. Napisz polecenie, które wyświetla pracowników oraz ich podwładnych (baza
-- northwind)
-- IIF(Pracownik.ReportsTo is null, 'On jest szefem' , ,)
select concat(Pracownik.FirstName, ' ', Pracownik.LastName, ' ', Pracownik.EmployeeID) as 'Pracownik',
       concat(Podwladny.FirstName, ' ', Podwladny.LastName, ' ', Podwladny.EmployeeID) as 'Podwladny'
    from Employees as Podwladny
    inner join Employees as Pracownik on Pracownik.EmployeeID = Podwladny.ReportsTo;

-- LUB
select Pr.FirstName, Pr.LastName, Po.FirstName, Po.LastName
    from Employees as Pr
    left outer join Employees as Po on Pr.EmployeeID=Po.ReportsTo


-- To nie działa
select concat(a.FirstName, ' ', a.LastName, ' ', a.EmployeeID) as 'Pracownik',
       concat(b.FirstName, ' ', b.LastName, ' ', b.EmployeeID) as 'Podwladny'
    from Employees as a
    inner join Employees as b on a.EmployeeID=b.EmployeeID
    where b.ReportsTo = a.EmployeeID;


-- 2. Napisz polecenie, które wyświetla pracowników, którzy nie mają podwładnych
-- (baza northwind)
select E.FirstName, E.LastName, E.EmployeeID
    from Employees as E
    where E.EmployeeID not in (select P.ReportsTo
                                from Employees as P
                                    inner join Employees as S on S.EmployeeID = P.ReportsTo)

-- LUB
select Pr.FirstName, Pr.LastName, Pr.EmployeeID, Po.FirstName, Po.LastName
    from Employees as Pr
    left outer join Employees as Po on Pr.EmployeeID=Po.ReportsTo
where Po.FirstName is null


-- 3. Napisz polecenie, które wyświetla adresy członków biblioteki, którzy mają dzieci
-- urodzone przed 1 stycznia 1996
select a.street, a.city, a.state, a.member_no
    from adult as a
    inner join juvenile j on a.member_no = j.adult_member_no
    where j.birth_date<'01/01/1996';


-- 4. Napisz polecenie, które wyświetla adresy członków biblioteki, którzy mają dzieci
-- urodzone przed 1 stycznia 1996. Interesują nas tylko adresy takich członków
-- biblioteki, którzy aktualnie nie przetrzymują książek.
select distinct a.street, a.city, a.state, a.member_no
    from adult as a
    inner join juvenile j on a.member_no = j.adult_member_no
    inner join member m on a.member_no = m.member_no
    left outer join loan l on m.member_no = l.member_no
    where j.birth_date<'01/01/1996' and l.member_no is null;


-- wersja druga (przetrzymywanie jako posiadanie książki a nie tylko niewypożyczenie)
select distinct a.street, a.city, a.state, a.member_no
    from adult as a
    inner join juvenile j on a.member_no = j.adult_member_no
    inner join member m on a.member_no = m.member_no
    inner join loan l on m.member_no = l.member_no
    where j.birth_date<'01/01/1996' and l.due_date > getdate();


-- 1. Napisz polecenie które zwraca imię i nazwisko (jako pojedynczą kolumnę –
-- name), oraz informacje o adresie: ulica, miasto, stan kod (jako pojedynczą
-- kolumnę – address) dla wszystkich dorosłych członków biblioteki
select concat(m.firstname, ' ', m.lastname) as 'name',
       concat(a.street, ' ', a.city, ' ', a.state) as 'address'
    from adult as a
    inner join member m on a.member_no = m.member_no;


-- 2. Napisz polecenie, które zwraca: isbn, copy_no, on_loan, title, translation, cover,
-- dla książek o isbn 1, 500 i 1000. Wynik posortuj wg ISBN
select i.isbn, c.copy_no, c.on_loan, t.title, i.translation, i.cover
    from title as t
    inner join copy c on t.title_no = c.title_no
    inner join item i on c.isbn = i.isbn
    where i.isbn in (1, 500, 1000)
    order by i.isbn;


-- 3. Napisz polecenie które zwraca o użytkownikach biblioteki o nr 250, 342, i 1675
-- (dla każdego użytkownika: nr, imię i nazwisko członka biblioteki), oraz informację
-- o zarezerwowanych książkach (isbn, data)
select m.firstname, m.lastname, r.isbn, r.log_date
    from member as m
    inner join reservation r on m.member_no = r.member_no
    where m.member_no in (250, 342, 1675);

select member_no
    from reservation;

-- 4. Podaj listę członków biblioteki mieszkających w Arizonie (AZ), którzy mają więcej niż
-- dwoje dzieci zapisanych do biblioteki
select j.adult_member_no, a.state, count(*)
    from adult as a
    inner join juvenile j on a.member_no = j.adult_member_no
            where a.state='AZ'
    group by j.adult_member_no, a.state
    having count(*) > 2;


-- 1. Podaj listę członków biblioteki mieszkających w Arizonie (AZ) którzy mają więcej
-- niż dwoje dzieci zapisanych do biblioteki oraz takich którzy mieszkają w Kaliforni
-- (CA) i mają więcej niż troje dzieci zapisanych do biblioteki
select j.adult_member_no, a.state, count(*)
    from adult as a
    inner join juvenile j on a.member_no = j.adult_member_no
    group by j.adult_member_no, a.state
    having (count(*) > 2 and a.state='AZ')
            or (count(*) > 3 and a.state='CA');


-- 1. Dla każdego zamówienia podaj łączną liczbę zamówionych jednostek towaru oraz
-- nazwę klienta.
select O.OrderID, C.CompanyName, sum(Od.quantity)
    from Customers as C
    inner join Orders O on C.CustomerID = O.CustomerID
    inner join [Order Details] Od on O.OrderID = Od.OrderID
    group by O.OrderID, C.CompanyName;


-- 2. Zmodyfikuj poprzedni przykład, aby pokazać tylko takie zamówienia, dla których
-- łączna liczbę zamówionych jednostek jest większa niż 250
select O.OrderID, C.CompanyName, sum(Od.quantity)
    from Customers as C
    inner join Orders O on C.CustomerID = O.CustomerID
    inner join [Order Details] Od on O.OrderID = Od.OrderID
    group by O.OrderID, C.CompanyName
    having sum(Od.Quantity) > 250;



-- 3. Dla każdego zamówienia podaj łączną wartość tego zamówienia oraz nazwę
-- klienta.
select O.OrderID, C.CompanyName, sum(Od.quantity*Od.UnitPrice*(1-Od.Discount)) as wartosc
    from Customers as C
    inner join Orders O on C.CustomerID = O.CustomerID
    inner join [Order Details] Od on O.OrderID = Od.OrderID
    group by O.OrderID, C.CompanyName;


-- 4. Zmodyfikuj poprzedni przykład, aby pokazać tylko takie zamówienia, dla których
-- łączna liczba jednostek jest większa niż 250.
select O.OrderID, C.CompanyName, sum(Od.quantity*Od.UnitPrice*(1-Od.Discount)) as wartosc
    from Customers as C
    inner join Orders O on C.CustomerID = O.CustomerID
    inner join [Order Details] Od on O.OrderID = Od.OrderID
    group by O.OrderID, C.CompanyName
    having sum(Od.Quantity) > 250;

-- 5. Zmodyfikuj poprzedni przykład tak żeby dodać jeszcze imię i nazwisko
-- pracownika obsługującego zamówienie
select O.OrderID, C.CompanyName, E.FirstName, E.LastName, sum(Od.quantity*Od.UnitPrice*(1-Od.Discount)) as wartosc
    from Customers as C
    inner join Orders O on C.CustomerID = O.CustomerID
    inner join [Order Details] Od on O.OrderID = Od.OrderID
    inner join Employees E on O.EmployeeID = E.EmployeeID
    group by O.OrderID, C.CompanyName,  E.FirstName, E.LastName
    having sum(Od.Quantity) > 250;


-- 1. Dla każdej kategorii produktu (nazwa), podaj łączną liczbę zamówionych przez
-- klientów jednostek towarów z tek kategorii.
select C.CategoryID, C.CategoryName, sum(Od.Quantity) as ilosc
    from Products as P
    inner join Categories C on C.CategoryID = P.CategoryID
    inner join [Order Details] Od on Od.ProductID = P.ProductID
    group by C.CategoryID, C.CategoryName;


-- 2. Dla każdej kategorii produktu (nazwa), podaj łączną wartość zamówionych przez
-- klientów jednostek towarów z tej kategorii.
select C.CategoryID, sum(Od.Quantity*Od.UnitPrice*(1-Od.Discount)) as wartosc
    from Products as P
    inner join Categories C on C.CategoryID = P.CategoryID
    inner join [Order Details] Od on Od.ProductID = P.ProductID
    group by C.CategoryID;


-- 3. Posortuj wyniki w zapytaniu z poprzedniego punktu wg:
-- a) łącznej wartości zamówień
select C.CategoryID, sum(Od.Quantity*Od.UnitPrice*(1-Od.Discount)) as wartosc
    from Products as P
    inner join Categories C on C.CategoryID = P.CategoryID
    inner join [Order Details] Od on Od.ProductID = P.ProductID
    group by C.CategoryID
    order by sum(Od.Quantity*Od.UnitPrice*(1-Od.Discount));

-- b) łącznej liczby zamówionych przez klientów jednostek towarów.
select C.CategoryID, sum(Od.Quantity*Od.UnitPrice*(1-Od.Discount)) as wartosc
    from Products as P
    inner join Categories C on C.CategoryID = P.CategoryID
    inner join [Order Details] Od on Od.ProductID = P.ProductID
    group by C.CategoryID
    order by sum(Od.Quantity);


-- 4. Dla każdego zamówienia podaj jego wartość uwzględniając opłatę za przesyłkę
select Od.OrderID, (sum(Od.Quantity*Od.UnitPrice*(1-Od.Discount)) + O.Freight)
    from [Order Details] as Od
    inner join Orders O on Od.OrderID = O.OrderID
    group by Od.OrderID, O.Freight;


-- 1. Dla każdego przewoźnika (nazwa) podaj liczbę zamówień które przewieźli w 1997r
select S.ShipperID, count(*)
    from Orders
    inner join Shippers S on S.ShipperID = Orders.ShipVia
        where year(Orders.ShippedDate)=1997
    group by S.ShipperID;


-- 2. Który z przewoźników był najaktywniejszy (przewiózł największą liczbę
-- zamówień) w 1997r, podaj nazwę tego przewoźnika
select top 1 S.CompanyName
    from Orders
    inner join Shippers S on S.ShipperID = Orders.ShipVia
        where year(Orders.ShippedDate)=1997
    group by S.CompanyName
    order by count(*) desc;

-- 3. Dla każdego pracownika (imię i nazwisko) podaj łączną wartość zamówień
-- obsłużonych przez tego pracownika
select E.FirstName, E.LastName, E.EmployeeID, sum(Od.UnitPrice*Od.Quantity*(1-Od.Discount)) as sum
    from Orders as O
    inner join [Order Details] Od on O.OrderID = Od.OrderID
    inner join Employees E on E.EmployeeID = O.EmployeeID
    group by E.FirstName, E.LastName, E.EmployeeID;


-- 4. Który z pracowników obsłużył największą liczbę zamówień w 1997r, podaj imię i
-- nazwisko takiego pracownika
select top 1 E.FirstName, E.LastName, count(O.OrderID)
    from Orders as O
    inner join Employees E on O.EmployeeID = E.EmployeeID
        where year(O.OrderDate)=1997
    group by E.FirstName, E.LastName
    order by count(*) desc;


-- 5. Który z pracowników obsłużył najaktywniejszy (obsłużył zamówienia o
-- największej wartości) w 1997r, podaj imię i nazwisko takiego pracownika
select top 1 E.FirstName, E.LastName as sum
    from Orders as O
    inner join [Order Details] Od on O.OrderID = Od.OrderID
    inner join Employees E on E.EmployeeID = O.EmployeeID
            where year(O.OrderDate)=1997
    group by E.FirstName, E.LastName
    order by sum(Od.UnitPrice*Od.Quantity*(1-Od.Discount));


-- 1. Dla każdego pracownika (imię i nazwisko) podaj łączną wartość zamówień
--                                                obsłużonych przez tego pracownika
-- Ogranicz wynik tylko do pracowników
-- a) którzy mają podwładnych
select distinct E.FirstName, E.LastName, E.EmployeeID, cast(sum(Od.UnitPrice*Od.Quantity*(1-Od.Discount)) as decimal (10, 2)) as sum
    from Orders as O
    inner join [Order Details] Od on O.OrderID = Od.OrderID
    inner join Employees E on E.EmployeeID = O.EmployeeID
    left outer join Employees as Ep on E.EmployeeID = Ep.ReportsTo
            where Ep.FirstName is not null
    group by E.FirstName, E.LastName, E.EmployeeID, Ep.EmployeeID
--     order by sum(Od.UnitPrice*Od.Quantity*(1-Od.Discount));

select E.FirstName, E.LastName, E.EmployeeID, Od.UnitPrice as sum
    from Orders as O
    inner join [Order Details] Od on O.OrderID = Od.OrderID
    inner join Employees E on E.EmployeeID = O.EmployeeID
    left outer join Employees as Ep on E.EmployeeID = Ep.ReportsTo
            where Ep.FirstName is not null

-- b) którzy nie mają podwładnych
select E.FirstName, E.LastName, E.EmployeeID, cast(sum(Od.UnitPrice*Od.Quantity*(1-Od.Discount)) as decimal (10, 2)) as sum
    from Orders as O
    inner join [Order Details] Od on O.OrderID = Od.OrderID
    inner join Employees E on E.EmployeeID = O.EmployeeID
    left outer join Employees as Ep on E.EmployeeID = Ep.ReportsTo
            where Ep.FirstName is null
    group by E.FirstName, E.LastName, E.EmployeeID
    order by sum(Od.UnitPrice*Od.Quantity*(1-Od.Discount));


-- Dla każdego klienta podaj w ilu różnych miesiącach (latach i miesiącach) robił zakupy w 1997r i 1998r
select C.CompanyName, year(O.OrderDate), count(O.OrderDate)
    from Customers as C
    left join Orders O on C.CustomerID = O.CustomerID
        and year(O.OrderDate) in (1997)
    group by C.CompanyName, year(O.OrderDate)
--     order by year(O.OrderDate);

-- Dla każdego klienta podaj liczbę zamówień w każdym z miesięcy 1997, 98
select C.CompanyName, year(O.OrderDate) as rok, month(O.OrderDate) as miesiac, count(O.OrderDate) as ZamowieniaWMiesiacu
    from Customers as C
    left join Orders O on C.CustomerID = O.CustomerID
        and year(O.OrderDate) in (1997, 1998)
    group by C.CompanyName, year(O.OrderDate), month(O.OrderDate)
    order by rok, miesiac;


-- Wybierz nazwy i numery telefonów klientów , którym w 1997 roku przesyłki dostarczała firma ‘United Package’
select distinct C.CustomerID, C.CompanyName, C.Phone
    from Customers C
    inner join Orders O on C.CustomerID = O.CustomerID
    inner join Shippers S on S.ShipperID = O.ShipVia
        where year(O.ShippedDate)=1997 and S.CompanyName='United Package'


-- Wybierz nazwy i numery telefonów klientów , którym w 1997 roku przesyłek nie dostarczała firma ‘United Package’
select distinct C.CustomerID, C.CompanyName, C.Phone
    from Customers C
    left join Orders O on C.CustomerID = O.CustomerID and year(O.ShippedDate)=1997
    left join Shippers S on S.ShipperID = O.ShipVia
        where S.CompanyName!='United Package' or O.ShippedDate is null or O.OrderDate is null




