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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['direccion'] = this.direccion;
    data['id'] = this.id;
    data['nombre'] = this.nombre;
    return data;
  }
}