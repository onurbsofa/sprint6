--DROP VIEW vista_cliente
CREATE VIEW vista_cliente AS
SELECT 
    c.customer_id AS id,
    s.branch_number AS numero_sucursal,
    c.customer_name AS nombre,
    c.customer_surname AS apellido,
    c.customer_DNI AS DNI,
    strftime('%Y', 'now') - strftime('%Y', c.dob) - (strftime('%m-%d', 'now') < strftime('%m-%d', c.dob)) AS edad
FROM 
    cliente c
JOIN 
    sucursal s ON c.branch_id = s.branch_id;

	
--mostrar las columnas de los clientes, ordenadas por el DNI de menora mayor y cuya edad sea superior a 40 años.
SELECT *
FROM vista_cliente
WHERE edad > 40
ORDER BY DNI;



--mostrar todos los clientes que se llaman “Anne” o “Tyler” ordenados por edad de menor a mayor.
SELECT *
FROM vista_cliente
WHERE nombre IN ('Anne', 'Tyler')
ORDER BY edad;



--insertar nuevos clientes.
INSERT INTO cliente (customer_name, customer_surname, customer_DNI, dob, branch_id)
VALUES 
    ('Lois', 'Stout', 47730534, '1984-07-07', 80),
    ('Hall', 'Mcconnell', 52055464, '1968-04-30', 45),
    ('Hilel', 'Mclean', 43625213, '1993-03-28', 77),
    ('Jin', 'Cooley', 21207908, '1959-08-24', 96),
    ('Gabriel', 'Harmon', 57063950, '1976-04-01', 27);

--verificar.
SELECT * FROM cliente WHERE customer_name IN ('Lois', 'Hall', 'Hilel', 'Jin', 'Gabriel');
--o
SELECT *
FROM (SELECT * FROM cliente ORDER BY customer_id DESC LIMIT 5) AS subquery
ORDER BY customer_id ASC;



--actualizar los clientes y cambiar su sucursal a 10.
UPDATE cliente
SET branch_id = 10
WHERE customer_id IN (SELECT customer_id FROM cliente ORDER BY customer_id DESC LIMIT 5);

--verificar.
SELECT *
FROM cliente
WHERE branch_id = 10;


--"agregar a Noel"
INSERT INTO cliente (customer_name, customer_surname, customer_DNI, dob, branch_id)
VALUES ('Noel', 'David', 12345678, '1997-04-20', 10);

--eliminar a "Noel David" por nombre y apellido.
DELETE FROM cliente
WHERE customer_name = 'Noel' AND customer_surname = 'David';


--tipo de préstamo de mayor importe.
SELECT loan_type
FROM prestamo
WHERE loan_total = (SELECT MAX(loan_total) FROM prestamo);