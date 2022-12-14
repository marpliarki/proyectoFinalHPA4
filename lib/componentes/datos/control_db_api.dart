import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:proyecto1hpa4/componentes/clases/Asistencia.dart';
import 'package:proyecto1hpa4/componentes/clases/AsistenciaRegistro.dart';
import 'package:proyecto1hpa4/componentes/clases/Estudiante.dart';
import 'package:proyecto1hpa4/componentes/clases/Grupo.dart';
import 'package:proyecto1hpa4/componentes/clases/Usuario.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ControlDbApi {
  static String BASE_URL = "https://asistencia-upn43.ondigitalocean.app";

  /// URL de prueba definido en .env
  static get ENV_URL => dotenv.env["PRUEBA_API"] ?? BASE_URL;

  static Future<bool> getEstadoConexion() async {
    try {
      final response = await http.get(Uri.parse(BASE_URL)).timeout(
        const Duration(seconds: 3),
        onTimeout: () {
          // Timeout
          return http.Response('Error', 408);
        },
      );
      ;
      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      return false;
    }
  }

  static Future<Usuario?> loguearUsuario(
      String correo, String contrasena) async {
    final response = await http.post(
      Uri.parse("$BASE_URL/api/login"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{'usuario': correo, 'contrasena': contrasena}),
    );

    if (response.statusCode == 200) {
      print("ControlDbApi.loguearUsuario: Usuario autenticado");
      Map<String, dynamic> obj = jsonDecode(response.body);
      return Usuario.fromMap(obj["usuario"]);
    } else {
      print(
          "ControlDbApi.loguearUsuario: No se pudo loguear, codigo ${response.statusCode}");
    }

    return null;
  }

  static Future<List<Grupo>?> getGrupos(int id, TipoUsuario tipoUsuario) async {
    String tipo = tipoUsuario.name;

    try {
      final response =
          await http.get(Uri.parse("$BASE_URL/api/grupos/$tipo/$id"));
      if (response.statusCode == 200) {
        Iterable l = jsonDecode(response.body);
        List<Grupo> grupos =
            List<Grupo>.from(l.map((modelo) => Grupo.fromMap(modelo)));
        return grupos;
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<List<Estudiante>?> getEstudiantes() async {
    final response = await http.get(Uri.parse("$BASE_URL/api/estudiantes/all"));
    print("ControlDbApi.getEstudiantes:statusCode: ${response.statusCode}");

    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);

      List<Estudiante> estudiantes =
          List<Estudiante>.from(l.map((modelo) => Estudiante.fromMap(modelo)));

      return estudiantes;
    }
    return null;
  }

  static Future<List<Estudiante>?> getEstudiantesPorGrupo(int grupo_id) async {
    final response =
        await http.get(Uri.parse("$BASE_URL/api/estudiantes/grupos/$grupo_id"));
    print(
        "ControlDbApi.getEstudiantesPorGrupo:statusCode: ${response.statusCode}");

    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);

      List<Estudiante> estudiantes =
          List<Estudiante>.from(l.map((modelo) => Estudiante.fromMap(modelo)));

      return estudiantes;
    }
    return null;
  }

  static Future<List<Asistencia>?> getAsistenciasPorGrupoEstudiante(
      int estudiante_id, int grupo_id) async {
    final response = await http.get(Uri.parse(
        "$BASE_URL/api/estudiante/asistencia/$grupo_id/$estudiante_id"));
    print(
        "ControlDbApi.getAsistenciasPorGrupoEstudiante:statusCode: ${response.statusCode}");

    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);

      List<Asistencia> asistencias =
          List<Asistencia>.from(l.map((modelo) => Asistencia.fromMap(modelo)));

      return asistencias;
    }
    return null;
  }

  static Future<List<Asistencia>?> getAsistenciasPorGrupo(int grupo_id) async {
    final response = await http
        .get(Uri.parse("$BASE_URL/api/estudiantes/asistencia/$grupo_id"));
    print(
        "ControlDbApi.getAsistenciasPorGrupo:statusCode: ${response.statusCode}");

    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);

      List<Asistencia> asistencias =
          List<Asistencia>.from(l.map((modelo) => Asistencia.fromMap(modelo)));

      return asistencias;
    }
    return null;
  }

  static Future<bool> setAsistencias(
      List<AsistenciaRegistro> asistencias) async {
    var solicitudes = asistencias.map((e) {
      return http.post(
        Uri.parse("$BASE_URL/api/estudiante/asistencia"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: e.toAPIJson(),
      );
    });

    var todosCodigosDeEstadoOK = (await Future.wait(solicitudes)).map((e) {
      //print(e.body);
      return e.statusCode >= 200 && e.statusCode < 300;
    }).reduce((value, element) => value && element);

    if (todosCodigosDeEstadoOK) {
      print(
          "ControlDbApi.setAsistencias: Todas las asistencias fueron enviadas sin problemas");

      return true;
    }
    print(
        "ControlDbApi.setAsistencias: Hubo problemas con algunas asistencias");

    return false;
  }

  static Future<bool> setAsistencias_(
      List<AsistenciaRegistro> asistencias) async {
    var solicitudes = asistencias.map((e) {
      return http.post(
        Uri.parse("$ENV_URL/api/estudiante/asistencia"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: e.toAPIJson(),
      );
    });

    var todosCodigosDeEstadoOK = (await Future.wait(solicitudes)).map((e) {
      //print(e.body);
      return e.statusCode >= 200 && e.statusCode < 300;
    }).reduce((value, element) => value && element);

    if (todosCodigosDeEstadoOK) {
      print(
          "ControlDbApi.setAsistencias: Todas las asistencias fueron enviadas sin problemas");

      return true;
    }
    print(
        "ControlDbApi.setAsistencias: Hubo problemas con algunas asistencias");

    return false;
  }

  //METODOS DE PRUEBA

  static Future<List<Grupo>?> getGrupos_(String idEstudiante) async {
    try {
      final response =
          await http.get(Uri.parse("$ENV_URL/api/estudiante/grupos"));
      if (response.statusCode == 200) {
        Iterable l = jsonDecode(response.body);
        List<Grupo> grupos =
            List<Grupo>.from(l.map((modelo) => Grupo.fromMap(modelo)));
        return grupos;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Este metodo es una implementacion insegura para loguear un usuario
  /// Además, por ahora ni si quiera se pueden loguar profesores
  static Future<Usuario?> loguearUsuario_(String cedula) async {
    final response = await http.get(Uri.parse("$ENV_URL/api/login"));
    print("ControlDbApi.loguearUsuario:statusCode: ${response.statusCode}");

    if (response.statusCode == 200) {
      Map<String, dynamic> obj = jsonDecode(response.body);

      return Usuario.fromMap(obj["usuario"]);
    }
    return null;
  }

  static Future<List<Estudiante>?> getEstudiantes_() async {
    final response = await http.get(Uri.parse("$ENV_URL/api/estudiantes/all"));
    print("ControlDbApi.getEstudiantes_:statusCode: ${response.statusCode}");

    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);

      List<Estudiante> estudiantes =
          List<Estudiante>.from(l.map((modelo) => Estudiante.fromMap(modelo)));

      return estudiantes;
    }
    return null;
  }
}
