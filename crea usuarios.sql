create user 'Invitado'@'localhost' identified by 'pass';
grant select on mesaregalos2.* to 'Invitado'@'localhost';

create user 'Cliente'@'localhost' identified by 'pass';
grant all privileges on mesaregalos2.* to 'Cliente'@'localhost';