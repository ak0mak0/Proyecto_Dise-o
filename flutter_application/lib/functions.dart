import 'dart:convert';
import 'package:front/objects/infositio.dart';
import 'package:http/http.dart' as http;

class APIService {
  static const String baseURL = 'http://51.79.105.168:8160/';

  static Future<Map<String, dynamic>> fetchSitio(String id) async {
    final response = await http.post(
      Uri.parse('${baseURL}getsitio'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'_id': id}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      return {'error': 'Sitio no encontrado'};
    } else {
      throw Exception('Failed to load data');
    }
  }

  // FUNCION PARA INICIAR SESION
  static Future<String> login(String nombre, String password) async {
    final response = await http.post(
      Uri.parse('${baseURL}login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'nombre': nombre,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (responseData.containsKey('user_id')) {
        return responseData['user_id'];
      } else {
        throw Exception('user_id not found in response');
      }
    } else if (response.statusCode == 401) {
      throw Exception('Contraseña incorrecta');
    } else if (response.statusCode == 404) {
      throw Exception('Usuario no encontrado');
    } else {
      throw Exception('Failed to login');
    }
  }

  // FUNCION PARA OBTENMER IFNORMACION DE USUARIO
  static Future<Map<String, dynamic>> infoUser(String _id) async {
    final response = await http.post(
      Uri.parse('${baseURL}userinfo'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': _id,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception('Contraseña incorrecta');
    } else if (response.statusCode == 404) {
      throw Exception('Usuario no encontrado');
    } else {
      throw Exception('Failed to login');
    }
  }

  // FUNCION PARA OBTENER INFORMACION DE SITIOS
  static Future<InfoSitio> infoSitio(String _id) async {
    final response = await http.post(
      Uri.parse('${baseURL}get_info_sitio'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'sitio_id': _id,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      InfoSitio infoSitio = InfoSitio.fromJson(jsonResponse);
      infoSitio.sitio_id = _id;
      return infoSitio;
    } else if (response.statusCode == 401) {
      throw Exception('Contraseña incorrecta');
    } else if (response.statusCode == 404) {
      throw Exception('Usuario no encontrado');
    } else {
      throw Exception('Failed to login');
    }
  }

  // FUNCION PARA OBTENER SITIOS CERCANOS
  static Future<List<List<String>>> getcercanos(String _id) async {
    final response = await http.post(
      Uri.parse('${baseURL}getcercanos'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'sitio_id': _id,
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      if (jsonData.containsKey('sitios_cercanos')) {
        List<dynamic> sitiosCercanos = jsonData['sitios_cercanos'];
        List<List<String>> result = [];
        for (var sitio in sitiosCercanos) {
          result.add([sitio['object_id'], sitio['distancia'].toString()]);
        }
        return result;
      } else {
        throw Exception('Clave sitios_cercanos no encontrada en la respuesta');
      }
    } else if (response.statusCode == 401) {
      throw Exception('Contraseña incorrecta');
    } else if (response.statusCode == 404) {
      throw Exception('Usuario no encontrado');
    } else {
      throw Exception('Error al obtener sitios cercanos');
    }
  }

  // FUNCION PARA OBTENMER SITIOS PARECIDOS
  static Future<List<String>> getparecidos(String _id) async {
    final response = await http.post(
      Uri.parse('${baseURL}getparecidos'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'sitio_id': _id,
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      if (jsonData.containsKey('sitios_parecidos')) {
        return List<String>.from(jsonData['sitios_parecidos']);
      } else {
        throw Exception('Clave sitios_parecidos no encontrada en la respuesta');
      }
    } else if (response.statusCode == 401) {
      throw Exception('Contraseña incorrecta');
    } else if (response.statusCode == 404) {
      throw Exception('Usuario no encontrado');
    } else {
      throw Exception('Error al obtener sitios parecidos');
    }
  }

  // OBTENER SITIOS MAS VISITADOS
  static Future<Map<String, dynamic>> mostvisited() async {
    final response = await http.get(
      Uri.parse('${baseURL}get_top_visited'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      return jsonData;
    } else if (response.statusCode == 401) {
      throw Exception('Contraseña incorrecta');
    } else if (response.statusCode == 404) {
      throw Exception('Usuario no encontrado');
    } else {
      throw Exception('Failed to login');
    }
  }

  // OBTENER SITIOS MAS LIKEADOS
  static Future<Map<String, dynamic>> mostliked() async {
    final response = await http.get(
      Uri.parse('${baseURL}get_top_liked'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      return jsonData;
    } else if (response.statusCode == 401) {
      throw Exception('Contraseña incorrecta');
    } else if (response.statusCode == 404) {
      throw Exception('Usuario no encontrado');
    } else {
      throw Exception('Failed to login');
    }
  }

  // FUNCION PARA OBTENER TODOS LOS SITIOS
  static Future<List<List<String>>> getAllSites() async {
    final response = await http.get(
      Uri.parse('${baseURL}get_sitios'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      if (jsonData.containsKey('sitios')) {
        List<dynamic> sitiosCercanos = jsonData['sitios'];
        List<List<String>> result = [];
        for (var sitio in sitiosCercanos) {
          result.add([sitio['id'], sitio['nombre'].toString()]);
        }
        return result;
      } else {
        throw Exception('Clave sitios_cercanos no encontrada en la respuesta');
      }
    } else if (response.statusCode == 401) {
      throw Exception('Contraseña incorrecta');
    } else if (response.statusCode == 404) {
      throw Exception('Usuario no encontrado');
    } else {
      throw Exception('Error al obtener sitios cercanos');
    }
  }

  static Future<bool> checkVisito(Map<String, String> data) async {
    final response = await http.post(
      Uri.parse('${baseURL}getvisito'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse.containsKey('visito')) {
        return jsonResponse['visito'];
      } else {
        throw Exception('Clave "visito" no encontrada en la respuesta');
      }
    } else if (response.statusCode == 401) {
      throw Exception('Contraseña incorrecta');
    } else if (response.statusCode == 404) {
      return false;
    } else {
      throw Exception('Error al obtener información de visita');
    }
  }

  // FUNCION PARA REGISTRARSE
  static Future<Map<String, dynamic>> register(
      String nombre, String password, String email) async {
    final response = await http.post(
      Uri.parse('${baseURL}register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'nombre': nombre,
        'password': password,
        'email': email,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 400) {
      return jsonDecode(response
          .body); // Esto devolverá el mensaje de error proporcionado por el backend
    } else {
      throw Exception('Failed to register');
    }
  }

  static Future<Map<String, dynamic>> registerVisit(
      String idUsuario, String idSitio) async {
    final response = await http.post(
      Uri.parse('${baseURL}registersitio'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id_usuario': idUsuario,
        'id_sitio': idSitio,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 400) {
      return jsonDecode(response
          .body); // Esto devolverá el mensaje de error proporcionado por el backend
    } else {
      throw Exception('Failed to register visit');
    }
  }
}
