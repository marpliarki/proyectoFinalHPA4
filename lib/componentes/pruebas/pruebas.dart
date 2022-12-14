import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proyecto1hpa4/componentes/clases/Grupo.dart';

import '../datos/control_db_api.dart';

class Prueba {
  static Future<void> probarLogin() async {
    final response = await http.post(
      Uri.parse("${ControlDbApi.BASE_URL}/api/login"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'usuario': "zamorin@utp.ac.pa",
        'contrasena': "123456789"
      }),
    );

    if (response.statusCode == 200) {
      print("Usuario autenticado");
    } else {
      print("No se pudo loguear, codigo ${response.statusCode}");
    }
  }
}

Grupo GRUPO_PRUEBA = Grupo.fromJson("""{
  "id": 1,
  "asignatura": "Herramientas de Programacion Aplicada IV",
  "codigo_asignatura": "0757",
  "docente_id": 1,
  "grupo": "1IL141",
  "periodo": "II SEM 2022",
  "created_at": "2022-11-08T19:19:13.000000Z",
  "updated_at": "2022-11-08T19:19:13.000000Z"
}""");
