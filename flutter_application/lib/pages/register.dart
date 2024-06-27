import 'package:flutter/material.dart';
import 'package:front/pages/loggin.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:front/functions.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _IngresoState();
}

class _IngresoState extends State<Register> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _isLoading = false;

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await APIService.register(
          _username.text, _password.text, _email.text);
      if (result.containsKey('usuario')) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Loggin()),
        );
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['error'] ?? 'Error desconocido')),
        );
      }
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar usuario')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double extra_top = MediaQuery.of(context).padding.top;
    // double extra_bottom = MediaQuery.of(context).padding.bottom;
    double ancho = MediaQuery.of(context).size.width.toDouble();
    double altura = MediaQuery.of(context).size.height.toDouble() - extra_top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: extra_top,
            ),
            Container(
              width: ancho,
              height: altura * 0.1,
            ),

            Row(
              children: [
                SizedBox(
                  width: ancho * 0.05,
                ),
                Text("Crear cuenta",
                    style: GoogleFonts.poppins(
                        color: const Color.fromRGBO(41, 52, 65, 1),
                        fontSize: altura * 0.04,
                        fontWeight: FontWeight.w600)),
              ],
            ),

            SizedBox(
              height: altura * 0.05,
            ),

            // USERNAME
            Row(
              children: [
                SizedBox(
                  width: ancho * 0.05,
                ),
                Text("USERNAME :",
                    style: GoogleFonts.poppins(
                        color: Color.fromRGBO(41, 52, 65, 1),
                        fontSize: altura * 0.021,
                        fontWeight: FontWeight.w600)),
              ],
            ),

            SizedBox(
              height: altura * 0.01,
            ),

            Container(
              alignment: Alignment.center,
              width: ancho * 0.9,
              height: altura * 0.07,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(235, 239, 242, 1),
                  borderRadius: BorderRadius.circular(30)),
              child: TextField(
                enabled: !_isLoading, // Deshabilitar durante carga
                controller: _username,
                maxLines: 1,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  hintText: "Ingrese un nombre de ususario",
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    width: 2,
                    color: Colors.white,
                  )),
                ),
              ),
            ),

            SizedBox(
              height: altura * 0.02,
            ),

            // NOMBRE
            Row(
              children: [
                SizedBox(
                  width: ancho * 0.05,
                ),
                Text("CORREO ELECTRONICO :",
                    style: GoogleFonts.poppins(
                        color: Color.fromRGBO(41, 52, 65, 1),
                        fontSize: altura * 0.021,
                        fontWeight: FontWeight.w600)),
              ],
            ),

            SizedBox(
              height: altura * 0.01,
            ),

            Container(
              alignment: Alignment.center,
              width: ancho * 0.9,
              height: altura * 0.07,
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(235, 239, 242, 1),
                  borderRadius: BorderRadius.circular(30)),
              child: TextField(
                enabled: !_isLoading, // Deshabilitar durante carga
                controller: _email,
                maxLines: 1,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  hintText: "Ingrese su correo",
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    width: 2,
                    color: Colors.white,
                  )),
                ),
              ),
            ),

            SizedBox(
              height: altura * 0.01,
            ),

            // CONTRASEÑA
            Row(
              children: [
                SizedBox(
                  width: ancho * 0.05,
                ),
                Text("CONTRASEÑA :",
                    style: GoogleFonts.poppins(
                        color: Color.fromRGBO(41, 52, 65, 1),
                        fontSize: altura * 0.021,
                        fontWeight: FontWeight.w600)),
              ],
            ),

            SizedBox(
              height: altura * 0.01,
            ),

            Container(
              alignment: Alignment.center,
              width: ancho * 0.9,
              height: altura * 0.07,
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(235, 239, 242, 1),
                  borderRadius: BorderRadius.circular(30)),
              child: TextField(
                enabled: !_isLoading, // Deshabilitar durante carga
                controller: _password,
                maxLines: 1,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  hintText: "********",
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    width: 2,
                    color: Colors.white,
                  )),
                ),
              ),
            ),

            SizedBox(
              height: altura * 0.05,
            ),

            Container(
              width: ancho * 0.9,
              height: altura * 0.065,
              child: FloatingActionButton(
                heroTag: 'Crear cuenta',
                backgroundColor: Color.fromRGBO(230, 87, 56, 1),
                elevation: 0,
                onPressed: _isLoading ? null : _register,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(23))),
                child: _isLoading
                    ? SpinKitThreeBounce(
                        color: Colors.white,
                        size: 20.0,
                      )
                    : const Text("Registrarse",
                        style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        width: ancho * 0.8,
        height: altura * 0.05,
        child: FloatingActionButton(
          heroTag: 'ingreso',
          backgroundColor: Colors.white,
          elevation: 0,
          onPressed: _isLoading
              ? null
              : () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => Sitios()), // Cambia 'sitios' por 'Sitios()'
                  // );
                },
          child: const Text("¿Ya tienes una cuenta?",
              style: TextStyle(color: Color.fromRGBO(41, 52, 65, 1))),
        ),
      ),
    );
  }
}
