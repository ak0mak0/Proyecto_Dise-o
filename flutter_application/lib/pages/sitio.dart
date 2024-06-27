import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:front/objects/escaneado.dart';
import 'package:front/objects/infositio.dart';
import 'package:front/objects/noescaneado.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:front/functions.dart';

class Sitio extends StatefulWidget {
  final String user_id;
  final String sitio_id;
  final bool estado;

  const Sitio(
      {super.key,
      required this.user_id,
      required this.sitio_id,
      required this.estado});

  @override
  State<Sitio> createState() => _SitioState();
}

class _SitioState extends State<Sitio> {
  String nombre = "";
  InfoSitio info = InfoSitio(
    calificacionPromedio: 0.0,
    cantCalificaciones: 0,
    cantLikes: 0,
    cantVisitas: 0,
    categorias: [],
    descripcion: '',
    detalles: '',
    estado: '',
    fechaCreacion: DateTime(1970, 1, 1), // Fecha por defecto
    latitud: 0.0,
    longitud: 0.0,
    nombre: '',
    resenas: [],
    ultimoIngreso: DateTime(1970, 1, 1), // Fecha por defecto
    usuarioCreacion: '',
  );
  Widget tipoinfo = Container();

  void obtenerDatos(String id, bool state, String user) async {
    try {
      // Obtener información del sitio
      info = await APIService.infoSitio(id);
      if (state == true) {
        tipoinfo = Escaneado(
          info: info,
          user_id: user,
        );
      } else {
        tipoinfo = NoEscaneado(
          info: info,
          user_id: user,
        );
      }
      setState(() {
        nombre = info.nombre;
      });
    } catch (e) {
      setState(() {});
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    obtenerDatos(widget.sitio_id, widget.estado, widget.user_id);
  }

  @override
  Widget build(BuildContext context) {
    double extra_top = MediaQuery.of(context).padding.top;
    // double extra_bottom = MediaQuery.of(context).padding.bottom;
    double ancho = MediaQuery.of(context).size.width.toDouble();
    double altura = MediaQuery.of(context).size.height.toDouble() - extra_top;

    return Scaffold(
        backgroundColor: Colors.white,
        body: nombre == ""
            ? Container(
                alignment: Alignment.center,
                height: altura,
                width: ancho,
                child: CircularProgressIndicator(),
              )
            : tipoinfo);
  }
}
