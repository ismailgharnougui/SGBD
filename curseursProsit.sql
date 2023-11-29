/*
declare
nom employees.first_name%type;
begin
select first_name into nom from employees where employee_id = 100;
dbms_output.put_line('nom est '||nom);
end;
/
*/

-- curseur implicite pour récupérer les prénoms des employés

/*
begin
for i in (select * from employees) loop
dbms_output.put_line(i.department_id || ' '||i.first_name);
end loop;
end;
/
*/

-- curseur explicite qui récupère les salaires des employés

/*
declare
cursor c is select salary from employees ;
sal employees.salary%type;
begin
open c ;
loop
fetch c into sal ;
exit when(c%notfound);
dbms_output.put_line(' salaire = '||sal);
end loop;
close c;
end;
/
*/

-- explicite, récupération toute la ligne
/*
declare
cursor c is select * from employees ;
emp employees%rowtype;
begin
open c ;
loop
fetch c into emp ;
exit when(c%notfound);
dbms_output.put_line(emp.employee_id || ' '||emp.salary);
end loop;
close c;
end;
/
*/

-- explicite , récupération employee_id, first_name
/*
declare
cursor c is select employee_id,first_name from employees ;
id employees.employee_id%type;
nom employees.first_name%type;
begin
open c ;
loop
fetch c into id,nom ;
exit when(c%notfound);
dbms_output.put_line(id ||' ** '||nom);
end loop;
close c;
end;
/
*/

--Partie 2
--question 1/a
--version implicite

/*
begin
For i in (select e.department_id id ,  department_name nom , avg(salary) moy from employees e join departments d on e.department_id = d.department_id group by (e.department_id, d.department_id, department_name)) loop
dbms_output.put_line(i.id||' ** '||i.nom||' ** '||i.moy);
end loop;
end;
/
*/

--version explicite

/*
declare
cursor c is select e.department_id , department_name  , avg(salary)  from employees e join departments d on e.department_id = d.department_id group by (e.department_id, d.department_id, department_name);

dept_id employees.department_id%type;
dept_nom departments.department_name%type;
moy employees.salary%type;


begin
open c;
loop 
fetch c into dept_id, dept_nom, moy ;
exit when (c%notfound);
dbms_output.put_line(dept_id||' ** '|| dept_nom||' ** '||moy);
end loop;
close c ;
end;
/
*/

/*
declare
cursor c is select e.department_id , department_name  , avg(salary) moy  from employees e join departments d on e.department_id = d.department_id group by (e.department_id, d.department_id, department_name);
dept c%rowtype;
dept1 departments%rowtype;


begin
open c;
loop 
fetch c into dept ;
exit when (c%notfound);
dbms_output.put_line(dept.department_id, dept.department_name);
end loop;
close c ;
end;
/
*/

--b/
--explicite
/*
declare
cursor c is select department_id id, count(*) nbr from employees group by department_id;
var c%rowtype;

begin
open c;
fetch c into var ;
while(c%found) loop
dbms_output.put_line(var.id||'  '||var.nbr);
fetch c into var ;
end loop;
close c ;
end;
/
*/
--implicite

/*
begin
for i in (select department_id id, count(*) nbr from employees group by department_id) loop
dbms_output.put_line('dept '|| i.id||' nbr  '||i.nbr);
end loop;
end;
/
*/
--c
--explicite

/*
declare
cursor c is 
select department_id id, first_name prenom, last_name nom from employees where department_id in (select
department_id from employees group by department_id having count(*) >20) ;
var c%rowtype;

begin
open c ;
loop
fetch c into var ;
exit when(c%notfound);
dbms_output.put_line('dept '|| var.id||' prenom  '||var.prenom||' nom '|| var.nom);
end loop;
close c;
end;
/
*/

--d
--explicite

/*
declare
cursor c1 is
select distinct m.first_name  prenomManag,  m.last_name nomManag, e.manager_id id from employees e join employees m on e.manager_id = m.employee_id ;

cursor c2 (man employees.manager_id%type) is select first_name A, last_name B from employees where manager_id = man ;
  
var1 c1%rowtype;
var2 c2%rowtype;

begin
open c1;

loop
fetch c1 into var1;
exit when(c1%notfound);
dbms_output.put_line(chr(10)||'Manager num ' ||c1%rowcount ||var1.nomManag || ' '||var1.prenomManag);

open c2 (var1.id);
loop
fetch c2 into var2;
exit when(c2%notfound);
dbms_output.put_line('Employe ' ||var2.A || ' '||var2.B);
end loop;
dbms_output.put_line ('nbr des employes '||c2%rowcount);
close c2 ;
end loop;
close c1;

end;
/

*/

--implicite
/*
declare
a integer :=0 ;
b integer :=0 ;

begin
for i in (select distinct m.first_name  prenomManag,  m.last_name nomManag, e.manager_id id from employees e join employees m on e.manager_id = m.employee_id ) loop
a :=a+1 ;
dbms_output.put_line(chr(10)||'Manager num ' ||a||' '||i.nomManag || ' '||i.prenomManag);

for j in (select first_name A, last_name B from employees where manager_id = i.id) loop
b := b+1 ;
dbms_output.put_line('Employe ' ||j.A || ' '||j.B);

end loop;
dbms_output.put_line ('nbr des employes '||b);
b:= 0 ;
end loop;


end;
/

*/

--2
begin
 execute immediate ('create table produits (idproduit number primary key, nomProduit varchar2(20), categorieP varchar2(15), prixP float)');

end ;
/





















