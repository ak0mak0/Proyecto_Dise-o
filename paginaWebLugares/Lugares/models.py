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

def generarID(sequence_name):
    counter = db.counters.find_one_and_update(
        {"_id": sequence_name},
        {"$inc": {"sequence_value": 1}},
        return_document=True
    )
    return counter["sequence_value"]