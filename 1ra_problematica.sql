CREATE TABLE tipoCliente(
    tipo_cli VARCHAR(20) PRIMARY KEY,
    CONSTRAINT tipo_cli CHECK (tipo_cli IN ('Classic', 'Gold', 'Black'))
)
INSERT INTO tipoCliente (tipo_cli) VALUES ('Classic'), ('Gold'), ('Black');

CREATE TABLE tipoCuenta(
    tipo_cuen VARCHAR(20) PRIMARY KEY
    CONSTRAINT tipo_cuen CHECK (tipo_cuen IN ('CCDolares', 'CCPesos','CADolares', 'CAPesos','CuentaInversion'))
)
INSERT INTO tipoCuenta (tipo_cuen) VALUES ('CCDolares'), ('CCPesos'), ('CADolares'), ('CAPesos'), ('CuentaInversion');

CREATE TABLE marcaTarjeta(
    marca VARCHAR(20) PRIMARY KEY,
    CONSTRAINT marca CHECK (marca IN ('MASTER', 'VISA','Amex'))
)
INSERT INTO marcaTarjeta (marca) VALUES ('MASTER'), ('VISA'), ('Amex');

CREATE TABLE tarjeta (
    numero VARCHAR(20) PRIMARY KEY,
    CVV VARCHAR(3),
    tipo VARCHAR(10),
	marca VARCHAR(20),
    fechaOtorgamiento DATE,
    fechaExpiracion DATE,
	customer_id INTEGER,
    CONSTRAINT tipo CHECK (Tipo IN ('Credito', 'Debito')),
	CONSTRAINT FK_Tarjeta_MarcaTarjeta FOREIGN KEY (marca) REFERENCES marcaTarjeta(marca),
	CONSTRAINT FK_cliente FOREIGN KEY (customer_id) REFERENCES cliente(customer_id)
);

CREATE TABLE nueva_cuenta (
	account_id INTEGER  PRIMARY KEY,
    customer_id INTEGER,
    balance INTEGER,
    iban TEXT,
    tipo_cuenta VARCHAR(20),
    CONSTRAINT FK_cuenta_tipoCuenta FOREIGN KEY (tipo_cuenta) REFERENCES tipoCuenta(tipo_cuen),
    CONSTRAINT FK_cuenta_cliente FOREIGN KEY (customer_id) REFERENCES cliente(customer_id)
ALTER TABLE cuenta 
	ADD COLUMN tipo VARCHAR(20);
ALTER TABLE cuenta 
	ADD CONSTRAINT fk_cuenta_tipoCuenta FOREIGN KEY tipo REFERENCES tipoCuenta;


CREATE FUNCTION random_column1 --POR ALGUN MOTIVO NO FUNCIONA, REVISAR
AS
BEGIN
    RETURN (SELECT
        tipo_cuen
    FROM
        tipoCuenta
    ORDER BY
        random()
    LIMIT
        1 )
END;

UPDATE cuenta
	SET tipo = random_column1
	
UPDATE empleado SET employee_hire_date = substr(employee_hire_date, 7, 4) || '-' || substr(employee_hire_date, 4, 2) || '-' || substr(employee_hire_date, 1, 2);



