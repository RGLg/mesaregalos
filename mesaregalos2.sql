create database mesaregalos2;
use mesaregalos2;
drop database mesaregalos2;

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
drop table listas;

create table clientes (
idCli int primary key auto_increment,
nomCli varchar(30),
dirCli varchar(30),
userC varchar (20),
passC varchar (20),
saldoC decimal(10,2)
);

create table regalos (
idReg int primary key auto_increment,
idArt int,
estadoReg varchar(12),
idLista int,
precArt decimal(10,2),
foreign key (idArt) references articulos (idArt) on delete cascade on update cascade,
foreign key (idLista) references listas (idLista) on delete cascade on update cascade
)engine=innodb;

create table tarjeta_regalos (
nomCli varchar(30),
mensaje varchar (200)
)engine=innodb;

create table detalle_regalos (
idReg int,
idInv int,
foreign key (idReg) references regalos (idReg) on delete cascade on update cascade,
foreign key (idInv) references invitados (idInv) on delete cascade on update cascade
)engine=innodb;
drop table detalle_regalos;

create table invitados (
idInv int primary key,
nomInv varchar(30)
)engine=innodb;

create table articulos (
idArt int primary key auto_increment,
nomArt varchar(30),
precArt decimal (10,2),
existArt int
)engine=innodb;

drop database mesaregalos2;