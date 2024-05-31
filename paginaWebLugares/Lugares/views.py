from django.shortcuts import render, redirect
from .models import collection, generarID

def sitios(request):
    return render(request, 'pagina_principal.html') 

def agregarSitio(request):
    if request.method == 'POST':
        id_sitio = generarID("sitioid")
        latitud = float(request.POST.get('latitud'))
        longitud = float(request.POST.get('longitud'))
        nombre_sitio = request.POST.get('nombre_sitio')

        # Insertar datos en MongoDB
        nuevo_sitio = {"latitud": latitud, "longitud": longitud, "nombre_sitio": nombre_sitio}
        nuevo_sitio["_id"] = id_sitio
        sitioNoValido = collection.find_one({'nombre_sitio': nuevo_sitio['nombre_sitio']})
        
        if not sitioNoValido:
            collection.insert_one(nuevo_sitio)
            return render(request, 'lugar_creado.html')
        else:
            return render(request, 'creacion_erronea.html')            
    else:
        return render(request, 'crear_lugar.html')

def verSitios(request):
    sitios = list(collection.find())
    for sitio in sitios:
        sitio['id'] = str(sitio.pop('_id'))
    return render(request, 'ver_sitios.html', {'sitios': sitios})

def borrarSitios(request):
    if request.method == 'POST':
        idsEliminar = request.POST.getlist('listaSitiosEliminar')
        sitiosEliminados = list()
        for sitio in sitiosEliminados:
            sitio['id'] = str(sitio.pop('_id'))
    for id in idsEliminar:
            sitiosEliminados.append(collection.find_one({'_id': str(id)}))
            collection.delete_one({'_id': str(id)})
    return render(request, 'sitios_borrados.html', {'sitios': sitiosEliminados})