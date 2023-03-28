
-- Ćwiczenie 1

-- Zad 1
select title, title_no from title;

-- Zad 2
select title, title_no from title
    where title_no=10;

-- Zad 3
select title, title_no, author from title
    where author='Charles Dickens' or author='Jane Austen';


-- Ćwiczenie 2

-- Zad 1
select title_no, title from title
    where title like '%adventure%';

-- Zad 2
select member_no,
       fine_paid as fine_paid,
       fine_assessed as fine_assessed,
       fine_waived as fine_waived
        from loanhist
        where fine_paid is not null;

select member_no, fine_paid from loanhist;

-- Zad 3
select distinct City, State from adult;


-- Zad 4
select title from title
    order by title;


-- Ćwicznie 3
select member_no, isbn, fine_assessed, fine_assessed*2 as 'Double fine'
    from loanhist
    where fine_assessed is not null;


-- Ćwiczenie 4
select concat(replace(firstname, ' ', ''),' ', middleinitial, ' ', lastname ) as 'email_name',
       lower(replace(firstname, ' ', '') + middleinitial + substring(lastname, 1, 2))
    from member
    where lastname='Anderson'
    order by email_name;

-- Ćwiczenie 5
select concat('The title is: ', title, ', title number ',  title_no) as Combination from title;

