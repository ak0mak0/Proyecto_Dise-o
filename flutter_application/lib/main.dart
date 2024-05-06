import 'dart:convert';
import 'package:flutter_application_1/sitios.dart';
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
    return MaterialApp(
      home: const MyHomePage(),
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

// homepage state
class _MyHomePageState extends State<MyHomePage> {

  // variable to call and store future list of posts
  Future<List<Sitios>> postsFuture = getPosts();

  // function to fetch data from api and return future list of posts
  static Future<List<Sitios>> getPosts() async {
    print("pase por aca");
    var url = Uri.parse("https://edc2-186-189-71-211.ngrok-free.app/api/sitios");
    final response = await http.get(url, headers: {"Content-Type": "application/json"});
    print(response.body);
    final List body = json.decode(response.body);
    return body.map((e) => Sitios.fromJson(e)).toList();
  }
  
  // build function
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // FutureBuilder
        child: FutureBuilder<List<Sitios>>(
          future: postsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // until data is fetched, show loader
              return const CircularProgressIndicator();
            } else if (snapshot.hasData) {
              // once data is fetched, display it on screen (call buildPosts())
              final posts = snapshot.data!;
              return buildPosts(posts);
            } else {
              // if no data, show simple Text
              return const Text("no hay datos lalalala");
            }
          },
        ),
      ),
    );
  }

  // function to display fetched data on screen
  Widget buildPosts(List<Sitios> posts) {
    // ListView Builder to show data in a list
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return Container(
          color: Colors.grey.shade300,
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          height: 100,
          width: double.maxFinite,
          child: Row(
            children: [
              Expanded(flex: 1, child: Image.network(post.direccion!)),
              SizedBox(width: 10),
              Expanded(flex: 3, child: Text(post.nombre!)),
            ],
          ),
        );
      },
    );
  }
}
