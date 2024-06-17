from flask import Flask, render_template, redirect, url_for, request, jsonify
from flask_login import login_user, logout_user, login_required, LoginManager, current_user
from models import collectionRecos, collectionSitios, collectionUsuarios, User, RecomendationHandler
from werkzeug.security import check_password_hash, generate_password_hash
from urllib.parse import urlparse
from forms import LoginForm, RegistroForm, AgregarLugarForm
from bson import ObjectId 
from datetime import datetime

app = Flask(__name__)
app.secret_key = 'pinwino'
app.config['SESSION_COOKIE_HTTPONLY'] = True
app.config['SESSION_COOKIE_SAMESITE'] = 'Lax'
app.config['PERMANENT_SESSION_LIFETIME'] = 600

login_manager = LoginManager(app)
login_manager.login_view = 'login'

@login_manager.user_loader
def load_user(user_id):
    return User.get(user_id)

@app.route('/login', methods=['GET', 'POST'])
def login():
    error = None
    if current_user.is_authenticated:
        return redirect(url_for('lugares'))
    form = LoginForm()
    if form.validate_on_submit():
        user = User.find_by_username(form.username.data)
        if user is not None and check_password_hash(user.password, form.password.data):
            login_user(user)
            next_page = request.args.get('next')
            if not next_page or urlparse(next_page).netloc != '':
                next_page = url_for('lugares')
            return redirect(next_page)
        else:
            error = "Usuario o contraseña incorrectos."
    return render_template('login.html', form=form, error=error)

@app.route('/registro', methods=['GET', 'POST'])
def registro():
    error = None
    form = RegistroForm()
    if form.validate_on_submit():
        username = form.username.data
        email = form.email.data
        password = form.password.data
        es_admin = form.es_admin.data
        if es_admin == 'si':
            es_admin = True
        else:
            es_admin = False
        
        usuarioExistente = User.find_by_username(username)
        if usuarioExistente is None:
            hashed_password = generate_password_hash(password)
            user_id = collectionUsuarios.insert_one({
                "nombre": username,
                "password": hashed_password,
                "email": email,
                "estado": "activo",
                "usuario_creacion": "paginaWebLugares",
                "es_administrador": es_admin,
                "fecha_creacion": datetime.now()
            }).inserted_id
            user = User(user_id, username, hashed_password)
            login_user(user)
            return redirect(url_for('lugares'))
        else:
            error = "El usuario ya existe."
    return render_template('registro.html', form=form, error=error)

@app.route('/logout')
@login_required
def logout():
    logout_user()
    return redirect(url_for('login'))

@app.route('/')
@login_required
def lugares():
    return render_template('pagina_principal.html')

@app.route('/ver-lugares')
@login_required
def ver_lugares():
    sitios = list(collectionSitios.find())
    recos = list(collectionRecos.find())

    # Crear un diccionario para mapear los IDs de los sitios a sus nombres
    sitios_dict = {str(sitio['_id']): sitio['nombre'] for sitio in sitios}

    # Añadir nombres de sitios cercanos y parecidos a las recomendaciones
    for reco in recos:
        reco['sitios_cercanos_nombres'] = [{'nombre': sitios_dict.get(str(cercano['_id']), 'Desconocido'), 'distancia': cercano['distancia']} for cercano in reco['sitios_cercanos']]
        reco['sitios_parecidos_nombres'] = [sitios_dict.get(str(parecido), 'Desconocido') for parecido in reco['sitios_parecidos']]

    return render_template('ver_sitios.html', sitios=sitios, recos=recos)

@app.route('/agregar-lugar', methods=['GET', 'POST'])
@login_required
def agregar_lugar():
    error = None
    form = AgregarLugarForm()
    if form.validate_on_submit():
        nombre = form.nombre.data
        descripcion = form.descripcion.data
        latitud = float(form.latitud.data)
        longitud = float(form.longitud.data)
        categoria = request.form.getlist('categorias')
        estado = form.estado.data


        lugarValido = collectionSitios.find_one({"nombre": nombre})
        if lugarValido is not None:
            error = "El lugar ya existe."
        else:
            collectionSitios.insert_one({
                "nombre": nombre,
                "descripcion": descripcion,
                "latitud": latitud,
                "longitud": longitud,
                "categorias": categoria,
                "estado": estado,
                "fecha_creacion": datetime.now(),
                'usuario_creo': current_user.username,
            })
            return redirect(url_for('ver_lugares'))
    return render_template('agregar_lugar.html', form=form, error=error)
    
@app.route('/borrar_lugar/<sitio_id>', methods=['DELETE'])
def borrar_lugar(sitio_id):
    try:
        collectionSitios.find_one_and_delete({'_id': ObjectId(sitio_id)})
        return jsonify({'success': True}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/users')
@login_required
def users():
    users_list = collectionUsuarios.find()
    return render_template('usuarios.html', users=users_list)

@app.route('/generar-recomendaciones', methods=['POST'])
@login_required
def generar_recomendaciones():
    recomendation = RecomendationHandler()
    recomendation.reset_recos_sitios_collection()
    recomendation.generar_recomendaciones(recomendation)
    return redirect(url_for('ver_lugares'))