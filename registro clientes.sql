#registro de clientes

delimiter //
create procedure registro_clientes (in nom varchar(30), in dir varchar(30), in usua varchar(20), in cont varchar(20))
begin
insert into clientes (nomCli, dirCli, userC, passC) values (nom, dir, usua, cont);
end;
//
delimiter ;
call registro_clientes ('Ejemplo1', 'Casa1', 'user1', 'contra1'); #ejemplo uso