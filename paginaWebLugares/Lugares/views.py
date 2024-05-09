from django.shortcuts import render
from pymongo import MongoClient
from django.http import HttpResponseRedirect
from django.urls import reverse

def lugares(request):
    if request.method == 'POST':
        # Conexión a la base de datos MongoDB
        uri = "mongodb+srv://beespinoza2022:eVsJfxayY1I1586t@cluster0.yblbnqi.mongodb.net/?retryWrites=true&w=majority&appName=cluster0"
        client = MongoClient(uri)
        db = client["proyectoSemestralDis"]
        collection = db["lugares"]

        # Obtener datos del formulario
        nombre_lugar = request.POST.get('nombre_lugar')
        ubicacion_lugar = request.POST.get('ubicacion_lugar')

        # Insertar datos en MongoDB
        nuevo_lugar = {"nombre": nombre_lugar, "ubicacion": ubicacion_lugar}
        lugar = collection.find_one({'nombre': nuevo_lugar['nombre']})
        if not lugar:
            collection.insert_one(nuevo_lugar)
            return render(request, 'lugar_creado.html')
        else:
            return render(request, 'creacion_erronea.html')            
    else:
        # Renderizar el formulario
        return render(request, 'crear_lugar.html')
