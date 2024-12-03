create database mesaregalos2;
use mesaregalos2;
#drop database mesaregalos2;

create table eventos (
idEv int primary key auto_increment,
nomEv varchar(30),
idLista int,
fecha date,
tipoEv varchar(30),
tipoDet varchar(30),
descripDet varchar(30),
foreign key (idLista) references listas (idLista) on update cascade on delete cascade
)engine=innodb;

create table listas (
idLista int primary key auto_increment,
idCli int,
foreign key (idCli) references clientes (idCli) on delete cascade on update cascade
)engine=innodb;

create table clientes (
idCli int primary key auto_increment,
nomCli varchar(30),
dirCli varchar(30)
);

create table regalos (
idReg int primary key auto_increment,
idArt int,
estadoReg varchar(12),
idLista int,
foreign key (idArt) references articulos (idArt) on delete cascade on update cascade,
foreign key (idLista) references listas (idLista) on delete cascade on update cascade
)engine=innodb;

create table detalle_regalos (
idReg int,
idInv int,
mensaje varchar (200),
foreign key (idReg) references regalos (idReg) on delete cascade on update cascade,
foreign key (idInv) references invitados (idInv) on delete cascade on update cascade
)engine=innodb;

create table invitados (
idInv int primary key auto_increment,
nomInv varchar(30)
)engine=innodb;

create table articulos (
idArt int primary key auto_increment,
precArt decimal (10,2),
existArt int
)engine=innodb;