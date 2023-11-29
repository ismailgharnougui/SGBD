--PARTIE 1
create table models (
ref_model varchar(30) constraint pk_m primary key,
model varchar(30) constraint nt_1 not null,
marque varchar(30) constraint nt_2 not null,
puissance varchar(30) constraint nt_3 not null);

create table vehicule ( 
immatriculation varchar(30) constraint pk_v primary key,
ref_modele varchar(30) references models (ref_model),
date_mise_circulation date constraint nt_4 not null,
kilometrage number constraint nt_5 not null,
prix_demande number constraint nt_6 not null);

create table personnes ( 
cin varchar(30) constraint pk_P primary key,
nom varchar(30)constraint nt_7 not null constraint ck_nom 
check( regexp_like(nom,'[a-z]')and regexp_like(nom,'[A-Z]') and not regexp_like(nom,'[0-9]')),
prenom varchar(30) constraint nt_8 not null,
email varchar(30) constraint un unique constraint chk_email 
(email like '%@%.%'),
num_tel number unique);

create table acquisitions ( 
immatriculation varchar(30) references vehicule(immatriculation),
cin varchar(30) references personnes(cin),
date_debut date,
date_fin date constraint nt_9 not null,
constraint pk_acq primary key ( immatriculation,cin),
constraint chk_fin check (date_debut < date_fin ));

create table contrat_vente(
ref_contrat varchar(30),
cin varchar(30),
immatriculation varchar(30),
date_vente date default sysdate,
prix_vente number  constraint nt_10 not null,
constraint fk_contrat_acq foreign key (immatriculation,cin)  references acquisitions (immatriculation,cin),
constraint pk_c primary key ( ref_contrat, cin , immatriculation ));

--PARTIE2
--1
alter table models
add constraint ch_puissance check ( puissance in ('3CH' , '4CH', '5CH'));
--2
alter table vehicule 
add constraint ch_prix check (prix_demande between 1000 and 100000);
--3
alter table personnes 
add constraint ch_nom check ( nom!= prenom);
--4
alter table acquisitions
modify date_debut constraint nt_debut NOT NULL ;
--4
alter table vehicule 
add num_chassis varchar(30) not null; 
