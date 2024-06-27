import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:front/functions.dart';
import 'package:front/objects/escogido.dart';
import 'package:front/objects/escogidoreco.dart';
import 'package:front/objects/infositio.dart';
import 'package:google_fonts/google_fonts.dart';

class Escaneado extends StatefulWidget {
  final InfoSitio info;
  final String user_id;

  const Escaneado({super.key, required this.info, required this.user_id});

  @override
  State<Escaneado> createState() => _EscaneadoState();
}

class _EscaneadoState extends State<Escaneado> {
  List<InfoSitio> listaCercanos = [];
  List<InfoSitio> listaParecidos = [];
  String cercano1 = "";
  String cercano2 = "";
  String cercano3 = "";
  String parecido1 = "";
  String parecido2 = "";
  String parecido3 = "";
  Widget escogido = Container();
  int val = 1;
  void obtenerDatos(String id) async {
    try {
      // Obtener sitios cercanos
      List<List<String>> cercanos = await APIService.getcercanos(id);
      for (List<String> sitio in cercanos) {
        InfoSitio infoCercano = await APIService.infoSitio(sitio[0]);
        listaCercanos.add(infoCercano);
      }

      // Obtener sitios parecidos
      List<String> parecidos = await APIService.getparecidos(id);
      for (String sitio in parecidos) {
        InfoSitio infoParecido = await APIService.infoSitio(sitio);
        listaParecidos.add(infoParecido);
      }

      setState(() {
        // Asignar valores a cercano1, cercano2, cercano3
        cercano1 = listaCercanos[0].nombre;
        cercano2 = listaCercanos[1].nombre;
        cercano3 = listaCercanos[2].nombre;

        // Asignar valores a parecido1, parecido2, parecido3
        parecido1 = listaParecidos[0].nombre;
        parecido2 = listaParecidos[1].nombre;
        parecido3 = listaParecidos[2].nombre;
      });
    } catch (e) {
      setState(() {
        cercano1 = 'No disponible';
        cercano2 = 'No disponible';
        cercano3 = 'No disponible';
        parecido1 = 'No disponible';
        parecido2 = 'No disponible';
        parecido3 = 'No disponible';
      });
      print(e);
    }
  }

  void _escogido(InfoSitio id, String user) async {
    if (val == 1) {
      escogido = Escogido(info: id.descripcion);
    } else if (val == 2) {
      escogido = Escogido(info: id.detalles);
    } else if (val == 3) {
      escogido = Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Recomendacion(
              sitio_id: listaParecidos[0].sitio_id,
              user_id: user,
              name: listaParecidos[0].nombre),
          Recomendacion(
              sitio_id: listaParecidos[1].sitio_id,
              user_id: user,
              name: listaParecidos[1].nombre),
          Recomendacion(
              sitio_id: listaParecidos[2].sitio_id,
              user_id: user,
              name: listaParecidos[2].nombre),
        ],
      );
    } else {
      escogido = Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Recomendacion(
              sitio_id: listaCercanos[0].sitio_id,
              user_id: user,
              name: listaCercanos[0].nombre),
          Recomendacion(
              sitio_id: listaCercanos[1].sitio_id,
              user_id: user,
              name: listaCercanos[1].nombre),
          Recomendacion(
              sitio_id: listaCercanos[2].sitio_id,
              user_id: user,
              name: listaCercanos[2].nombre),
        ],
      );
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    obtenerDatos(widget.info.sitio_id);
  }

  @override
  Widget build(BuildContext context) {
    _escogido(widget.info, widget.user_id);
    String nombre = widget.info.nombre;
    int visitas = widget.info.cantVisitas;
    int cant_calificaciones = widget.info.cantCalificaciones;
    double calificacion_promedio = widget.info.calificacionPromedio;

    double extra_top = MediaQuery.of(context).padding.top;
    double ancho = MediaQuery.of(context).size.width.toDouble();
    double altura = (MediaQuery.of(context).size.height.toDouble() - extra_top);
    return Stack(
      children: [
        // EXPANDE ESPACIO DE STACK
        SizedBox.expand(),

        // MITAD IMAGEN
        Stack(
          children: [
            Container(
              color: Color.fromARGB(255, 240, 140, 133),
              width: ancho,
              height: altura * 0.6,
            )
          ],
        ),

        //MITAD INFORMACION
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Stack(
              children: [
                // CONTAINER DE FONDO
                Container(
                  height: altura * 0.55,
                  width: ancho,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40)),
                  ),
                ),

                // NOMBRE Y VISITAS DE SITIO
                parecido3 == ""
                    ? Container(
                        alignment: Alignment.center,
                        height: altura * 0.55,
                        width: ancho,
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        width: ancho,
                        child: Column(
                          children: [
                            SizedBox(
                              height: altura * 0.04,
                            ),

                            // NOMBRE LUGAR
                            Container(
                                width: ancho * 0.9,
                                height: altura * 0.05,
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      width: ancho * 0.75,
                                      child: Text(nombre,
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.nunito(
                                              color: const Color.fromRGBO(
                                                  41, 52, 65, 1),
                                              fontSize: altura * 0.035,
                                              fontWeight: FontWeight.w700)),
                                    ),
                                    Container(
                                        alignment: Alignment.center,
                                        width: ancho * 0.15,
                                        child: Row(
                                          children: [
                                            Text(visitas.toString(),
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.nunito(
                                                    color: const Color.fromRGBO(
                                                        41, 52, 65, 1),
                                                    fontSize: altura * 0.035,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                          ],
                                        ))
                                  ],
                                )),

                            // CALIFICACION LUGAR
                            Container(
                              width: ancho * 0.9,
                              height: altura * 0.05,
                              alignment: Alignment.center,
                              child: Row(
                                children: [
                                  Icon(Icons.star_rounded),
                                  Text(
                                      calificacion_promedio.toString() +
                                          "(" +
                                          cant_calificaciones.toString() +
                                          ")",
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.nunito(
                                          color:
                                              Color.fromARGB(157, 41, 52, 65),
                                          fontSize: altura * 0.02,
                                          fontWeight: FontWeight.w400)),
                                ],
                              ),
                            ),

                            // ELEGIR INFROMACION
                            Container(
                              width: ancho,
                              height: altura * 0.1,
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: ancho * 0.25,
                                    height: altura * 0.06,
                                    child: FloatingActionButton(
                                      heroTag: 'Resumen',
                                      backgroundColor:
                                          Color.fromRGBO(235, 227, 118, 0),
                                      elevation: 0,
                                      onPressed: () {
                                        val = 1;
                                        setState(() {});
                                      },
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(0))),
                                      child: Text("Resumen",
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.nunito(
                                              color: Color.fromARGB(
                                                  157, 41, 52, 65),
                                              fontSize: altura * 0.02,
                                              fontWeight: FontWeight.w400)),
                                    ),
                                  ),
                                  Container(
                                    width: ancho * 0.25,
                                    height: altura * 0.06,
                                    child: FloatingActionButton(
                                      heroTag: 'Detalles',
                                      backgroundColor:
                                          Color.fromRGBO(235, 227, 118, 0),
                                      elevation: 0,
                                      onPressed: () {
                                        val = 2;
                                        setState(() {});
                                      },
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(0))),
                                      child: Text("Detalles",
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.nunito(
                                              color: Color.fromARGB(
                                                  157, 41, 52, 65),
                                              fontSize: altura * 0.02,
                                              fontWeight: FontWeight.w400)),
                                    ),
                                  ),
                                  Container(
                                    width: ancho * 0.25,
                                    height: altura * 0.06,
                                    child: FloatingActionButton(
                                      heroTag: 'Cercanos',
                                      backgroundColor:
                                          Color.fromRGBO(235, 227, 118, 0),
                                      elevation: 0,
                                      onPressed: () {
                                        val = 3;
                                        setState(() {});
                                      },
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(0))),
                                      child: Text("Cercanos",
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.nunito(
                                              color: Color.fromARGB(
                                                  157, 41, 52, 65),
                                              fontSize: altura * 0.02,
                                              fontWeight: FontWeight.w400)),
                                    ),
                                  ),
                                  Container(
                                    width: ancho * 0.25,
                                    height: altura * 0.06,
                                    child: FloatingActionButton(
                                      heroTag: 'Parecidos',
                                      backgroundColor:
                                          Color.fromRGBO(235, 227, 118, 0),
                                      elevation: 0,
                                      onPressed: () {
                                        val = 4;
                                        setState(() {});
                                      },
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(0))),
                                      child: Text("Parecidos",
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.nunito(
                                              color: Color.fromARGB(
                                                  157, 41, 52, 65),
                                              fontSize: altura * 0.02,
                                              fontWeight: FontWeight.w400)),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // INFORMACION ELEGIDA
                            Container(
                              height: altura * 0.21,
                              width: ancho * 0.9,
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 235, 235, 235),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              alignment: Alignment.center,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [escogido],
                                ),
                              ),
                            ),

                            //FUNCIONES ADICIONALES
                            Container(
                              width: ancho * 0.9,
                              height: altura * 0.1,
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: ancho * 0.32,
                                    height: altura * 0.06,
                                    child: FloatingActionButton(
                                      heroTag: 'Calificar',
                                      backgroundColor:
                                          Color.fromRGBO(235, 227, 118, 1),
                                      elevation: 0,
                                      onPressed: () {},
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(23))),
                                      child: Text("CALIFICAR",
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.nunito(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            fontSize: altura * 0.025,
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
              ],
            )
          ],
        )
      ],
    );
  }
}
