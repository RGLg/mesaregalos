#asignar el tipo de detalle de acuerdo al tipo de evento

delimiter //
create trigger before_insert_eventos
before insert on eventos
for each row
begin
if NEW.tipoEv = 'Boda' then set NEW.tipoDet = 'Contrayente';
elseif NEW.tipoEv = 'XV' then SET NEW.tipoDet = 'Tema';
elseif NEW.tipoEv = 'Nacimientos' then SET NEW.tipoDet = 'Color';
end if;
end;
//