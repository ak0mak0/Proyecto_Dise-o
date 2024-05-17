from flask import Blueprint, jsonify, request
from app.models import get_next_sequence_value, get_db

# Crear un Blueprint para las rutas de la API
api_bp = Blueprint('api', __name__)

# Define una ruta inicial
@api_bp.route('/')
def home():
    return 'Ejecutando API REST'


# Ruta para obtener la lista de sitios
@api_bp.route('/sitios', methods=['GET'])
def get_sitios():
    db = get_db()
    sitios = list(db.sitios.find())
    return jsonify({"sitios": sitios})


@api_bp.route('/sitios', methods=['POST'])
def create_sitio():
    data = request.json
    required_fields = ["latitud", "longitud", "nombre_sitio"]

    if not all(field in data for field in required_fields):
        return jsonify({"error": "Datos incompletos"}), 400

    new_id = get_next_sequence_value("sitioid")

    db = get_db()
    # Establecer explícitamente _id como None en el documento
    data["_id"] = new_id
    db.sitios.insert_one(data)

    return jsonify({"mensaje": "Sitio creado con éxito", "id_sitio": new_id}), 201

