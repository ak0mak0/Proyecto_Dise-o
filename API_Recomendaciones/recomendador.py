from models import Usuario, Sitio, collectionSitios, collectionUsuarios

class SistemaRecomendacion:
    def __init__(self, json_sitio, json_usuario = None):
        self.sitio_actual = Sitio.from_json(json_sitio)
        self.usuario = Usuario.from_json(json_usuario)

    def generar_recomendacion(self):
        sitios_recomendados = collectionSitios.find({
            'tags': {'$in': self.sitio_actual.tags},
            #'categoria': self.sitio_actual.categoria,
            'nombre_sitio': {'$ne': self.sitio_actual.nombre_sitio}
        }).sort([('rating', -1), ('popularidad', -1)]).limit(5)

        recomendaciones = []
        for site in sitios_recomendados:
            site_obj = Sitio.from_json(site)
            recomendaciones.append(site_obj.to_json())

        return recomendaciones
