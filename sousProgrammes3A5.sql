/*

--1
create or replace function FN_NBR_DEPARTEMENT return integer is

x integer ;
begin
select count(*) into x from departments ;
return x ;
end;
/

--Appel 1
select FN_NBR_DEPARTEMENT "nbre departs" from dual ;

--Appel 2

declare
y integer ;
begin
y := FN_NBR_DEPARTEMENT ;
dbms_output.put_line(' nbre de departs = ' ||y);
end ;
/

--2
create or replace function FN_NOMDEPT (id employees.employee_id
%type) return departments.department_name%type is

var departments.department_name%type;
begin

select department_name into var from departments d join employees e on d.department_id = e.department_id where employee_id = id ;
return var ;
end;
/

-- Appel 
select FN_NOMDEPT(100) from dual ;
select FN_NOMDEPT(120) from dual ;
*/

--3
create or replace procedure PROC_DETAILS_EMP is

begin
for i in 
(select e.first_name prenomE, e.last_name nomE , m.first_name prenomM, m.last_name nomM from employees e join employees m on e.manager_id = m.employee_id ) loop

dbms_output.put_line('prenom empl '||i.prenomE || ' nom Emp '||i.nomE|| ' prenom manager '||i.prenomM|| ' nom manager '||i.nomM);

end loop;

end ;
/

--Appel procedure (1)
execute PROC_DETAILS_EMP ;

--Appel procedure (2)
begin

PROC_DETAILS_EMP ;
end;
/

--4
create or replace procedure PROC_SALMOY (nb out integer) IS

begin
for i in 
(select department_id, avg (salary) salmo from employees group by department_id) loop
dbms_output.put_line (i.department_id || '  '||i.salmo);
end loop;

select count(*) into nb from departments;
end ;
/

declare
x integer ;
begin
PROC_SALMOY(x);
dbms_output.put_line ('nb depart = '||x);
end;
/

--5 fait en classe au tableau

--6







