--se connecter à l'interface Apex via l'adresse
-- http://127.0.0.1:8080/apex/

--création table de test
create table test (a number, b number);

--création trigger de table simple
create or replace trigger trig_insertion_test after insert on test
begin
dbms_output.put_line('insertion bien réussie');
end;
/

-- tester le déclencheur
insert into test values(1,2);

-- création trigger avec les prédicats
create or replace trigger trig_manipulation_test before insert or update or delete on test
begin
if inserting then dbms_output.put_line('insertion');
elsif updating then
dbms_output.put_line('mise a jour');
else
dbms_output.put_line('suppression');
end if ;
end;
/

-- tester le déclencheur
insert into test values (3,4);

--désactiver ou activer un trigger
Alter trigger  trig_insertion_test disable;
Alter trigger  trig_insertion_test enable;

-- suppression d'un trigger
drop trigger trig_insertion_test ;


--création d'un trigger de ligne (row), affichage new
create or replace trigger trig_insert_ligne_test
before insert on test
for each row
begin
dbms_output.put_line(:new.a);
end;
/

--tester trigger
insert into test values (5,6);

--création d'un trigger de ligne (row), intercepter une valeur

create or replace trigger trig_intercepter_test before insert on test
for each row
begin
:new.a := :new.a *2 ;
end;
/

--tester déclencheur
insert into test values (7,9);
select * from test ;

--création d'un trigger de ligne (row), vérifier une valeur nulle

create or replace trigger trig_verifier_test before insert on test
for each row
begin
if (:new.a is null) then
:new.a := :new.b ;
end if;
end;
/

--tester déclencheur
insert into test values (null,10);
select * from test ;

--création d'un trigger de ligne (row), updating
create or replace trigger trig_update_test before update of b on test
for each row
begin
dbms_output.put_line('ancienne valeur ' ||:old.b);
dbms_output.put_line('nouvelle valeur ' ||:new.b);
end;
/

--tester trigger
update test set a = 14 where a =1 ;


--création d'un trigger de ligne (row), updating of b
create or replace trigger trig_update_test before update of b on test
for each row
begin
dbms_output.put_line('ancienne valeur ' ||:old.a);
dbms_output.put_line('nouvelle valeur ' ||:new.a);
end;
/

--tester trigger
update test set a = 18 where a =14 ;
update test set b = 24 where a = 20 ;

--création d'un trigger de ligne (row), inserting 
create or replace trigger trig_update_test after insert on test
for each row
begin
dbms_output.put_line('ancienne valeur ' ||:old.a);
dbms_output.put_line('nouvelle valeur ' ||:new.a);
end;
/

--tester trigger
insert into test values (10,20);

--trigger pour l'audit
--création de table historique
create table histo_op_test (operation varchar2(10), utilisateur varchar2(15), dateOp date);

--création déclencheur enregister historique de types des opérations

create or replace trigger trig_enreg_histo_op after insert or update or delete on test
for each row
begin
if inserting then 
insert into histo_op_test values ('insertion', user, sysdate);
elsif updating then 
insert into histo_op_test values ('mise a jour', user, sysdate);
else
insert into histo_op_test values ('suppression', user, sysdate);
end if ;
end;
/

--tester trigger
insert into test values (50, 7);
select * from histo_op_test ;


--création déclencheur enregister historique des valeurs mises à jour

--création de table hist MAJ
create table histo_maj (ancienneValeur number, nouvelleValeur number, utilisateur varchar2(15), dateOp date);


create or replace trigger trig_enreg_histo_op before update of b on test
for each row
begin

insert into histo_maj values (:old.b, :new.b, user, sysdate);

end;
/

--tester trigger
select * from test ;

update test set a = 58 where a=20;
select * from histo_maj ;

update test set  b = 18 where b = 2;
select * from histo_maj ;





