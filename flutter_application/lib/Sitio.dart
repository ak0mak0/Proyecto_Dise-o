class Sitio {
  String? direccion;
  double? longitud;
  double? latitud;
  int? id;
  String? nombre;

  Sitio({this.direccion, this.id, this.nombre});

  Sitio.fromJson(Map<String, dynamic> json) {
    latitud = json['latitud'];
    longitud = json['longitud'];
    id = json['id_sitio'];
    nombre = json['nombre_sitio'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitud'] = latitud;
    data['longitud'] = longitud;
    data['id_sitio'] = id;
    data['nombre_sitio'] = nombre;
    return data;
  }
}