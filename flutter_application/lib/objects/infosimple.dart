class InfoSitio {
  String sitio_id = "";
  String nombre;

  InfoSitio({
    required this.nombre,
  });

  factory InfoSitio.fromJson(Map<String, dynamic> json) {
    return InfoSitio(
      nombre: json['nombre'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
    };
  }
}
