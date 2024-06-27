import 'package:flutter/material.dart';
import 'package:front/objects/infositio.dart';
import 'package:front/objects/sugerencia.dart';
import 'package:front/pages/qrscreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:front/functions.dart';

class Principal extends StatefulWidget {
  final String user_id;

  const Principal({super.key, required this.user_id});

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  String nombre = "";

  bool cargadnoPopulares = true;
  List<InfoSitio> masPopulares = [];
  List<Widget> listaPopulares = [];

  bool cargandoGustados = true;
  List<InfoSitio> masGustados = [];
  List<Widget> listaGustados = [];

  bool cargadnoSitios = true;
  List<Widget> listaSitios = [];
  List<Widget> listaSitiosAux = [];

  void obtenerNombreYVisitados(String id) async {
    try {
      Map<String, dynamic> userData = await APIService.infoUser(id);
      setState(() {
        nombre = userData['nombre'] ?? 'Nombre no disponible';
      });
    } catch (e) {
      setState(() {
        nombre = 'Error al obtener el nombre';
      });
      print(e);
    }

    try {
      Map<String, dynamic> visitadosData = await APIService.mostvisited();
      List<dynamic> visitadosList = visitadosData['top_sitios_visitados'];
      for (String sitio in visitadosList) {
        InfoSitio infoParecido = await APIService.infoSitio(sitio);
        masPopulares.add(infoParecido);
      }
      setState(() {
        cargadnoPopulares = false;
      });
    } catch (e) {
      print(e);
    }

    try {
      Map<String, dynamic> visitadosData = await APIService.mostliked();
      List<dynamic> likesList = visitadosData['top_sitios_likes'];
      for (String sitio in likesList) {
        InfoSitio infoParecido = await APIService.infoSitio(sitio);
        masGustados.add(infoParecido);
      }
      setState(() {
        cargandoGustados = false;
      });
    } catch (e) {
      print(e);
    }

    try {
      // Obtener sitios cercanos
      List<List<String>> sitios = await APIService.getAllSites();
      for (List<String> sitio in sitios) {
        listaSitiosAux.add(Sugerencia(
          sitio_id: sitio[0],
          user_id: widget.user_id,
          name: sitio[1],
        ));
      }
      setState(() {
        cargadnoSitios = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    obtenerNombreYVisitados(widget.user_id);
  }

  @override
  Widget build(BuildContext context) {
    listaGustados.clear();
    listaPopulares.clear();
    listaSitios.clear();
    double extra_top = MediaQuery.of(context).padding.top;
    double extra_bottom = MediaQuery.of(context).padding.bottom;
    double ancho = MediaQuery.of(context).size.width.toDouble();
    double altura = MediaQuery.of(context).size.height.toDouble() - extra_top;

    for (InfoSitio sitio in masPopulares) {
      listaPopulares.add(
        SizedBox(width: ancho * 0.04),
      );
      listaPopulares.add(Sugerencia(
        sitio_id: sitio.sitio_id,
        user_id: widget.user_id,
        name: sitio.nombre,
      ));
      if (sitio == masPopulares.last) {
        listaPopulares.add(
          SizedBox(width: ancho * 0.04),
        );
      }
    }

    for (InfoSitio sitio in masGustados) {
      listaGustados.add(
        SizedBox(width: ancho * 0.04),
      );
      listaGustados.add(Sugerencia(
        sitio_id: sitio.sitio_id,
        user_id: widget.user_id,
        name: sitio.nombre,
      ));
      if (sitio == masGustados.last) {
        listaGustados.add(
          SizedBox(width: ancho * 0.04),
        );
      }
    }

    for (Widget Sugerencia in listaSitiosAux) {
      listaSitios.add(
        SizedBox(width: ancho * 0.04),
      );
      listaSitios.add(Sugerencia);
      if (Sugerencia == listaSitiosAux.last) {
        listaSitios.add(
          SizedBox(width: ancho * 0.04),
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        child: nombre == ""
            ? Container(
                alignment: Alignment.center,
                height: altura,
                width: ancho,
                child: CircularProgressIndicator(
                  color: Color.fromRGBO(230, 87, 56, 1),
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: extra_top,
                  ),

                  // app bar
                  Container(
                    height: altura * 0.1,
                  ),

                  // texto de bienvenida
                  Container(
                    width: ancho,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: ancho * 0.05,
                        ),
                        Text(nombre != null ? "Hola $nombre" : 'Cargando...',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.nunito(
                                color: const Color.fromRGBO(41, 52, 65, 1),
                                fontSize: altura * 0.035,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: altura * 0.008,
                  ),
                  Container(
                    width: ancho,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: ancho * 0.05,
                        ),
                        Text("Explora los mejores lugares a tu alrededor!",
                            textAlign: TextAlign.left,
                            style: GoogleFonts.nunito(
                                color: Color.fromARGB(157, 41, 52, 65),
                                fontSize: altura * 0.02,
                                fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: altura * 0.06,
                  ),

                  //Buscador
                  Container(
                      height: altura * 0.06,
                      width: ancho * 0.9,
                      color: Colors.white,
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 236, 236, 236),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText: 'Buscar destino...',
                                      hintStyle: GoogleFonts.nunito(
                                          color:
                                              Color.fromARGB(157, 41, 52, 65),
                                          fontWeight: FontWeight.w400),
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (value) {
                                      // Lógica para manejar el texto de búsqueda
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                              width: altura *
                                  0.06, // Ajusta el tamaño del contenedor según sea necesario
                              height: altura * 0.06,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromARGB(255, 236, 236, 236),
                              ),
                              child: Container(
                                width: altura *
                                    0.05, // Ajusta el tamaño del contenedor según sea necesario
                                height: altura * 0.05,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color.fromARGB(255, 223, 100,
                                      100), // Color de fondo del contenedor
                                ),
                                child: IconButton(
                                  icon: Icon(Icons.search),
                                  color: Color.fromARGB(255, 236, 236, 236),
                                  onPressed: () {
                                    // Lógica para manejar el botón de búsqueda
                                  },
                                  iconSize: altura *
                                      0.033, // Ajusta el tamaño del ícono según sea necesario
                                ),
                              ))
                        ],
                      )),

                  SizedBox(
                    height: altura * 0.07,
                  ),

                  //texto listaPopulares
                  Container(
                    width: ancho,
                    height: altura * 0.05,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: ancho * 0.05,
                        ),
                        Text("Mas visitados",
                            textAlign: TextAlign.left,
                            style: GoogleFonts.nunito(
                                color: Color.fromARGB(157, 41, 52, 65),
                                fontSize: altura * 0.02,
                                fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ),

                  cargadnoPopulares == true
                      ? Container(
                          alignment: Alignment.center,
                          height: altura * 0.26,
                          width: ancho,
                          child: CircularProgressIndicator(
                            color: Color.fromRGBO(230, 87, 56, 1),
                          ),
                        )
                      : Container(
                          height: altura * 0.26,
                          width: ancho,
                          child: //Sugerencias
                              SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: listaPopulares,
                            ),
                          ),
                        ),

                  SizedBox(
                    height: altura * 0.03,
                  ),

                  //texto Categorias Populares
                  Container(
                    width: ancho,
                    height: altura * 0.05,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: ancho * 0.05,
                        ),
                        Text("Con mas me gustas!",
                            textAlign: TextAlign.left,
                            style: GoogleFonts.nunito(
                                color: const Color.fromRGBO(41, 52, 65, 1),
                                fontSize: altura * 0.02,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),

                  cargandoGustados == true
                      ? Container(
                          alignment: Alignment.center,
                          height: altura * 0.26,
                          width: ancho,
                          child: CircularProgressIndicator(
                            color: Color.fromRGBO(230, 87, 56, 1),
                          ),
                        )
                      : Container(
                          height: altura * 0.26,
                          width: ancho,
                          child: //Sugerencias
                              SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: listaGustados,
                            ),
                          ),
                        ),

                  SizedBox(
                    height: altura * 0.03,
                  ),

                  //texto Categorias Populares
                  Container(
                    width: ancho,
                    height: altura * 0.05,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: ancho * 0.05,
                        ),
                        Text("Todos los sitios",
                            textAlign: TextAlign.left,
                            style: GoogleFonts.nunito(
                                color: const Color.fromRGBO(41, 52, 65, 1),
                                fontSize: altura * 0.02,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),

                  cargadnoSitios == true
                      ? Container(
                          alignment: Alignment.center,
                          height: altura * 0.26,
                          width: ancho,
                          child: CircularProgressIndicator(
                            color: Color.fromRGBO(230, 87, 56, 1),
                          ),
                        )
                      : Container(
                          height: altura * 0.26,
                          width: ancho,
                          child: //Sugerencias
                              SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: listaSitios,
                            ),
                          ),
                        ),

                  SizedBox(
                    height: extra_top,
                  ),
                ],
              ),
      ),

      //bottom bar
      bottomNavigationBar: Container(
          alignment: Alignment.center,
          width: ancho * 0.8,
          height: altura * 0.1,
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              border: Border(
                  top: BorderSide(
                      color: const Color.fromARGB(255, 201, 201, 201))),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: altura * 0.08,
                height: altura * 0.06,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 104, 104),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(
                        color: Color.fromARGB(255, 236, 236, 236), width: 3)),
                child: IconButton(
                  icon: Icon(
                    Icons.qr_code,
                    color: Color.fromARGB(255, 236, 236, 236),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              QRScreen(user_id: widget.user_id)),
                    );
                  },
                ),
              ),
            ],
          )),
    );
  }
}
