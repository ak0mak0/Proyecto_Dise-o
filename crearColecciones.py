from pymongo import MongoClient, errors

uri = "mongodb+srv://akmak_1:xxWarWtqO5vVRgso@cluster0.glb67p5.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0"
client = MongoClient(uri)
db = client["proyectoSemestralDis"]

collectionSitios = db["sitios"]

if "sitios" not in db.list_collection_names():
    try:
        db.create_collection("sitios", validator=
                             {
          "$jsonSchema": {
            "bsonType": "object",
            "required": ["nombre", "descripcion", "latitud", "longitud", "categorias", "estado", "usuario_creo"],
            "properties": {
              "nombre": {
                "bsonType": "string",
                "description": "El nombre del sitio debe ser una cadena de texto y es obligatorio"
              },
              "descripcion": {
                "bsonType": "string",
                "description": "La descripción del sitio debe ser una cadena de texto y es obligatoria"
              },
              "latitud": {
                "bsonType": "double",
                "description": "La latitud del sitio debe ser un número de punto flotante y es obligatoria"
              },
              "longitud": {
                "bsonType": "double",
                "description": "La longitud del sitio debe ser un número de punto flotante y es obligatoria"
              },
              "categorias": {
                "bsonType": "array",
                "items": {
                  "bsonType": "string"
                },
                "description": "Las categorías del sitio deben ser un array de cadenas de texto"
              },
              "calificacion_promedio": {
                "bsonType": "double",
                "description": "La calificación promedio del sitio debe ser un número de punto flotante"
              },
              "reseñas": {
                "bsonType": "array",
                "items": {
                  "bsonType": "object",
                  "required": ["usuario", "calificacion", "comentario", "fecha"],
                  "properties": {
                    "usuario": {
                      "bsonType": "string",
                      "description": "El nombre del usuario que hizo la reseña debe ser una cadena de texto y es obligatorio"
                    },
                    "calificacion": {
                      "bsonType": "double",
                      "description": "La calificación de la reseña debe ser un número de punto flotante y es obligatoria"
                    },
                    "comentario": {
                      "bsonType": "string",
                      "description": "El comentario de la reseña debe ser una cadena de texto y es obligatorio"
                    },
                    "fecha": {
                      "bsonType": "date",
                      "description": "La fecha de la reseña debe ser una fecha y es obligatoria"
                    }
                  }
                },
                "description": "Las reseñas del sitio deben ser un array de objetos"
              },
              "estado": {
                "bsonType": "string",
                "enum": ["activo", "inactivo"],
                "description": "El estado del sitio debe ser 'activo' o 'inactivo' y es obligatorio"
              },
              "fecha_creacion": {
                "bsonType": "date",
                "description": "La fecha de creación del sitio debe ser una fecha y es obligatoria"
              },
              "usuario_creo": {
                "bsonType": "string",
                "description": "El usuario que creó el sitio debe ser una cadena de texto y es obligatorio"
              },
              "fecha_modificacion": {
                "bsonType": "date",
                "description": "La fecha de la última modificación del sitio debe ser una fecha"
              },
              "usuario_modifico": {
                "bsonType": "string",
                "description": "El usuario que realizó la última modificación debe ser una cadena de texto"
              },
              "fecha_ultimo_ingreso": {
                "bsonType": "date",
                "description": "La fecha del último ingreso al sitio debe ser una fecha"
              }
            }
          }
        })
        print("Colección de sitios creada")
    except errors.CollectionInvalid:
        pass

collectionUsuarios = db["usuarios"]

if "usuarios" not in db.list_collection_names():
    try:
        db.create_collection("usuarios", validator=
            {
            "$jsonSchema": {
                "bsonType": "object",
                "required": ["nombre", "password", "email", "estado", "usuario_creacion", "es_administrador"],
                "properties": {
                  "nombre": {
                    "bsonType": "string",
                    "description": "El nombre del usuario debe ser una cadena de texto y es obligatorio"
                  },
                  "password": {
                    "bsonType": "string",
                    "description": "La contraseña del usuario debe ser una cadena de texto y es obligatorio"
                  },
                  "email": {
                    "bsonType": "string",
                    "description": "El correo electrónico del usuario debe ser una cadena de texto y es obligatorio"
                  },
                  "preferencias": {
                    "bsonType": "array",
                    "items": {
                      "bsonType": "string"
                    },
                    "description": "Las preferencias del usuario deben ser un array de cadenas de texto"
                  },
                  "fecha_nacimiento": {
                    "bsonType": "date",
                    "description": "La fecha de nacimiento del usuario debe ser una fecha"
                  },
                  "estado": {
                    "bsonType": "string",
                    "enum": ["activo", "inactivo"],
                    "description": "El estado del usuario debe ser 'activo' o 'inactivo' y es obligatorio"
                  },
                  "fecha_creacion": {
                    "bsonType": "date",
                    "description": "La fecha de creación del usuario debe ser una fecha y es obligatorio"
                  },
                  "usuario_creacion": {
                    "bsonType": "string",
                    "description": "El usuario que creó el usuario debe ser una cadena de texto y es obligatorio"
                  },
                  "fecha_ultima_modificacion": {
                    "bsonType": "date",
                    "description": "La fecha de la última modificación del usuario debe ser una fecha"
                  },
                  "usuario_modifico": {
                    "bsonType": "string",
                    "description": "El usuario que realizó la última modificación debe ser una cadena de texto"
                  },
                  "fecha_ultimo_ingreso": {
                    "bsonType": "date",
                    "description": "La fecha del último ingreso del usuario debe ser una fecha"
                  },
                  "es_administrador": {
                    "bsonType": "bool",
                    "description": "Indica si el usuario es administrador y es obligatorio"
                  }
                }
              }
            }
        )
        print("Colección de usuarios creada")
    except errors.CollectionInvalid:
        pass

collectionCategorias = db["categorias"]

if "categorias" not in db.list_collection_names():
    try:
        db.create_collection("categorias", validator=
            {
            "$jsonSchema": {
                "bsonType": "object",
                "required": ["nombre", "descripcion", "estado", "usuario_creo"],
                "properties": {
                  "nombre": {
                    "bsonType": "string",
                    "description": "El nombre de la categoría debe ser una cadena de texto y es obligatorio"
                  },
                  "descripcion": {
                    "bsonType": "string",
                    "description": "La descripción de la categoría debe ser una cadena de texto y es obligatoria"
                  },
                  "estado": {
                    "bsonType": "string",
                    "enum": ["activo", "inactivo"],
                    "description": "El estado de la categoría debe ser 'activo' o 'inactivo' y es obligatorio"
                  },
                  "fecha_creacion": {
                    "bsonType": "date",
                    "description": "La fecha de creación de la categoría debe ser una fecha y es obligatoria"
                  },
                  "usuario_creo": {
                    "bsonType": "string",
                    "description": "El usuario que creó la categoría debe ser una cadena de texto y es obligatorio"
                  },
                  "fecha_modificacion": {
                    "bsonType": "date",
                    "description": "La fecha de la última modificación de la categoría debe ser una fecha"
                  },
                  "usuario_modifico": {
                    "bsonType": "string",
                    "description": "El usuario que realizó la última modificación debe ser una cadena de texto"
                  },
                  "fecha_ultimo_ingreso": {
                    "bsonType": "date",
                    "description": "La fecha del último ingreso de la categoría debe ser una fecha"
                  }
                }
              }
            }
        )
        print("Colección de categorías creada")
    except errors.CollectionInvalid:
        pass

collectionRecomendaciones = db["recomendaciones"]

if "recomendaciones" not in db.list_collection_names():
    try:
        db.create_collection("recomendaciones", validator=
            {
            "$jsonSchema": {
                "bsonType": "object",
                "required": ["usuario", "sitio_actual"],
                "properties": {
                  "usuario": {
                    "bsonType": "string",
                    "description": "El nombre del usuario debe ser una cadena de texto y es obligatorio"
                  },
                  "sitio_actual": {
                    "bsonType": "string",
                    "description": "El sitio actual del usuario debe ser una cadena de texto y es obligatorio"
                  },
                  "fecha_recomendacion": {
                    "bsonType": "date",
                    "description": "La fecha de la recomendación debe ser una fecha"
                  },
                  "like": {
                    "bsonType": "bool",
                    "description": "Indica si la recomendación fue un like"
                  },
                  "fecha_like": {
                    "bsonType": "date",
                    "description": "La fecha en la que el usuario da el like, debe ser una fecha"
                  }
                }
              }
            }
        )
        print("Colección de recomendaciones creada")
    except errors.CollectionInvalid:
        pass

collectionReviews = db["reviews"]

if "reviews" not in db.list_collection_names():
    try:
        db.create_collection("reviews", validator=
            {
            "$jsonSchema": {
                "bsonType": "object",
                "required": ["usuario", "sitio", "calificacion", "comentario", "fecha"],
                "properties": {
                  "usuario": {
                    "bsonType": "string",
                    "description": "El nombre del usuario que hizo la reseña debe ser una cadena de texto y es obligatorio"
                  },
                  "sitio": {
                    "bsonType": "string",
                    "description": "El nombre del sitio que se reseña debe ser una cadena de texto y es obligatorio"
                  },
                  "fechaHora": {
                    "bsonType": "date",
                    "description": "La fecha de la reseña debe ser una fecha"
                  },
                  "calificacion": {
                    "bsonType": "double",
                    "description": "La calificación de la reseña debe ser un número de punto flotante y es obligatoria"
                  },
                  "comentario": {
                    "bsonType": "string",
                    "description": "El comentario de la reseña debe ser una cadena de texto y es obligatorio"
                  }
                }
              }
            }
        )
        print("Colección de reviews creada")
    except errors.CollectionInvalid:
        pass