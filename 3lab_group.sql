
-- 1. Podaj maksymalną cenę zamawianego produktu dla każdego zamówienia
select OrderID, max(UnitPrice) from [Order Details]
    group by OrderID;

-- 2. Posortuj zamówienia wg maksymalnej ceny produktu
select OrderID, max(UnitPrice) from [Order Details]
    group by OrderID
    order by max(UnitPrice);

-- 3. Podaj maksymalną i minimalną cenę zamawianego produktu dla każdego
-- zamówienia
select OrderID, max(UnitPrice), min(UnitPrice) from [Order Details]
    group by OrderID;

-- 4. Podaj liczbę zamówień dostarczanych przez poszczególnych spedytorów
-- (przewoźników)
select ShipVia, count(OrderID) from Orders
    group by ShipVia
    order by ShipVia;

-- 5. Który z spedytorów był najaktywniejszy w 1997 roku
select top 1 ShipVia, count(OrderID) from Orders
    where year(ShippedDate)=1997
    group by ShipVia
    order by count(OrderID) desc;

-- 1. Wyświetl zamówienia dla których liczba pozycji zamówienia jest większa niż 5
select OrderID, count(OrderID) as amount from [Order Details]
    group by OrderID
    having count(OrderID)>5;

/* 2. Wyświetl klientów dla których w 1998 roku zrealizowano więcej niż 8 zamówień
(wyniki posortuj malejąco wg łącznej kwoty za dostarczenie zamówień dla
każdego z klientów) */
select CustomerID, count(*) as orders_count, sum(Freight) as orders_price
    from Orders
    where year(ShippedDate)=1998
    group by CustomerID
    having count(*)>8
    order by sum(Freight) desc; 

-- 1. Podaj liczbę produktów o cenach mniejszych niż 10$ lub większych niż
-- 20$
select count(*) from Products
    where UnitPrice<10 or UnitPrice>20;

-- 2. Podaj maksymalną cenę produktu dla produktów o cenach poniżej 20$
select top 1 UnitPrice
    from Products
    where UnitPrice<20
    order by UnitPrice desc;

-- 3. Podaj maksymalną i minimalną i średnią cenę produktu dla produktów o
-- produktach sprzedawanych w butelkach (‘bottle’)
select max(UnitPrice) as max, min(UnitPrice) as min, avg(UnitPrice) as avg
    from Products
    where QuantityPerUnit like '%bottle%';

-- 4. Wypisz informację o wszystkich produktach o cenie powyżej średniej
select * from Products
    where UnitPrice>(select avg(UnitPrice) from Products)
    order by UnitPrice desc;

-- 5. Podaj sumę/wartość zamówienia o numerze 10250
select OrderID, sum((UnitPrice*[Order Details].Quantity)*(1-Discount)) as wartosc
    from [Order Details]
    where OrderID=10250
    group by OrderID;


-- 1. Napisz polecenie, które oblicza wartość sprzedaży dla każdego zamówienia
-- w tablicy order details i zwraca wynik posortowany w malejącej kolejności
-- (wg wartości sprzedaży).
select OrderID, sum((UnitPrice*[Order Details].Quantity)*(1-Discount)) as wartosc
    from [Order Details]
    group by OrderID
    order by wartosc desc;

-- 2. Zmodyfikuj zapytanie z poprzedniego punktu, tak aby zwracało pierwszych
-- 10 wierszy
select top 10 OrderID, sum((UnitPrice*[Order Details].Quantity)*(1-Discount)) as wartosc
    from [Order Details]
    group by OrderID
    order by wartosc desc;

-- 1. Podaj liczbę zamówionych jednostek produktów dla produktów, dla których
-- productid < 3
select ProductID, sum(Quantity) from [Order Details]
    where ProductID<3
    group by ProductID;

-- 2. Zmodyfikuj zapytanie z poprzedniego punktu, tak aby podawało liczbę
-- zamówionych jednostek produktu dla wszystkich produktów
select ProductID, sum(Quantity) as ordered_amount from [Order Details]
    group by ProductID;

-- 3. Podaj nr zamówienia oraz wartość zamówienia, dla zamówień, dla których
-- łączna liczba zamawianych jednostek produktów jest > 250
select [Order Details].OrderID, sum((UnitPrice*[Order Details].Quantity)*(1-Discount)) as ordered_amount,
    O.ShippedDate
    from [Order Details]
    inner join Orders O on O.OrderID = [Order Details].OrderID
    group by [Order Details].OrderID, O.ShippedDate, [Order Details].OrderID
    having sum(Quantity)>250;

-- 1. Dla każdego pracownika podaj liczbę obsługiwanych przez niego zamówień
select EmployeeID, count(*) from Orders
    group by EmployeeID
    order by EmployeeID;

-- 2. Dla każdego spedytora/przewoźnika podaj wartość "opłata za przesyłkę"
-- przewożonych przez niego zamówień
select ShipVia, sum(Freight) as "Opłata za przesyłkę" from Orders
    group by ShipVia

-- 3. Dla każdego spedytora/przewoźnika podaj wartość "opłata za przesyłkę"
-- przewożonych przez niego zamówień w latach o 1996 do 1997
select ShipVia, sum(Freight) as "Opłata za przesyłkę" from Orders
    where ShippedDate>1995 or ShippedDate<1998
    group by ShipVia

-- Zadanie dodatkowe
select top 1 CustomerID, sum(datediff(Day, OrderDate, ShippedDate)) as diff from Orders
    group by CustomerID
    order by diff desc;

-- 1. Dla każdego pracownika podaj liczbę obsługiwanych przez niego zamówień z
-- podziałem na lata i miesiące
select EmployeeID, year(OrderDate) as rok, month(OrderDate) as miesiąc
    from Orders
    group by year(OrderDate), month(OrderDate), EmployeeID
order by EmployeeID;

-- 2. Dla każdej kategorii podaj maksymalną i minimalną cenę produktu w tej
-- kategorii
select C.CategoryName, max(UnitPrice) as maksymalna, min(UnitPrice) as minimalna
    from Products
    join Categories C on Products.CategoryID=C.CategoryID
    group by C.CategoryName;

select C.CategoryName, Products.CategoryID, max(UnitPrice) as maksymalna, min(UnitPrice) as minimalna
    from Products
    join Categories C on Products.CategoryID=C.CategoryID
    group by C.CategoryName, Products.CategoryID;
