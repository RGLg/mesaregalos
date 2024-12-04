#verificar credenciales para iniciar sesion

delimiter //
create procedure verificar_credenciales (in us varchar(30), in con varchar(30), out validos boolean)
begin
select COUNT(*) > 0 into validos from clientes where userC = us AND passC = con;
end;
//
delimiter ;

call verificar_credenciales('user1', 'contra1', @validos);
select @validos as Validos;

select * from clientes;
