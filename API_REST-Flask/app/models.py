from pymongo import MongoClient, errors
from flask import current_app

def get_db():
    # Obtener la configuración de la aplicación Flask
    config = current_app.config

    # Construir la URI de conexión utilizando los valores de la configuración
    username = config['MONGODB_USERNAME']
    password = config['MONGODB_PASSWORD']
    cluster = config['MONGODB_CLUSTER']
    dbname = config['MONGODB_DBNAME']
    uri = f"mongodb+srv://{username}:{password}@{cluster}/{dbname}?retryWrites=true&w=majority"

    # Establecer la conexión con MongoDB Atlas
    client = MongoClient(uri)

    # Devolver el objeto de base de datos
    return client[dbname]

# Verifica que la colecion sitios y counters exista, sino crea una nueva
def ensure_sitios_collection():
    db = get_db()
    if "sitios" not in db.list_collection_names():
        try:
            db.create_collection("sitios", validator={
                '$jsonSchema': {
                    'bsonType': 'object',
                    'required': ["latitud", "longitud", "nombre_sitio"],
                    'properties': {
                        'latitud': {
                            'bsonType': 'double',
                            'description': "Debe ser un número flotante para la latitud."
                        },
                        'longitud': {
                            'bsonType': 'double',
                            'description': "Debe ser un número flotante para la longitud."
                        },
                        'nombre_sitio': {
                            'bsonType': 'string',
                            'description': "Debe ser una cadena de caracteres para el nombre del sitio."
                        }
                    }
                }
            })
        except errors.CollectionInvalid:
            pass

    if "counters" not in db.list_collection_names():
        db.create_collection("counters")

    if db.counters.find_one({"_id": "sitioid"}) is None:
        db.counters.insert_one({"_id": "sitioid", "sequence_value": 0})

# obtiene ultimo valor en counters para generar un id incremental
def get_next_sequence_value(sequence_name):
    db = get_db()
    counter = db.counters.find_one_and_update(
        {"_id": sequence_name},
        {"$inc": {"sequence_value": 1}},
        return_document=True
    )
    return counter["sequence_value"]