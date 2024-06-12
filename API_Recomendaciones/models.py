from pymongo import MongoClient, errors

uri = "mongodb+srv://beespinoza2022:eVsJfxayY1I1586t@cluster0.yblbnqi.mongodb.net/?retryWrites=true&w=majority&appName=cluster0"
client = MongoClient(uri)
db = client["proyectoSemestralDis"]
collectionSitios = db["sitios"]
collectionUsuarios = db["usuarios"]

class Usuario:
    def __init__(self, user_id, nombre, preferencias):
        self.user_id = user_id
        self.nombre = nombre
        self.preferencias = preferencias
    
    @classmethod
    def from_json(cls, json_data):
        if json_data:
            return cls(
                user_id = json_data.get('_id'),
                nombre = json_data.get('name'),
                preferencias = json_data.get('preferencias', [])
            )
        return None
    
    @classmethod
    def find_by_id(cls, user_id):
        usuario = collectionUsuarios.find_one({'_id': user_id})
        if usuario:
            return Usuario(usuario['_id'], usuario['name'], usuario['preferencias'])
        return None
    
class Sitio:
    def __init__(self, nombre_sitio, latitud, longitud, descripcion=None, categorias = None, calificacion_promedio=None):
        self.nombre_sitio = nombre_sitio
        self.latitud = latitud
        self.longitud = longitud
        self.descripcion = descripcion
        self.categorias = categorias
        self.calificacion_promedio = calificacion_promedio

    @classmethod
    def from_json(cls, json_data):
        if(json_data is None):
            return None
        nombre = json_data.get('nombre')
        sitio = collectionSitios.find_one({'nombre': nombre})
        if(sitio is None):
            return None
        return cls(
            nombre_sitio = sitio.get('nombre'),
            latitud = sitio.get('latitud'),
            longitud = sitio.get('longitud'),
            descripcion = sitio.get('descripcion'),
            categorias = sitio.get('categorias'),
            calificacion_promedio = sitio.get('calificacion_promedio'),
        )

    def to_json(self):
        return {
            'nombre_sitio': self.nombre_sitio,
            'latitud': self.latitud,
            'longitud': self.longitud,
            'descripcion': self.descripcion,
            'categorias': self.categorias,
        }
    
    @classmethod
    def find_by_name(cls, nombre_sitio):
        sitio = collectionSitios.find_one({'nombre': nombre_sitio})
        if sitio:
            return Sitio(sitio['nombre'], sitio['latitud'], sitio['longitud'], sitio['descripcion'], sitio['categorias'])
        return None
    
class Categoria ():
    def __init__(self, nombre_categoria, descripcion):
        self.nombre_categoria = nombre_categoria
        self.descripcion = descripcion

    @classmethod
    def from_json(cls, json_data):
        return cls(
            nombre_categoria=json_data.get('nombre_categoria'),
            descripcion=json_data.get('descripcion')
        )

    def to_json(self):
        return {
            'nombre_categoria': self.nombre_categoria,
            'descripcion': self.descripcion
        }
    
class Recomendacion ():
    def __init__(self, usuario, sitio):
        self.usuario = usuario
        self.sitio = sitio
    def to_json(self):
        return {
            self.usuario.to_json(),
            self.sitio.to_json()
        }


class Review ():
    def __init__(self, user_id, sitio_id, calificacion, comentario):
        self.user_id = user_id
        self.sitio_id = sitio_id
        self.calificacion = calificacion
        self.comentario = comentario

    @classmethod
    def from_json(cls, json_data):
        return cls(
            user_id=json_data.get('user_id'),
            sitio_id=json_data.get('sitio_id'),
            calificacion=json_data.get('calificacion'),
            comentario=json_data.get('comentario')
        )

    def to_json(self):
        return {
            'user_id': self.user_id,
            'sitio_id': self.sitio_id,
            'calificacion': self.calificacion,
            'comentario': self.comentario
        }