from pymongo import MongoClient, errors
from flask_login import UserMixin
from bson.objectid import ObjectId

# Conexión a la base de datos MongoDB
uri = "mongodb+srv://akmak_1:xxWarWtqO5vVRgso@cluster0.glb67p5.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0"
client = MongoClient(uri)
db = client["proyectodb"]
collectionSitios = db["sitios"]


#uri = "mongodb+srv://beespinoza2022:eVsJfxayY1I1586t@cluster0.yblbnqi.mongodb.net/?retryWrites=true&w=majority&appName=cluster0"
#client = MongoClient(uri)
#db = client["proyectoSemestralDis"]
#collectionSitios = db["lugares"]

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


def generarID(sequence_name):
    counter = db.counters.find_one_and_update(
        {"_id": sequence_name},
        {"$inc": {"sequence_value": 1}},
        return_document=True
    )
    return counter["sequence_value"]

collectionUsuarios = db["usuarios"]

#uri = "mongodb+srv://beespinoza2022:eVsJfxayY1I1586t@cluster0.yblbnqi.mongodb.net/?retryWrites=true&w=majority&appName=cluster0"
#client = MongoClient(uri)
#db = client["proyectoSemestralDis"]
#collectionUsuarios = db["lugares"]

if "usuarios" not in db.list_collection_names():
    try:
        db.create_collection("usuarios", validator={
            '$jsonSchema': {
                'bsonType': 'object',
                'required': ["username", "email", "password"],
                'properties': {
                    'username': {
                        'bsonType': 'string',
                        'description': "Debe ser una cadena de caracteres para el nombre de usuario."
                    },
                    'email': {
                        'bsonType': 'string',
                        'description': "Debe ser una cadena de caracteres para el correo electronico."
                    },
                    'password': {
                        'bsonType': 'string',
                        'description': "Debe ser una cadena de caracteres para la contraseña."
                    }
                }
            }
        })
    except errors.CollectionInvalid:
        pass

class User(UserMixin):
    def __init__(self, id, username, name, password):
        self.id = str(id)
        self.username = username
        self.name = name
        self.password = password
    
    def save(self):
        collectionUsuarios.insert_one({
            "username": self.username,
            "name": self.name,
            "password": self.password
        })
    
    def get_id(self):
        return self.id
    
    @staticmethod
    def get(id):
        id_buscar = ObjectId(id)
        user = collectionUsuarios.find_one({'_id': id_buscar})
        if user:
            return User(user["_id"], user["username"], user["name"], user["password"])
        return None
    
    @staticmethod
    def find_by_username(username):
        user = collectionUsuarios.find_one({"username": username})
        if user:
            return User(user["_id"], user["username"], user["name"], user["password"])
        return None
    def is_authenticated(self):
        return True
    def is_active(self):
        return True
    def is_anonymous(self):
        return False
    