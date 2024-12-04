#procedure inserta datos en "eventos", trigger genera idLista en "listas" e inserta idLista en "eventos"

#set @cliente_actual = (select idCli from clientes where userC = 'Leonardo');
set @cliente_actual = 2;
delimiter //
create trigger asigna_idLista
before insert on eventos
for each row
begin
declare new_idLista int;
insert into listas (idCli) values (@cliente_actual);#Inserta en la tabla listas el idCliente actual
set new_idLista = LAST_INSERT_ID(); #Recupera el idLista generado
set NEW.idLista = new_idLista; #Asigna el idLista al registro que se va a insertar en eventos
end;
//
delimiter ;

delimiter //
create procedure crear_evento (in nom varchar(30), in fech date, in tipoE varchar(30), in tipoD varchar(30), in descr varchar(30)) 
begin
insert into eventos (nomEv, fecha, tipoEv, tipoDet, descripDet) values (nom, fech, tipoE, tipoD, descr);
end;
//
delimiter ;

call crear_evento('Event2', '2024-10-10', 'Bautismo', 'Color', 'Rosa'); 
select * from eventos;

