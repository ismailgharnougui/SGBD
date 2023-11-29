/*
Declare
prenom employees.first_name%type;
Begin
select first_name into prenom from employees where employee_id = 124;
dbms_output.put_line('prenom est '||prenom);
End;
/

*/

/*
--Blocs Anonymes
--1/a

begin
dbms_output.put_line('Aujourd''hui c''est le'||sysdate);
end;
/

*/

/*
--1/b
Declare
a float := 44.5;
b float :=61.8;
--som float ;

Begin
--som :=a+b;
dbms_output.put_line ('la somme est '|| (a+b));
End;
/
*/

--1/c

/*
declare
i integer :=100;
begin
loop
dbms_output.put_line(i);
i := i - 2;
exit when (i < 0);
end loop;
end;
/
*/

--1/d
/*
declare
a integer :=&a;
b integer :=&b;
som integer ;
prod integer ;
Begin
som := a+ b;
prod := a* b;
dbms_output.put_line('som = ' || som|| ' prod = '||prod);
end ;
/
*/

--1/d
/*
declare
a integer :=&a;
fact integer := 1;

Begin
for i in 2 ..a loop
fact := fact*i ;
end loop;
dbms_output.put_line('fact = '||fact);
end;
/
*/

--2/a
/*
declare 
nom employees.last_name%type;
prenom employees.first_name%type;

begin
select last_name, first_name into nom,prenom from employees where employee_id = 110;
dbms_output.put_line ('nom = ' || nom || ' prenom = '||prenom);
end;
/
*/

/*
--2/b
declare
nbr integer;

Begin
select count(*) into nbr from employees where department_id = 50;
dbms_output.put_line ('nbr = ' || nbr);
end ;
/

*/


