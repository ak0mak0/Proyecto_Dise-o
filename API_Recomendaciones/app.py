from flask import Flask, jsonify, request
from config import Config
from recomendador import SistemaRecomendacion

app = Flask(__name__)
app.config.from_object(Config)

@app.route('/')
def home():
    return "API PARA RECOMENDACIONES"

@app.route('/recomendaciones', methods=['POST'])
def get_recomendacion():
    data = request.json
    sitio_actual = data.get('sitio')
    usuario = data.get('usuario')

    if not sitio_actual:
        return jsonify({'error': 'se requiere el sitio actual'}), 400
    
    sistema_recomendacion = SistemaRecomendacion(sitio_actual, usuario)
    recomendaciones = sistema_recomendacion.generar_recomendacion()

    return jsonify(recomendaciones)


