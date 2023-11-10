--Seleccionar las cuentas con saldo negativo
SELECT *
FROM cuenta
WHERE balance < 0;

--Seleccionar el nombre, apellido y edad de los clientes que tengan en el apellido la letra Z
	
SELECT 
	nombre,
	apellido,
	edad
FROM 
	vista_cliente
WHERE apellido LIKE '%z%' OR apellido LIKE '%Z%'
	
--Seleccionar el nombre, apellido, edad y nombre de sucursal de las personas cuyo nombre sea “Brendan” y el resultado ordenarlo por nombre de sucursal

SELECT 
	nombre,
	apellido,
	edad,
	numero_sucursal
FROM
	vista_cliente
WHERE nombre = 'Brendan'
ORDER BY numero_sucursal

--Seleccionar de la tabla de préstamos, los préstamos con un importe mayor a $80.000 y los préstamos prendarios utilizando la unión de tablas/consultas 
--(recordar que en las bases de datos la moneda se guarda como integer, en este caso con 2 centavos)

SELECT
	*
FROM
	prestamo
WHERE loan_type = 'PRENDARIO' OR loan_total/100 > 80000

--Seleccionar los prestamos cuyo importe sea mayor que el importe medio de todos los prestamos

SELECT *
FROM prestamo p1
WHERE p1.loan_total > (SELECT sum(p2.loan_total)/count() as prestamoPromedio
						FROM prestamo p2)

--Contar la cantidad de clientes menores a 50 años

SELECT count(*) as cantidadMenores50
FROM vista_cliente
WHERE edad < 50

--Seleccionar las primeras 5 cuentas con saldo mayor a 8.000$

SELECT *
FROM cuenta
WHERE balance > 8000 * 100
LIMIT 5

--Seleccionar los préstamos que tengan fecha en abril, junio y agosto, ordenándolos por importe

SELECT *
FROM prestamo
WHERE substr(loan_date, 6, 2) IN ('04','06','08')

--Obtener el importe total de los prestamos agrupados por tipo de préstamos. Por cada tipo de préstamo de la tabla préstamo, calcular la suma de sus importes. 
--Renombrar la columna como loan_total_accu

SELECT loan_type, sum(loan_total) AS loan_total_accu
FROM prestamo
GROUP BY loan_type