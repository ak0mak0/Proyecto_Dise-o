import 'package:flutter/material.dart';
import 'package:front/functions.dart';
import 'package:front/pages/sitio.dart';

class Recomendacion extends StatefulWidget {
  String sitio_id;
  String user_id;
  String name;
  Recomendacion(
      {super.key,
      required this.sitio_id,
      required this.user_id,
      required this.name});

  @override
  State<Recomendacion> createState() => _RecomendacionState();
}

class _RecomendacionState extends State<Recomendacion> {
  bool estado = true;

  Future<void> _registerSitioVisit(
      String userId, String sitioId, bool state) async {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Sitio(
                  user_id: userId,
                  sitio_id: sitioId,
                  estado: state,
                )),
      );
    } catch (e) {
      // Manejar la respuesta negativa
      print(e);
      // Aquí puedes mostrar un diálogo de error, una Snackbar, etc.
    } finally {}
  }

  Future<void> _abrirSitio(String userId, String sitioId) async {
    try {
      estado = await APIService.checkVisito(
          {'id_usuario': userId, 'id_sitio': sitioId});
      _registerSitioVisit(userId, sitioId, estado);
    } catch (e) {
      setState(() {});
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    double extra_top = MediaQuery.of(context).padding.top;
    double ancho = MediaQuery.of(context).size.width.toDouble();
    double altura = MediaQuery.of(context).size.height.toDouble() - extra_top;
    return GestureDetector(
        onTap: () {
          _abrirSitio(widget.user_id, widget.sitio_id);
        },
        child: Container(
          alignment: Alignment.center,
          height: altura * 0.15,
          width: ancho * 0.25,
          decoration: BoxDecoration(
            color: Color.fromRGBO(230, 87, 56, 1),
            borderRadius: BorderRadius.circular(23.0),
          ),
          child: Container(
            alignment: Alignment.center,
            height: altura * 0.2,
            width: ancho * 0.3,
            child: Text(widget.name,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white)),
          ),
        ));
  }
}
