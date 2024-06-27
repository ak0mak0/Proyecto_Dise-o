import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Escogido extends StatefulWidget {
  final String info;

  const Escogido({super.key, required this.info});

  @override
  State<Escogido> createState() => _EscogidoState();
}

class _EscogidoState extends State<Escogido> {
  @override
  Widget build(BuildContext context) {
    double extra_top = MediaQuery.of(context).padding.top;
    double ancho = MediaQuery.of(context).size.width.toDouble();
    double altura = MediaQuery.of(context).size.height.toDouble() - extra_top;
    return Container(
      width: ancho * 0.8,
      alignment: Alignment.center,
      child: Text(widget.info,
          textAlign: TextAlign.left,
          style: GoogleFonts.nunito(
              color: Color.fromARGB(157, 41, 52, 65),
              fontSize: altura * 0.02,
              fontWeight: FontWeight.w400)),
    );
  }
}
