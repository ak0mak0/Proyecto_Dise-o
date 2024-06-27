import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:front/functions.dart';
import 'package:front/pages/sitio.dart';

class Sugerencia extends StatefulWidget {
  String sitio_id;
  String user_id;
  String name;
  Sugerencia(
      {super.key,
      required this.sitio_id,
      required this.user_id,
      required this.name});

  @override
  State<Sugerencia> createState() => _SugerenciaState();
}

class _SugerenciaState extends State<Sugerencia> {
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
          height: altura * 0.26,
          width: ancho * 0.44,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 236, 236, 236),
            borderRadius: BorderRadius.circular(23.0),
          ),
          child: Container(
            alignment: Alignment.center,
            height: altura * 0.22,
            width: ancho * 0.42,
            child: Text(
              widget.name,
              textAlign: TextAlign.center,
            ),
          ),
        ));
  }
}
