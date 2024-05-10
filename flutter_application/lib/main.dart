import 'dart:convert';
import 'package:flutter_application_1/sitio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

// app starting point
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// homepage class
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
String apiUrlString = "https://b7ef-2800-300-69f1-a5d0-f4df-50b8-1871-712d.ngrok-free.app/api/sitios";
// homepage state
class _MyHomePageState extends State<MyHomePage> {

  // variable to call and store future list of sites
  Future<List<Sitio>> sitiosFuture = getSitios();

  // function to fetch data from api and return future list of sites
  static Future<List<Sitio>> getSitios() async {
    print("pase por aca");
    var url = Uri.parse(apiUrlString);
    final response = await http.get(url, headers: {"Content-Type": "application/json"});
    print(response.body);
    final List body = json.decode(response.body);
    return body.map((e) => Sitio.fromJson(e)).toList();
  }
  
  // build function
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // FutureBuilder
        child: FutureBuilder<List<Sitio>>(
          future: sitiosFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // until data is fetched, show loader
              return const CircularProgressIndicator();
            } else if (snapshot.hasData) {
              // once data is fetched, display it on screen (call buildSitios())
              final sitios = snapshot.data!;
              return buildSitios(sitios);
            } else if(snapshot.hasError) {
              // if no data, show simple Text
              return Text('Error: ${snapshot.error}');
            } else{
              return const Text(' no se que acaba de pasar');
            }
          },
        ),
      ),
    );
  }

  // function to display fetched data on screen
  Widget buildSitios(List<Sitio> sitios) {
    // ListView Builder to show data in a list
    return ListView.builder(
      itemCount: sitios.length,
      itemBuilder: (context, index) {
        final sitio = sitios[index];
        return Container(
          color: Colors.grey.shade300,
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          height: 100,
          width: double.maxFinite,
          child: Row(
            children: [
              Expanded(flex: 1, child: Column(children: [Text("latitud: ${sitio.latitud!}"),Text("longitud: ${sitio.longitud!}")])),
              const SizedBox(width: 10),
              Expanded(flex: 3, child: Text(sitio.nombre!)),
            ],
          ),
        );
      },
    );
  }
}
