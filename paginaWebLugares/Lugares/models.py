from pymongo import MongoClient

# Conexión a la base de datos MongoDB
uri = "mongodb+srv://akmak_1:xxWarWtqO5vVRgso@cluster0.glb67p5.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0"
client = MongoClient(uri)
db = client["proyectodb"]
collection = db["sitios"]

#uri = "mongodb+srv://beespinoza2022:eVsJfxayY1I1586t@cluster0.yblbnqi.mongodb.net/?retryWrites=true&w=majority&appName=cluster0"
#client = MongoClient(uri)
#db = client["proyectoSemestralDis"]
#collection = db["lugares"]