import 'package:intl/intl.dart';

class InfoSitio {
  String sitio_id = "";
  double calificacionPromedio;
  int cantCalificaciones;
  int cantLikes;
  int cantVisitas;
  List<String> categorias;
  String descripcion;
  String detalles;
  String estado;
  DateTime fechaCreacion;
  double latitud;
  double longitud;
  String nombre;
  List<dynamic>
      resenas; // Puedes definir una clase Reseña si tienes más detalles sobre las reseñas
  DateTime ultimoIngreso;
  String usuarioCreacion;

  InfoSitio({
    required this.calificacionPromedio,
    required this.cantCalificaciones,
    required this.cantLikes,
    required this.cantVisitas,
    required this.categorias,
    required this.descripcion,
    required this.detalles,
    required this.estado,
    required this.fechaCreacion,
    required this.latitud,
    required this.longitud,
    required this.nombre,
    required this.resenas,
    required this.ultimoIngreso,
    required this.usuarioCreacion,
  });

  factory InfoSitio.fromJson(Map<String, dynamic> json) {
    final DateFormat format =
        DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'", "en_US");
    return InfoSitio(
      calificacionPromedio: json['calificacion_promedio'],
      cantCalificaciones: json['cant_calificaciones'],
      cantLikes: json['cant_likes'],
      cantVisitas: json['cant_visitas'],
      categorias: List<String>.from(json['categorias']),
      descripcion: json['descripcion'],
      detalles: json['detalles'],
      estado: json['estado'],
      fechaCreacion: format.parse(json['fecha_creacion']),
      latitud: json['latitud'],
      longitud: json['longitud'],
      nombre: json['nombre'],
      resenas: List<dynamic>.from(json['reseñas']),
      ultimoIngreso: format.parse(json['ultimo_ingreso']),
      usuarioCreacion: json['usuario_creacion'],
    );
  }

  Map<String, dynamic> toJson() {
    final DateFormat format =
        DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'", "en_US");
    return {
      'calificacion_promedio': calificacionPromedio,
      'cant_calificaciones': cantCalificaciones,
      'cant_likes': cantLikes,
      'cant_visitas': cantVisitas,
      'categorias': categorias,
      'descripcion': descripcion,
      'detalles': detalles,
      'estado': estado,
      'fecha_creacion': format.format(fechaCreacion),
      'latitud': latitud,
      'longitud': longitud,
      'nombre': nombre,
      'reseñas': resenas,
      'ultimo_ingreso': format.format(ultimoIngreso),
      'usuario_creacion': usuarioCreacion,
    };
  }
}
