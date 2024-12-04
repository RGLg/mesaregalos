#agrega productos a la lista de regalos

set @lista_actual=1;
delimiter //
create trigger inserta_regalos before insert on regalos
for each row
begin
declare articulo_id int;
select idArt into articulo_id from articulos where nomArt = NEW.estadoReg;
set NEW.idArt = articulo_id;
set NEW.idLista=@lista_actual;
end;
//
delimiter ;


delimiter //
create trigger before_insert_regalos
before insert on regalos
for each row
begin
declare articulo_id int;
select idArt into articulo_id from articulos where nomArt = 'Peluche';##
set NEW.idArt = articulo_id;
set NEW.idLista = @lista_actual;
if NEW.estadoReg is null then
set NEW.estadoReg = 'Disponible';
end if;
end;
//
delimiter ;

drop trigger before_insert_regalos;
insert into regalos (idArt) values (1);


delete from regalos where idReg=1;
delete from articulos where idArt=4;
select * from regalos;
select * from articulos;




