from models import Usuario, Sitio, Recomendacion, Review, collectionSitios, collectionUsuarios

class SistemaRecomendacion:
    def __init__(self, json_sitio, json_usuario = None):
        self.sitio_actual = Sitio.from_json(json_sitio)
        self.usuario = Usuario.from_json(json_usuario)
        self.recomendaciones = []

    def generar_recomendacion(self):
        sitios_recomendados = collectionSitios.find({
            'categorias': {'$in': self.sitio_actual.categorias},
            'nombre': {'$ne': self.sitio_actual.nombre_sitio}
        }).sort([('calificacion_promedio', -1)]).limit(5)
        
        sitios_recomendados = list(sitios_recomendados)
        
        for sitio in sitios_recomendados:
            sitioObj = Sitio.find_by_name(sitio['nombre'])
            self.recomendaciones.append(Recomendacion(self.usuario, sitioObj))

        retorno = []
        for recomendacion in self.recomendaciones:
            site_json = recomendacion.sitio.to_json()
            retorno.append(site_json)

        return retorno

    def get_recomendaciones(self):
        return self.recomendaciones