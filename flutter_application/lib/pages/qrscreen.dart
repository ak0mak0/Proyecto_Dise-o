import 'package:flutter/material.dart';
import 'package:front/functions.dart';
import 'package:front/pages/sitio.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class QRScreen extends StatefulWidget {
  final String user_id;

  const QRScreen({super.key, required this.user_id});

  @override
  _QRScreenState createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? _qrcontroller;
  bool _isScanned = false;
  bool _isLoading = false;
  String qrData = "";

  @override
  void initState() {
    super.initState();

    // Configuración de la interfaz de usuario del sistema
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor:
            Color.fromRGBO(0, 0, 0, 0), // Color de la barra de estado
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor:
            Color.fromARGB(255, 0, 0, 0), // Color de la barra de navegación
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color oscuro = Color.fromARGB(142, 0, 0, 0);
    double extra_top = MediaQuery.of(context).padding.top;
    double ancho = MediaQuery.of(context).size.width.toDouble();
    double altura = MediaQuery.of(context).size.height.toDouble() - extra_top;

    return Scaffold(
      body: Stack(
        children: [
          QRView(
            key: _qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
          Column(
            children: [
              Container(
                height: extra_top,
                width: ancho,
                color: oscuro,
              ),
              Container(
                alignment: Alignment.center,
                height: altura * 0.08,
                color: oscuro,
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: altura * 0.08,
                      width: altura * 0.09,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),
                    Text(
                      "Escanea el codigo QR",
                      style: GoogleFonts.poppins(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: altura * 0.026,
                          letterSpacing: 0.1,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                color: oscuro,
                height: altura * 0.25,
                width: ancho,
                child: Text(
                  "¡Escanea y descubre un nuevo \nsitio turístico!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: altura * 0.02,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    color: oscuro,
                    height: ancho * 0.7,
                    width: ancho * 0.15,
                  ),
                  Container(
                    color: oscuro,
                    height: ancho * 0.7,
                    width: ancho * 0.15,
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  color: oscuro,
                  width: ancho,
                  child: Container(
                    width: ancho * 0.25,
                    height: ancho * 0.25,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: ancho * 0.25,
                          height: ancho * 0.25,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(
                                81, 205, 205, 205), // Fondo transparente
                            border: Border.all(
                                color: Colors.white,
                                width: ancho * 0.005), // Borde blanco
                            borderRadius: BorderRadius.circular(
                                50), // Esquinas redondeadas
                          ),
                        ),
                        AnimatedContainer(
                          duration: Duration(
                              milliseconds: 500), // Duración de la animación
                          width: ancho * 0.215,
                          height: ancho * 0.215,
                          decoration: BoxDecoration(
                            color: _isLoading
                                ? Colors.grey
                                : _isScanned
                                    ? Color.fromRGBO(60, 195, 110, 1)
                                    : Color.fromRGBO(224, 121, 98,
                                        1), // Cambia el color basado en _isScanned
                            border: Border.all(
                                color: Colors.white,
                                width: ancho * 0.005), // Borde blanco
                            borderRadius: BorderRadius.circular(
                                50), // Esquinas redondeadas
                          ),
                          child: _isLoading
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )
                              : ElevatedButton(
                                  onPressed: _isScanned
                                      ? () => _registerSitioVisit(
                                          widget.user_id, qrData)
                                      : null,
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(Colors
                                            .transparent), // Fondo del botón transparente
                                    shadowColor:
                                        MaterialStateProperty.all<Color>(Colors
                                            .transparent), // Eliminar sombra
                                  ),
                                  child: Icon(
                                    Icons.search,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _qrcontroller = controller;
    });
    _qrcontroller?.scannedDataStream.listen((scanData) {
      if (!_isScanned) {
        setState(() {
          _isScanned = true;
          qrData = scanData.code ?? "";
        });
        // Aquí puedes manejar los datos del código QR escaneado
        print('Scanned data: ${scanData.code}');
      }
    });
  }

  Future<void> _registerSitioVisit(String userId, String qrData) async {
    print(userId);
    print(qrData);
    setState(() {
      _isLoading = true;
    });

    try {
      // Asume que qrData es un string que contiene el ID
      await APIService.registerVisit(userId, qrData); // Registrando la visita
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Sitio(
                  user_id: userId,
                  sitio_id: qrData,
                  estado: true,
                )),
      );
    } catch (e) {
      // Manejar la respuesta negativa
      print(e);
      // Aquí puedes mostrar un diálogo de error, una Snackbar, etc.
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _qrcontroller?.dispose();
    // Restaurar la configuración de la interfaz de usuario del sistema cuando se sale de la pantalla
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Color.fromARGB(38, 0, 0, 0),
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    super.dispose();
  }
}
