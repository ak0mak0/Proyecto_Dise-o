from pymongo import MongoClient, errors

uri = "mongodb+srv://beespinoza2022:eVsJfxayY1I1586t@cluster0.yblbnqi.mongodb.net/?retryWrites=true&w=majority&appName=cluster0"
client = MongoClient(uri)
db = client["proyectoSemestralDis"]
collectionSitios = db["sitios"]

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
                    },
                    'descripcion': {
                        'bsonType': 'string',
                        'description': "Descripción del sitio turístico."
                    },
                    'tags': {
                        'bsonType': 'array',
                        'items': {
                            'bsonType': 'string'
                        },
                        'description': "Una lista de tags o características para el sitio."
                    },
                    'categoria': {
                        'bsonType': 'string',
                        'description': "Categoría del sitio (por ejemplo, parque, museo, etc.)."
                    },
                    'popularidad': {
                        'bsonType': 'int',
                        'description': "Un valor que indica la popularidad del sitio."
                    },
                    'rating': {
                        'bsonType': 'double',
                        'description': "Valoración del sitio por los usuarios."
                    },
                    'horario_apertura': {
                        'bsonType': 'string',
                        'description': "Horario de apertura del sitio."
                    },
                    'direccion': {
                        'bsonType': 'string',
                        'description': "Dirección específica del sitio."
                    }
                }
            }
        })
    except errors.CollectionInvalid:
        pass

collectionUsuarios = db["usuarios"]

if "usuarios" not in db.list_collection_names():
    try:
        db.create_collection("usuarios", validator={
            '$jsonSchema': {
                'bsonType': 'object',
                'required': ["name"],
                'properties': {
                    'name': {
                        'bsonType': 'string',
                        'description': "Debe ser una cadena de caracteres para el nombre del usuario."
                    },
                    'visited_sites': {
                        'bsonType': 'array',
                        'items': {
                            'bsonType': 'string'
                        },
                        'description': "Una lista de sitios visitados por el usuario."
                    }
                }
            }
        })
    except errors.CollectionInvalid:
        pass

    
class Usuario:
    def __init__(self, user_id, nombre, sitios_visitados):
        self.user_id = user_id
        self.nombre = nombre
        self.sitios_visitados = sitios_visitados
    
    @classmethod
    def from_json(cls, json_data):
        if json_data:
            return cls(
                user_id = json_data.get('_id'),
                nombre = json_data.get('name'),
                sitios_visitados = json_data.get('visited_sites', [])
            )
        return None
    
class Sitio:
    def __init__(self, nombre_sitio, latitud, longitud, descripcion=None, tags=None, categoria=None, popularidad=0, rating=0.0, horario_apertura=None, direccion=None):
        self.nombre_sitio = nombre_sitio
        self.latitud = latitud
        self.longitud = longitud
        self.descripcion = descripcion
        self.tags = tags if tags is not None else []
        self.categoria = categoria
        self.popularidad = popularidad
        self.rating = rating
        self.horario_apertura = horario_apertura
        self.direccion = direccion

    @classmethod
    def from_json(cls, json_data):
        return cls(
            nombre_sitio=json_data.get('nombre_sitio'),
            latitud=json_data.get('latitud'),
            longitud=json_data.get('longitud'),
            descripcion=json_data.get('descripcion'),
            tags=json_data.get('tags', []),
            categoria=json_data.get('categoria'),
            popularidad=json_data.get('popularidad', 0),
            rating=json_data.get('rating', 0.0),
            horario_apertura=json_data.get('horario_apertura'),
            direccion=json_data.get('direccion')
        )

    def to_json(self):
        return {
            'nombre_sitio': self.nombre_sitio,
            'latitud': self.latitud,
            'longitud': self.longitud,
            'descripcion': self.descripcion,
            'tags': self.tags,
            'categoria': self.categoria,
            'popularidad': self.popularidad,
            'rating': self.rating,
            'horario_apertura': self.horario_apertura,
            'direccion': self.direccion
        }
