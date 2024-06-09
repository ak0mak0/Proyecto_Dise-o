from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, SubmitField
from wtforms.validators import DataRequired

class LoginForm(FlaskForm):
    username = StringField('username', validators=[DataRequired()])
    password = PasswordField('password', validators=[DataRequired()])
    submit = SubmitField('Login')

class RegistroForm(FlaskForm):
    username = StringField('username', validators=[DataRequired()])
    name = StringField('name', validators=[DataRequired()])
    password = PasswordField('password', validators=[DataRequired()])
    submit = SubmitField('Registro')

class AgregarLugarForm(FlaskForm):
    nombre = StringField('nombre', validators=[DataRequired()])
    latitud = StringField('latitud', validators=[DataRequired()])
    longitud = StringField('longitud', validators=[DataRequired()])
    submit = SubmitField('Agregar')