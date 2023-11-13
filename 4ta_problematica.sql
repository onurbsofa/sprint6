--Listar la cantidad de clientes por nombre de sucursal ordenando de mayor a menor

SELECT branch_name, cantidadClientes
FROM 
	sucursal s JOIN
	(SELECT branch_id, count(*) AS cantidadClientes
	FROM cliente
	GROUP BY branch_id) c
	ON s.branch_id = c.branch_id
ORDER BY cantidadClientes DESC

--Obtener la cantidad de empleados por cliente por sucursal en un número real

SELECT branch_name, CAST(cantidadClientes AS REAL)/CAST(cantidadEmpleados AS REAL) AS clientesPorEmpleado
FROM
	((SELECT branch_id, count(*) AS cantidadEmpleados
		FROM empleado
		GROUP BY branch_id) e
	JOIN
	(SELECT branch_id, count(*) AS cantidadClientes
		FROM cliente
		GROUP BY branch_id) c
	ON c.branch_id = e.branch_id) cantidades
	JOIN sucursal s
	ON s.branch_id = cantidades.branch_id

--Obtener la cantidad de tarjetas de crédito por tipo por sucursal
--(COMENTARIO DE ALUMNOS: Se entiende que se refiere a cantidad de tarjetas x tipo (Credito o Debito))

SELECT count(tipo) AS CantidadTarjetas, tipo, branch_id
FROM tarjeta t INNER JOIN cliente c ON c.customer_id = t.customer_id
GROUP BY branch_id, tipo

--Obtener el promedio de créditos otorgado por sucursal
--(COMENTARIO DE ALUMNOS: Se entiende credito como prestamo)

SELECT sum(loan_total)/count(*) AS PromedioPrestamo, branch_id
FROM prestamo p JOIN cliente c ON c.customer_id = p.customer_id
GROUP BY branch_id

--La información de las cuentas resulta critica para la compañía, por eso es necesario crear una tabla denominada “auditoria_cuenta” para guardar los datos movimientos, 
--con los siguientes campos: old_id, new_id, old_balance, new_balance, old_iban, new_iban, old_type, new_type, user_action, created_at
	--Crear un trigger que después de actualizar en la tabla cuentas los campos balance, IBAN o tipo de cuenta registre en la tabla auditoria
	--Restar $100 a las cuentas 10,11,12,13,14

CREATE TABLE auditoria_cuenta (
	old_id INT, 
	new_id INT,
	old_balance INT, 
	new_balance INT, 
	old_iban INT, 
	new_iban INT, 
	old_type VARCHAR(20), 
	new_type VARCHAR(20), 
	user_action VARCHAR(20), 
	created_at datetime,
	
	CONSTRAINT pk_AudCuen PRIMARY KEY (created_at, old_id)
)
--DROP TRIGGER TriggerAuditoriaCuentas

CREATE TRIGGER TriggerAuditoriaCuentas
AFTER UPDATE ON cuenta
BEGIN
	
	INSERT INTO auditoria_cuenta VALUES
	(OLD.account_id, NEW.account_id,
	OLD.balance, NEW.balance, 
	OLD.iban, NEW.iban, OLD.tipo, NEW.tipo, 
	CASE
            WHEN OLD.account_id != NEW.account_id THEN
                'cambioID'
            WHEN OLD.balance != NEW.balance THEN
                'cambioBalance'
			WHEN OLD.iban != NEW.iban THEN
                'cambioIban'
			WHEN OLD.tipo != NEW.tipo THEN
                'cambioTipo'
            ELSE
                'sinCambio'
        END, 
		CURRENT_TIMESTAMP);	
END;

UPDATE cuenta
SET balance = balance -100
WHERE account_id IN (10,11,12,13,14)

--Mediante índices mejorar la performance la búsqueda de clientes por DNI

CREATE UNIQUE INDEX indiceDNICliente ON cliente (customer_DNI);

--Crear la tabla “movimientos” con los campos de identificación del movimiento, número de cuenta, monto, tipo de operación y hora
	CREATE TABLE movimientos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    numero_cuenta INTEGER,
    monto REAL,
    tipo_operacion TEXT,
    hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP
	);
	--Mediante el uso de transacciones, hacer una transferencia de 1000$ desde la cuenta 200 a la cuenta 400
	--Registrar el movimiento en la tabla movimientos
	--En caso de no poder realizar la operación de forma completa, realizar un ROLLBACK
	-- Iniciar la transacción
BEGIN TRANSACTION;

-- Intentar realizar la transferencia
UPDATE cuentas
SET balance = balance - 1000
WHERE account_id = 200;

UPDATE cuentas
SET balance = balance + 1000
WHERE account_id = 400;

-- Registrar el movimiento en la tabla movimientos
INSERT INTO movimientos (numero_cuenta, monto, tipo_operacion)
VALUES (200, -1000, 'TRANSFERENCIA SALIENTE');

INSERT INTO movimientos (numero_cuenta, monto, tipo_operacion)
VALUES (400, 1000, 'TRANSFERENCIA ENTRANTE');

END
-- Verificar si la transferencia se realizó correctamente
-- Si hay algún problema, realizar un ROLLBACK
ROLLBACK;