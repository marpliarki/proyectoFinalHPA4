import 'package:proyecto1hpa4/componentes/clases/Asistencia.dart';
import 'package:proyecto1hpa4/componentes/clases/AsistenciaRegistro.dart';
import 'package:proyecto1hpa4/componentes/clases/Estudiante.dart';
import 'package:proyecto1hpa4/componentes/clases/Grupo.dart';
import 'package:proyecto1hpa4/componentes/clases/Usuario.dart';
import 'package:proyecto1hpa4/componentes/datos/control_db_api.dart';
import 'package:proyecto1hpa4/componentes/datos/control_db_local.dart';

class ControlDb {
  static String BASE_URL = "https://asistencia-upn43.ondigitalocean.app/api";

  static Future<Usuario?> loguearUsuario(
      String correo, String contrasena) async {
    return ControlDbApi.loguearUsuario(correo, contrasena);
  }

  static Future<List<Grupo>?> getGrupos(int id, TipoUsuario tipo) async {
    bool hayConexion = await ControlDbApi.getEstadoConexion();
    print("ControlDb.getGrupos: id=$id, tipo=$tipo");
    if (hayConexion) {
      //Obtener de API
      var resultados = await ControlDbApi.getGrupos(id, tipo);
      //print(await BaseDatos.getDireccionBd());

      //Guardar en base de datos
      if (resultados != null) {
        try {
          await ControlDbLocal.setGrupos_(resultados);
        } catch (e) {
          print(e);
        }
      }
      //Retornar resultados
      return resultados;
    } else {
      //Cargar de base de datos
      try {
        return await ControlDbLocal.getGrupos_(id);
      } catch (e) {
        print(e);
      }
    }
    return null;
  }

  static Future<List<Estudiante>?> getEstudiantes() async {
    bool hayConexion = await ControlDbApi.getEstadoConexion();
    print("ControlDb.getGrupos: todos");
    if (hayConexion) {
      //Obtener de API
      var resultados = await ControlDbApi.getEstudiantes();
      //Guardar en base de datos
      if (resultados != null) {
        try {
          await ControlDbLocal.setEstudiantes(resultados);
        } catch (e) {
          print(e);
        }
      }
      //Retornar resultados
      return resultados;
    } else {
      //Cargar de base de datos
      try {
        return await ControlDbLocal.getEstudiantes();
      } catch (e) {
        print(e);
      }
    }
    return null;
  }

  static Future<List<Estudiante>?> getEstudiantesPorGrupo(int grupo_id) async {
    print("ControlDb.getEstudiantesPorGrupo: grupo_id=$grupo_id");
    bool hayConexion = await ControlDbApi.getEstadoConexion();

    if (hayConexion) {
      //Obtener de API
      var resultados = await ControlDbApi.getEstudiantesPorGrupo(grupo_id);
      //Guardar en base de datos
      if (resultados != null) {
        try {
          await ControlDbLocal.setEstudiantesPorGrupo(resultados, grupo_id);
        } catch (e) {
          print(e);
        }
      }
      //Retornar resultados
      return resultados;
    } else {
      //Cargar de base de datos
      try {
        return await ControlDbLocal.getEstudiantesPorGrupo(grupo_id);
      } catch (e) {
        print(e);
      }
    }
    return null;
  }

  static Future<List<Asistencia>?> getAsistenciasPorGrupoEstudiante(
      int eid, int gid) async {
    bool hayConexion = await ControlDbApi.getEstadoConexion();
    print("ControlDb.getGrupos: estudiante=$eid, grupo=$gid");
    if (hayConexion) {
      //Obtener de API
      var resultados =
          await ControlDbApi.getAsistenciasPorGrupoEstudiante(eid, gid);
      //Guardar en base de datos
      if (resultados != null) {
        try {
          await ControlDbLocal.setAsistencias(resultados);
        } catch (e) {
          print(e);
        }
      }
      //Retornar resultados
      return resultados;
    } else {
      //Cargar de base de datos
      try {
        return await ControlDbLocal.getAsistenciasPorGrupoEstudiante(eid, gid);
      } catch (e) {
        print(e);
      }
    }
    return null;
  }

  static Future<List<Asistencia>?> getAsistenciasPorGrupo(int gid) async {
    bool hayConexion = await ControlDbApi.getEstadoConexion();
    print("ControlDb.getGrupos: grupo=$gid");
    if (hayConexion) {
      //Obtener de API
      var resultados = await ControlDbApi.getAsistenciasPorGrupo(gid);
      //Guardar en base de datos
      if (resultados != null) {
        try {
          await ControlDbLocal.setAsistencias(resultados);
        } catch (e) {
          print(e);
        }
      }
      //Retornar resultados
      return resultados;
    } else {
      //Cargar de base de datos
      try {
        return await ControlDbLocal.getAsistenciasPorGrupo(gid);
      } catch (e) {
        print(e);
      }
    }
    return null;
  }

  static Future<bool> setAsistencias(List<AsistenciaRegistro> asistencias) {
    return ControlDbApi.setAsistencias(asistencias);
  }
}
