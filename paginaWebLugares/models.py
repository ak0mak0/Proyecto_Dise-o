from pymongo import MongoClient, errors
from flask_login import UserMixin
from bson.objectid import ObjectId
from math import radians, sin, cos, sqrt, atan2

# Conexión a la base de datos MongoDB
uri = "mongodb+srv://akmak_1:xxWarWtqO5vVRgso@cluster0.glb67p5.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0"
# uri = "mongodb+srv://beespinoza2022:eVsJfxayY1I1586t@cluster0.yblbnqi.mongodb.net/?retryWrites=true&w=majority"
client = MongoClient(uri)
db = client["proyectoSemestralDis"]
collectionSitios = db["sitios"]
collectionUsuarios = db["usuarios"]
collectionRecos = db["recos_sitios"]

# Clase para el manejo de usuarios
class User(UserMixin):
    def __init__(self, id, username, password):
        self.id = str(id)
        self.username = username
        self.password = password
    
    # Método para guardar un usuario en la base de datos
    def save(self):
        collectionUsuarios.insert_one({
            "username": self.username,
            "password": self.password
        })
    
    # Método para obtener el ID de un usuario
    def get_id(self):
        return self.id
    
    # Método para obtener un usuario por su ID
    @staticmethod
    def get(id):
        id_buscar = ObjectId(id)
        user = collectionUsuarios.find_one({'_id': id_buscar})
        if user:
            return User(user["_id"], user["nombre"], user["password"])
        return None
    
    # Método para encontrar un usuario por su nombre de usuario
    @staticmethod
    def find_by_username(username):
        user = collectionUsuarios.find_one({"nombre": username})
        if user:
            return User(user["_id"], user["nombre"], user["password"])
        return None
    def is_authenticated(self):
        return True
    def is_active(self):
        return True
    def is_anonymous(self):
        return False

# Clase para el manejo de recomendaciones
class RecomendationHandler:
    # Método para reiniciar la colección de recomendaciones
    @staticmethod
    def reset_recos_sitios_collection():
        try:
            db.drop_collection("recos_sitios")
        except errors.OperationFailure:
            pass
        validator = {
            '$jsonSchema': {
                'bsonType': 'object',
                'required': ["_id", "_idsitio", "sitios_cercanos", "sitios_parecidos"],
                'properties': {
                    '_id': {
                        'bsonType': 'objectId',
                        'description': "ID de la reseña."
                    },
                    '_idsitio': {
                        'bsonType': 'objectId',
                        'description': "ID del sitio al que pertenecen las recomendaciones."
                    },
                    'sitios_cercanos': {
                        'bsonType': 'array',
                        'description': "IDs de sitios cercanos."
                    },
                    'sitios_parecidos': {
                        'bsonType': 'array',
                        'description': "IDs de sitios parecidos."
                    }
                }
            }
        }
        db.create_collection("recos_sitios", validator=validator)

    # Método para generar recomendaciones
    @staticmethod
    def generar_recomendaciones(self):
        sitios = collectionSitios.find()
        for sitio in sitios:
            sitios_cercanos = self.encontrar_sitios_cercanos(sitio)
            sitios_parecidos = self.encontrar_sitios_parecidos(sitio)

            reco = {
                "_idsitio": sitio["_id"],
                "sitios_cercanos": sitios_cercanos,
                "sitios_parecidos": sitios_parecidos
            }

            collectionRecos = db["recos_sitios"]
            collectionRecos.update_one({"_idsitio": sitio["_id"]}, {"$set": reco}, upsert=True)
            

    # Método para calcular la distancia entre dos puntos geográficos
    def calcular_distancia(self, lat1, lon1, lat2, lon2):
        # Convertir grados a radianes
        lat1, lon1, lat2, lon2 = map(radians, [lat1, lon1, lat2, lon2])

        # Fórmula de Haversine
        dlon = lon2 - lon1
        dlat = lat2 - lat1
        a = sin(dlat / 2) ** 2 + cos(lat1) * cos(lat2) * sin(dlon / 2) ** 2
        c = 2 * atan2(sqrt(a), sqrt(1 - a))
        distance = 6371 * c  # Radio de la Tierra en kilómetros
        return distance
    
    # Método para encontrar sitios cercanos a un sitio dado
    def encontrar_sitios_cercanos(self, sitio):
        sitios_cercanos = []
        sitios = collectionSitios.find()
        for otro_sitio in sitios:
            if otro_sitio["_id"] != sitio["_id"]:
                distancia = self.calcular_distancia(
                    sitio["latitud"], sitio["longitud"],
                    otro_sitio["latitud"], otro_sitio["longitud"]
                )
                sitios_cercanos.append({"_id": otro_sitio["_id"], "distancia": distancia})
        sitios_cercanos.sort(key=lambda x: x["distancia"])
        return sitios_cercanos[:3]
    
    # Método para encontrar sitios parecidos a un sitio dado
    def encontrar_sitios_parecidos(self, sitio):
        sitios_parecidos = []
        categorias_sitio = set(sitio["categorias"])
        sitios_encontrados = 0

        for otro_sitio in collectionSitios.find({"_id": {"$ne": sitio["_id"]}}):
            if sitios_encontrados >= 3:
                break
            if any(cat in categorias_sitio for cat in otro_sitio["categorias"]) and otro_sitio["_id"] not in sitios_parecidos:
                sitios_parecidos.append(otro_sitio["_id"])
                sitios_encontrados += 1

        return sitios_parecidos[:3]