from pymongo import MongoClient, errors
from flask_login import UserMixin
from bson.objectid import ObjectId

# Conexión a la base de datos MongoDB
#uri = "mongodb+srv://akmak_1:xxWarWtqO5vVRgso@cluster0.glb67p5.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0"
#client = MongoClient(uri)
#db = client["proyectodb"]
#collectionSitios = db["sitios"]


uri = "mongodb+srv://beespinoza2022:eVsJfxayY1I1586t@cluster0.yblbnqi.mongodb.net/?retryWrites=true&w=majority&appName=cluster0"
client = MongoClient(uri)
db = client["proyectoSemestralDis"]
collectionSitios = db["sitios"]
collectionUsuarios = db["usuarios"]

class User(UserMixin):
    def __init__(self, id, username, password):
        self.id = str(id)
        self.username = username
        self.password = password
    
    def save(self):
        collectionUsuarios.insert_one({
            "username": self.username,
            "password": self.password
        })
    
    def get_id(self):
        return self.id
    
    @staticmethod
    def get(id):
        id_buscar = ObjectId(id)
        user = collectionUsuarios.find_one({'_id': id_buscar})
        if user:
            return User(user["_id"], user["nombre"], user["password"])
        return None
    
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
    