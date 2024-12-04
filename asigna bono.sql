##asignar bono

DELIMITER //
CREATE TRIGGER asignar_bono
AFTER INSERT ON regalos
FOR EACH ROW
BEGIN
DECLARE total_ventas DECIMAL(10, 2);
SELECT SUM(a.precArt) INTO total_ventas FROM regalos r JOIN articulos a ON r.idArt = a.idArt
JOIN listas l ON r.idLista = l.idLista
JOIN eventos e ON e.idLista = l.idLista
WHERE e.idLista = NEW.idLista;
IF total_ventas > 5000 THEN
UPDATE clientes c
JOIN listas l ON c.idCli = l.idCli
SET c.saldoC = 1000
WHERE l.idLista = NEW.idLista;
END IF;
END//
DELIMITER ;
drop trigger asignar_bono;

insert into articulos (nomArt, precArt, existArt) values ('Peluche', 2600, 40);

select * from clientes;
select * from articulos;