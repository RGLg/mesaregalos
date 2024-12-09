delimiter //
CREATE PROCEDURE obtenerProductos()
BEGIN
    SELECT DISTINCT nomArt FROM articulos;
END;
//
delimiter ;

delimiter //
CREATE PROCEDURE obtenerIdListaPorCliente(IN idCliente INT, OUT idLista INT)
BEGIN
    SELECT idLista INTO idLista FROM listas WHERE idCli = idCliente;
END;
//
delimiter ;


delimiter //
CREATE PROCEDURE obtenerArticulos()
BEGIN
    SELECT nomArt FROM articulos;
END;
//
delimiter ;


delimiter //
CREATE PROCEDURE buscarProductoPorNombre(IN nombreProducto VARCHAR(255))
BEGIN
    SELECT idArt, nomArt, precArt, existArt
    FROM articulos
    WHERE nomArt LIKE CONCAT('%', nombreProducto, '%');
END;
//
delimiter ;

delimiter //

-- Trigger para asignar idLista automáticamente
create trigger asigna_idLista
before insert on eventos
for each row
begin
    declare new_idLista int;
    -- Insertamos en la tabla listas el idCliente actual
    insert into listas (idCli) values (@cliente_actual);
    -- Obtenemos el último id insertado (idLista)
    set new_idLista = LAST_INSERT_ID();
    -- Asignamos el nuevo idLista al evento que se va a insertar
    set NEW.idLista = new_idLista;
end;
//
delimiter ;

delimiter //
create procedure crear_evento (in nom varchar(30), in fech date, in tipoE varchar(30), in tipoD varchar(30), in descr varchar(30))
begin
    -- Insertamos el evento
    insert into eventos (nomEv, fecha, tipoEv, tipoDet, descripDet) values (nom, fech, tipoE, tipoD, descr);
end;
//
delimiter ;


delimiter //
create procedure verificar_credenciales (
    in us varchar(30),
    in con varchar(30),
    out validos boolean,
    out idCliente int
)
begin
    -- Verificar si las credenciales existen
    select COUNT(*) > 0 into validos from clientes where userC = us AND passC = con;

    -- Si las credenciales son válidas, asignamos el idCliente
    if validos then
        select idCli into idCliente from clientes where userC = us AND passC = con;
    else
        set idCliente = null;  -- En caso de que las credenciales no sean válidas
    end if;
end;
//
delimiter ;


DELIMITER //

CREATE PROCEDURE registro_clientes (
    IN nom VARCHAR(30),
    IN dir VARCHAR(30),
    IN usua VARCHAR(20),
    IN cont VARCHAR(20)
)
BEGIN
    -- Inserta el nuevo cliente en la tabla 'clientes'
    INSERT INTO clientes (nomCli, dirCli, userC, passC)
    VALUES (nom, dir, usua, cont);
END //

DELIMITER ;



DELIMITER //

CREATE TRIGGER registra_invitados
AFTER INSERT ON clientes
FOR EACH ROW
BEGIN
    -- Inserta el cliente en la tabla 'invitados'
    INSERT INTO invitados (idInv, nomInv)
    VALUES (NEW.idCli, NEW.nomCli);
END //

DELIMITER ;


delimiter //
CREATE PROCEDURE obtenerClientes()
BEGIN
    SELECT nomCli FROM clientes;  -- Supongamos que la tabla 'clientes' tiene una columna 'nomCli' que almacena los nombres de los clientes
END;
//
delimiter ;


delimiter //

create trigger inserta_regalos before insert on regalos
for each row
begin
    declare articulo_id int;
    select idArt into articulo_id from articulos where nomArt = NEW.estadoReg;
    set NEW.idArt = articulo_id;
    set NEW.idLista = @lista_actual;
end;
//
delimiter ;

delimiter //
create trigger before_insert_regalos before insert on regalos
for each row
begin
    declare articulo_id int;

    -- Se establece el 'idArt' con el id del artículo 'Peluche' si no se encuentra en la inserción
    select idArt into articulo_id from articulos where nomArt = 'Peluche';
    -- Asignamos el artículo 'Peluche' al nuevo registro
    set NEW.idArt = articulo_id;
    -- Asignamos la lista actual al nuevo registro
    set NEW.idLista = @lista_actual;
    -- Si el estado del regalo es nulo, se asigna un valor por defecto 'Disponible'
    if NEW.estadoReg is null then
        set NEW.estadoReg = 'Disponible';
    end if;
end;
//
delimiter ;


delimiter //
create procedure obtener_saldo (in id int, out saldo double)
begin
select saldoC into saldo
from clientes
where idCli = id;
end;
//
delimiter ;


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
drop procedure comprar_regalo;




#agrega productos a la lista de regalos

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
drop trigger inserta_regalos;


DELIMITER //

CREATE TRIGGER before_insert_regalos
BEFORE INSERT ON regalos
FOR EACH ROW
BEGIN
    DECLARE articulo_id INT;
    -- Buscar el idArt correspondiente al estadoReg (nombre del artículo) proporcionado en el nuevo registro
    SELECT idArt INTO articulo_id
    FROM articulos
    WHERE nomArt = NEW.estadoReg;  -- Aquí se utiliza NEW.estadoReg, que es el nombre del artículo proporcionado al insertar
    -- Asignar el idArt obtenido al nuevo regalo
    SET NEW.idArt = articulo_id;
    -- Asignar idLista con el valor de @lista_actual
    SET NEW.idLista = @lista_actual;
    -- Si el estadoReg es NULL, asignamos el valor por defecto "Disponible"
    IF NEW.estadoReg IS NULL THEN
        SET NEW.estadoReg = 'Disponible';
    END IF;
END //
DELIMITER ;
drop trigger before_insert_regalos;

DELIMITER //

CREATE TRIGGER before_insert_regalos
BEFORE INSERT ON regalos
FOR EACH ROW
BEGIN
    -- Si el estadoReg es NULL, asignamos el valor por defecto "Disponible"
    IF NEW.estadoReg IS NULL THEN
        SET NEW.estadoReg = 'Disponible';
    END IF;
END //
DELIMITER ;





#---------------------------cristian



DELIMITER //

CREATE PROCEDURE rebajar_cantidad (
    IN p_idArt INT,
    IN p_cantidad INT
)
BEGIN
    DECLARE v_existArt INT;

    -- Obtener la cantidad actual del artículo
    SELECT existArt INTO v_existArt
    FROM articulos
    WHERE idArt = p_idArt;

    -- Si la cantidad actual es mayor o igual a la cantidad a reducir, actualizamos la cantidad
    IF v_existArt >= p_cantidad THEN
        UPDATE articulos
        SET existArt = existArt - p_cantidad
        WHERE idArt = p_idArt;
    ELSE
        -- Si la cantidad a reducir es mayor que la cantidad disponible, setea en 0
        UPDATE articulos
        SET existArt = 0
        WHERE idArt = p_idArt;
    END IF;

END //

DELIMITER ;




DELIMITER //

CREATE TRIGGER rebajar_cantidad_after_insert
AFTER INSERT ON regalos
FOR EACH ROW
BEGIN
    -- Llamar al procedimiento para rebajar la cantidad en la tabla articulos
    CALL rebajar_cantidad(NEW.idArt, NEW.existArt);
    
END //

DELIMITER ;


ALTER TABLE regalos ADD COLUMN cantidad INT DEFAULT 0;
select * from regalos;


DELIMITER //

CREATE PROCEDURE insertar_en_regalos(
    IN p_idArt INT,
    IN p_cantidad INT,
    IN p_estadoReg VARCHAR(12),
    IN p_idLista INT
)
BEGIN
    -- Verificar que los parámetros no sean NULL antes de insertar
    IF p_idArt IS NOT NULL AND p_cantidad > 0 AND p_idLista IS NOT NULL THEN
        -- Inserta el artículo en la tabla regalos
        INSERT INTO regalos (idArt, estadoReg, idLista, cantidad)
        VALUES (p_idArt, p_estadoReg, p_idLista, p_cantidad);

        -- Actualiza la cantidad en la tabla articulos
        UPDATE articulos
        SET existArt = existArt - p_cantidad
        WHERE idArt = p_idArt;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Parámetros inválidos';
    END IF;
END //

DELIMITER ;


#---------------------leonardo


#agrega productos a la lista de regalos

set @lista_actual=4;##la lista actual debe ser igual al idCliente actual
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
select @lista_actual;

delimiter //
create trigger before_insert_regalos
before insert on regalos
for each row
begin
declare articulo_id int;
select idArt into articulo_id from articulos where nomArt = 'Regalito3';
set NEW.idArt = articulo_id;
set NEW.idLista = @lista_actual;
if NEW.estadoReg is null then
set NEW.estadoReg = 'Disponible';
end if;
end;
//
delimiter ;


#obtiene los regalos de acuerdo al idLista
delimiter //
create procedure obtener_regalos (in p_idLista int)
begin
select r.idReg, a.nomArt, a.precArt, r.estadoReg from regalos r
join articulos a on r.idArt = a.idArt where r.idLista = p_idLista;
end;
//
delimiter ;

--------------------------------------
DELIMITER //

CREATE TRIGGER inserta_regalos BEFORE INSERT ON regalos
FOR EACH ROW
BEGIN
    DECLARE articulo_id INT;

    -- Buscar el artículo basado en el nombre
    SELECT idArt INTO articulo_id
    FROM articulos
    WHERE nomArt = NEW.estadoReg;

    -- Si se encuentra el artículo, asignarlo
    IF articulo_id IS NOT NULL THEN
        SET NEW.idArt = articulo_id;
        SET NEW.idLista = @lista_actual;  -- Asegúrate de que @lista_actual esté correctamente configurado
    ELSE
        -- Si no se encuentra, puedes asignar un valor por defecto o manejar el error
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Artículo no encontrado';
    END IF;
END //
DELIMITER ;
drop trigger inserta_regalos;
set @lista_actual=1;


delimiter //
create procedure agrega_articulo (
in nom varchar(100),
in prec decimal(10, 2),
in exist int)
begin
insert into articulos (nomArt, precArt, existArt) 
values (nom, prec, exist);
end;
//
delimiter ;
select * from listas;