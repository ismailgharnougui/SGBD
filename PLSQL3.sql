--PARTIE 1 : Fonction et procédure stockées / les exceptions

--Q1
/*
begin
execute immediate ('create table chantiers (reference number primary key, lieu varchar2(15), dateDebut date, duree number, nbrOuvrierAffectes number )
');


execute immediate ('create table ouvriers (matricule number primary key, nom varchar2(10), prenom varchar2(10), prixJr float,  ref number references chantiers(reference))');

end;
/


--Q2
create or replace procedure proc_insertion_chantier(ch chantiers%rowtype) AS
begin

insert into chantiers values (ch.reference, ch.lieu, ch.dateDebut, ch.duree, null);


Exception
when dup_val_on_index then 
DBMS_OUTPUT.PUT_LINE('Clé déjà utilisée');

end;
/

--Appel procedure

Declare
ch chantiers%rowtype ;
Begin
ch.reference := 10;
ch.lieu := 'X';
ch.dateDebut := sysdate;
ch.duree := 150;
proc_insertion_chantier(ch);

End;
/


--Q3

create or replace procedure
proc_insertion_ouvrier
(
Mat ouvriers.matricule%type,
Nom ouvriers.nom%type,
prenom ouvriers.prenom%type,
PrixJr ouvriers.prixJr%type,
ref ouvriers.ref%type
)
IS
R chantiers.reference%type;
E exception;
BEGIN
select reference into R from chantiers
where reference=ref;
if PrixJr <10 then Raise E;
end if; 
insert into ouvriers values 
(Mat,nom, prenom, prixJr, ref);

Exception
when no_data_found then 
dbms_output.put_line('chantier inexistant');
when E then 
dbms_output.put_line('prix inférieur à 10');
when dup_val_on_index then 
dbms_output.put_line('ouvrier existant');
END;
/

--Appel procédure

Declare

Begin
--proc_insertion_OUVRIER (13, 'XX', 'YY', 15, 10);

--proc_insertion_OUVRIER (15, 'XX', 'YY', 15, 10);

--proc_insertion_OUVRIER (16, 'XX', 'YY', 9, 10);

--proc_insertion_OUVRIER (17, 'XX', 'YY', 25, 8);

End;
/




--Q4
create or replace procedure
proc_insertion_ouvrier
(
Mat ouvriers.matricule%type,
Nom ouvriers.nom%type,
prenom ouvriers.nom%type,
PrixJr ouvriers.prixJr%type,
ref ouvriers.ref%type,
nbr out number
)
IS
R chantiers.reference%type;
E exception;
BEGIN


begin
select reference into R from chantiers
where reference=ref;
if PrixJr <10 then Raise E;
end if; 
insert into ouvriers values 
(Mat,nom, prenom, prixJr, ref);

Exception
when no_data_found then 
dbms_output.put_line('chantier inexistant');
when E then 
dbms_output.put_line('prix inférieur à 10');
when dup_val_on_index then 
dbms_output.put_line('ouvrier existant');
end;

select count(*) into nbr from ouvriers ;

END;
/

--Appel de la procédure

Declare
nb number ;
begin
proc_insertion_OUVRIER (50, 'XX', 'YY', 25, 10, nb);
dbms_output.put_line('nb = '||nb);
end;
/


--Q5

create or replace function fn_fin_chantier (ref number) return date
IS
da date ;
Begin
select dateDebut+duree into da from chantiers where reference = ref ;


return da ;

End;
/

--Appel fonction
select fn_fin_chantier(10) from dual;


--Q6

create or replace procedure proc_liste_ouvriers 
AS

Begin
for i in (select * from chantiers) loop
  dbms_output.put_line ('Chantiers '||i.reference);

  for j in (select * from Ouvriers where ref =    i.reference) loop
   dbms_output.put_line (j.nom || ' '||j.prenom);
  end loop ;
end loop;
End;
/

--Appel
execute proc_liste_ouvriers ;

-- PARTIE 2 : les triggers
--Q1

create or replace Trigger trig_messages_avant
before insert on Ouvriers

begin
dbms_output.put_line ('Début d''insertion');
end;
/

create or replace Trigger trig_messages_apres
after insert on Ouvriers

begin
dbms_output.put_line ('Fin d''insertion');
end;
/

--Appel triggers

insert into Ouvriers values (22, 'U','T', 35, 10);

--Q2
create or replace Trigger trig_messages_specif
before insert or update or delete on Chantiers
--for each row

begin

when inserting then 
dbms_output.put_line ('Insertion '||to_char(sysdate, 'dd/mm/yyyy') ||' '||'a'||' '||to_char (sysdate, 'hh24'));

when deleting then 
dbms_output.put_line ('Suppression '||to_char(sysdate, 'dd/mm/yyyy') ||' '||'a'||' '||to_char (sysdate, 'hh24'));

end;
/

--Q3
Create or replace trigger trig_nbr_ouvrier
after insert or delete on ouvriers
for each row ;

Begin
if inserting then
update chantiers set nbrOuvrierAffectes = nbrOuvrierAffectes +1 where reference = :new.ref ;



elsif
update chantiers set nbrOuvrierAffectes = nbrOuvrierAffectes -1 where reference = :old.ref ;

end if ;


end;
/

*/

--Q4
begin
execute immediate('create table historiques
(type_req varchar(15),
date_ope date,
heure varchar(6),
Utilisateur varchar(20))');
end;
/

--Q5
CREATE OR REPLACE TRIGGER 
trig_historique 
after insert or update or delete 
ON chantiers
declare
even varchar(20) :='INSERT';
BEGIN
if updating then even :='UPDATE';
elsif deleting then even :='DELETE';
end if;
insert into historiques values(even,
sysdate, to_char(sysdate,'hh24:MI'),
USER);
END;
/

--Q6
create or replace Trigger tri_control 
before insert or update or delete on Ouvriers
for each row
when (to_char(sysdate, 'dy') in ('sun', 'sat'))
Begin


 raise_application_error(-5000, 'Vous n''avez pas le droit de faire cette opération');
end;
/

