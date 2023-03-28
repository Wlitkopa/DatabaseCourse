select * from Products;

select * from Suppliers;

select * from Categories;

select * from Customers;

select * from Orders
where OrderID=10250;

select * from "Order Details"
where OrderID=10250;

/* To polecenie wartości 'ReportsTo' oraz 'EmployeeID' wypisuje dwa razy */
select ReportsTo, EmployeeID, * from Employees;

select EmployeeID, LastName, FirstName
from Employees
where TitleOfCourtesy='Ms.'


/* Daty: yyyy-mm-dd */