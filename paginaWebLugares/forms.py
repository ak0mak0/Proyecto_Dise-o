from flask_wtf import FlaskForm
from wtforms import SelectField ,StringField, PasswordField, SubmitField, TextAreaField, FloatField, SelectMultipleField
from wtforms.validators import DataRequired

# Form para el login
class LoginForm(FlaskForm):
    username = StringField('username', validators=[DataRequired()])
    password = PasswordField('password', validators=[DataRequired()])
    submit = SubmitField('Login')

# Form para el registro
class RegistroForm(FlaskForm):
    username = StringField('username', validators=[DataRequired()])
    email = StringField('email', validators=[DataRequired()])
    password = PasswordField('password', validators=[DataRequired()])
    es_admin = SelectField('es_admin', choices=[('si', 'Sí'), ('no', 'No')], validators=[DataRequired()])
    submit = SubmitField('Registro')

# Form para agregar un lugar
class AgregarLugarForm(FlaskForm):
    nombre = StringField('nombre', validators=[DataRequired()])
    descripcion = TextAreaField('descripcion', validators=[DataRequired()])
    latitud = FloatField('latitud', validators=[DataRequired()])
    longitud = FloatField('longitud', validators=[DataRequired()])
    categorias = SelectField('categorias', choices=[('comida', 'Comida'), ('cultura', 'Cultura'), ('deporte', 'Deporte'), ('naturaleza', 'Naturaleza'), ('vidaNocturna', 'Vida Nocturna'), ('parque', 'Parque'), ('escultura', 'Escultura')], validators=[DataRequired()])
    estado = SelectField('estado', choices=[('activo', 'Activo'), ('inactivo', 'Inactivo')], validators=[DataRequired()]) 
    submit = SubmitField('Agregar Lugar')