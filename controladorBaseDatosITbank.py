import sqlite3
import random
from faker import Faker


conn = sqlite3.connect('ITbank.db')
c = conn.cursor()

tipo_values = ['Credito']
marca_values = ['MASTER', 'VISA', 'Amex']

fake = Faker()

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

print("Tarjetas creadas")