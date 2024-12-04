#comprar regalos

delimiter //

create procedure comprar_regalo (in p_idReg INT, in p_idInv INT, in p_mensaje varchar(200)
)
begin
declare v_estadoReg varchar(20);
select estadoReg INTO v_estadoReg from regalos where idReg = p_idReg;
if v_estadoReg = 'Disponible' then
update regalos set estadoReg = 'Adquirido' where idReg = p_idReg;
insert into detalle_regalos (idReg, idInv, mensaje) values (p_idReg, p_idInv, p_mensaje);
end if;
end//
delimiter ;


CALL comprar_regalo(3, 3, 'felicidades'); 

select * from regalos;
select * from invitados;
select * from detalle_regalos;
