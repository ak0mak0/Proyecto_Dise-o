class Sitios {
  String? direccion;
  String? id;
  String? nombre;

  Sitios({this.direccion, this.id, this.nombre});

  Sitios.fromJson(Map<String, dynamic> json) {
    direccion = json['direccion'];
    id = json['id'];
    nombre = json['nombre'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['direccion'] = direccion;
    data['id'] = id;
    data['nombre'] = nombre;
    return data;
  }
}