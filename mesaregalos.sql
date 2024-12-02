create database mesaregalos;
use mesaregalos;

create table clientes (
idCli int primary key auto_increment,
nomCli varchar (30),
dirCli varchar (30)
) engine=innodb;

create table eventos (
idEv int primary key auto_increment,
nomEv varchar (30),
codEv varchar(30),
fechaEv date,
tipoEv varchar (20),

idCli int,
foreign key (idCli) references clientes (idCli) on delete cascade on update cascade
)engine=innodb;

create table articulos (
idArt int primary key auto_increment,
nomArt varchar(30),
precArt decimal(10,2),
existArt int,
resurtArt int,
costArt decimal(10,2),
resp varchar(30),
ultRev date
)engine=innodb;

create table mesas (
idMesa int primary key auto_increment,
estadoRegalo varchar(10),

idEv int,
idArt int,
foreign key (idEv) references eventos (idEv) on delete cascade on update cascade,
foreign key (idArt) references articulos (idArt) on delete cascade on update cascade
)engine=innodb;

create table invitados (
idInv int primary key auto_increment,
nomInv varchar(30),
msjInv text,

idEv int,
idArt int,
foreign key (idEv) references eventos (idEv) on delete cascade on update cascade,
foreign key (idArt) references articulos (idArt) on delete cascade on update cascade
)engine=innodb;

