#registro de clientes

delimiter //
create procedure registro_clientes (in nom varchar(30), in dir varchar(30), in usua varchar(20), in cont varchar(20), in sal decimal(10,2))
begin
insert into clientes (nomCli, dirCli, userC, passC, saldoC) values (nom, dir, usua, cont, sal);
end;
//
delimiter ;
call registro_clientes ('Ejemplo2', 'Casa2', 'user2', 'contra2', 0);#ejemplo uso
drop procedure registro_clientes;

#trigger que registra clientes en invitados
delimiter //
create trigger registra_invitados after insert on clientes
for each row
begin
insert into invitados (idInv, nomInv)
values (NEW.idCli, NEW.nomCli);
end;
//
delimiter ;

