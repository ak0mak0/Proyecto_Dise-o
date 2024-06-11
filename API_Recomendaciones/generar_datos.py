# generate_test_data.py

import csv
import random
from faker import Faker

faker = Faker()

# Generar datos de usuarios
def generate_user_data(num_users):
    with open('usuarios.csv', 'w', newline='') as csvfile:
        fieldnames = ['user_id', 'name', 'visited_sites']
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

        writer.writeheader()
        for i in range(num_users):
            user_id = i + 1
            name = faker.name()
            num_visited_sites = random.randint(0, 0)
            visited_sites = [faker.company() for _ in range(num_visited_sites)]  # Lista de sitios visitados aleatorios
            writer.writerow({'user_id': user_id, 'name': name, 'visited_sites': visited_sites})

# Generar datos de sitios
def generate_site_data(num_sites):
    with open('sitios.csv', 'w', newline='') as csvfile:
        fieldnames = ['nombre_sitio', 'latitud', 'longitud', 'descripcion', 'tags', 'categoria', 'popularidad', 'rating', 'horario_apertura', 'direccion']
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

        writer.writeheader()
        for _ in range(num_sites):
            nombre_sitio = faker.company()
            latitud = faker.latitude()
            longitud = faker.longitude()
            descripcion = faker.text()
            tags = ', '.join([faker.word() for _ in range(random.randint(1, 3))])  # Lista de tags aleatorios
            categoria = random.choice(['parque', 'museo', 'playa', 'monumento'])
            popularidad = random.randint(1, 100)
            rating = round(random.uniform(1.0, 5.0), 1)  # Rating aleatorio entre 1.0 y 5.0
            horario_apertura = faker.time()
            direccion = faker.address()
            writer.writerow({'nombre_sitio': nombre_sitio, 'latitud': latitud, 'longitud': longitud, 'descripcion': descripcion,
                             'tags': tags, 'categoria': categoria, 'popularidad': popularidad, 'rating': rating,
                             'horario_apertura': horario_apertura, 'direccion': direccion})

# Generar datos de muestra
generate_user_data(20)  # Generar datos de 20 usuarios
generate_site_data(50)  # Generar datos de 50 sitios
