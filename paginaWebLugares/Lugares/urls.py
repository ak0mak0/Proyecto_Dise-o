from django.urls import path
from . import views

urlpatterns = [
    path("", views.sitios,  name= 'pagina principal'),
    path("crear", views.agregarSitio, name='crear sitios'),
    path("sitios", views.verSitios, name='ver sitios'),
    path("sitios/eliminar", views.borrarSitios, name='eliminar sitios')
]
