import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:front/functions.dart';
import 'package:front/objects/infositio.dart';
import 'package:front/pages/qrscreen.dart';
import 'package:google_fonts/google_fonts.dart';

class NoEscaneado extends StatefulWidget {
  final InfoSitio info;
  final String user_id;

  const NoEscaneado({super.key, required this.info, required this.user_id});

  @override
  State<NoEscaneado> createState() => _NoEscaneadoState();
}

class _NoEscaneadoState extends State<NoEscaneado> {
  @override
  Widget build(BuildContext context) {
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
                Container(
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
                                        color:
                                            const Color.fromRGBO(41, 52, 65, 1),
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
                                              fontWeight: FontWeight.w700)),
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
                                    color: Color.fromARGB(157, 41, 52, 65),
                                    fontSize: altura * 0.02,
                                    fontWeight: FontWeight.w400)),
                          ],
                        ),
                      ),

                      Container(
                        width: ancho * 0.9,
                        height: altura * 0.15,
                        alignment: Alignment.center,
                        child: Text(widget.info.descripcion,
                            textAlign: TextAlign.left,
                            style: GoogleFonts.nunito(
                                color: Color.fromARGB(157, 41, 52, 65),
                                fontSize: altura * 0.02,
                                fontWeight: FontWeight.w400)),
                      ),

                      SizedBox(
                        height: altura * 0.11,
                      ),
                      Container(
                        width: altura * 0.1,
                        height: altura * 0.1,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 121, 206, 128),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Color.fromARGB(255, 236, 236, 236),
                                width: 3)),
                        child: IconButton(
                          icon: Icon(
                            Icons.qr_code,
                            color: Color.fromARGB(255, 236, 236, 236),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      QRScreen(user_id: widget.user_id)),
                            );
                          },
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
