import sqlite3
import random
from faker import Faker
import csv


conn = sqlite3.connect('itbank.db')
c = conn.cursor()

with open('./data_cuentas.csv', 'r') as file:
    csv_reader = csv.reader(file)
    next(csv_reader)  # Skip the header row
    for row in csv_reader:
        # Assuming the CSV columns match the table columns in the same order
        account_id, customer_id, balance, iban, tipo_cuenta = row

        c.execute("INSERT INTO nueva_cuenta (account_id, customer_id, balance, iban, tipo_cuenta) VALUES (?, ?, ?, ?, ?)",
                       (account_id, customer_id, balance, iban, tipo_cuenta))


# Commit the changes and close the connection
conn.commit()
conn.close()

""" 
tipo_values = ['Credito']
marca_values = ['MASTER', 'VISA', 'Amex']

fake = Faker() """

""" insertar 500 terjetas de credito asociadolas a los clientes
for _ in range(500):
    numero = fake.unique.credit_card_number()
    CVV = fake.credit_card_security_code()
    tipo = random.choice(tipo_values)
    marca = random.choice(marca_values)
    fechaOtorgamiento = fake.date_between(start_date='-5y', end_date='today')
    fechaExpiracion = fake.date_between(start_date='today', end_date='+5y')
    customer_id = random.randint(1, 500)  # Asume que tienes IDs de cliente del 1 al 500

    c.execute("INSERT INTO tarjeta (numero, CVV, tipo, marca, fechaOtorgamiento, fechaExpiracion, customer_id) VALUES (?, ?, ?, ?, ?, ?, ?)",
              (numero, CVV, tipo, marca, fechaOtorgamiento, fechaExpiracion, customer_id))

conn.commit()

conn.close()

print("Tarjetas creadas") """

