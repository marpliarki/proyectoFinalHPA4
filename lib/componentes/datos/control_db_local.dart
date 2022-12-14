import 'dart:async';

import 'package:path/path.dart';
import 'package:proyecto1hpa4/componentes/clases/Asistencia.dart';
import 'package:proyecto1hpa4/componentes/clases/Estudiante.dart';
import 'package:proyecto1hpa4/componentes/clases/EstudianteGrupo.dart';
import 'package:sqflite/sqflite.dart';

import 'package:proyecto1hpa4/componentes/clases/Grupo.dart';
import 'package:proyecto1hpa4/componentes/datos/base_datos.dart';

class ControlDbLocal {
  static Future<Database> db = BaseDatos.crearBaseDatos();

  static Future<List<Grupo>?> getGrupos_(int id) async {
    try {
      var baseDatos = await db;

      final List<Map<String, dynamic>> maps = await baseDatos.query('Grupo');

      List<Grupo> grupos = List<Grupo>.from(maps.map((modelo) {
        print(modelo.toString());
        return Grupo.fromMap(modelo);
      }));
      return grupos;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<bool> setGrupos_(List<Grupo> lista) async {
    try {
      var baseDatos = await db;

      Batch batch = baseDatos.batch();

      for (var val in lista) {
        //https://github.com/tekartik/sqflite/blob/master/sqflite/doc/conflict_algorithm.md
        batch.insert(
          "Grupo",
          val.toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }

      batch.commit();

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<List<Asistencia>?> getAsistenciasPorGrupoEstudiante(
      int eid, int gid) async {
    try {
      var baseDatos = await db;

      final List<Map<String, dynamic>> maps = await baseDatos.query(
          TablasNombres.Asistencia.name,
          where: 'estudiante_id = ? AND grupo_asignatura_id = ?',
          whereArgs: [eid, gid]);

      List<Asistencia> asistencias = List<Asistencia>.from(maps.map((modelo) {
        //print(modelo.toString());
        return Asistencia.fromMap(modelo);
      }));
      return asistencias;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<List<Asistencia>?> getAsistenciasPorGrupo(int gid) async {
    try {
      var baseDatos = await db;

      final List<Map<String, dynamic>> maps = await baseDatos.query(
          TablasNombres.Asistencia.name,
          where: 'grupo_asignatura_id = ?',
          whereArgs: [gid]);

      List<Asistencia> asistencias = List<Asistencia>.from(maps.map((modelo) {
        //print(modelo.toString());
        return Asistencia.fromMap(modelo);
      }));
      return asistencias;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<bool> setAsistencias(List<Asistencia> lista) async {
    try {
      var baseDatos = await db;

      Batch batch = baseDatos.batch();

      for (var val in lista) {
        //https://github.com/tekartik/sqflite/blob/master/sqflite/doc/conflict_algorithm.md
        batch.insert(
          TablasNombres.Asistencia.name,
          val.toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }

      batch.commit();

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<List<Estudiante>?> getEstudiantes() async {
    try {
      var baseDatos = await db;

      final List<Map<String, dynamic>> maps =
          await baseDatos.query(TablasNombres.Estudiante.name);

      List<Estudiante> estudiantes = List<Estudiante>.from(maps.map((modelo) {
        print(modelo.toString());
        return Estudiante.fromMap(modelo);
      }));
      return estudiantes;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<List<Estudiante>?> getEstudiantesPorGrupo(int gid) async {
    print("ControlDbLocal.getEstudiantesPorGrupo: grupo_id=$gid");
    try {
      var baseDatos = await db;

      final List<Map<String, dynamic>> maps = await baseDatos.rawQuery(
          "select e.id, e.nombre, e.apellido, e.cedula, e.correo, e.foto_url from Estudiante e "
          "join EstudianteGrupo eg on e.id = eg.id_estudiante where eg.id_grupo = ?",
          [gid]);

      List<Estudiante> estudiantes = List<Estudiante>.from(maps.map((modelo) {
        //print(modelo.toString());
        return Estudiante.fromMap(modelo);
      }));
      return estudiantes;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<bool> setEstudiantes(List<Estudiante> lista) async {
    try {
      var baseDatos = await db;

      Batch batch = baseDatos.batch();

      for (var val in lista) {
        //https://github.com/tekartik/sqflite/blob/master/sqflite/doc/conflict_algorithm.md
        batch.insert(
          TablasNombres.Estudiante.name,
          val.toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> setEstudiantesPorGrupo(
      List<Estudiante> lista, int gid) async {
    print("ControlDbLocal.setEstudiantesPorGrupo: grupo_id=$gid");
    try {
      var baseDatos = await db;

      Batch batch = baseDatos.batch();

      for (var val in lista) {
        //https://github.com/tekartik/sqflite/blob/master/sqflite/doc/conflict_algorithm.md
        batch.insert(
          TablasNombres.Estudiante.name,
          val.toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }
      await batch.commit(continueOnError: true);

      Batch batch2 = baseDatos.batch();

      for (var val in lista) {
        batch.insert(
          TablasNombres.EstudianteGrupo.name,
          EstudianteGrupo(id_estudiante: val.id, id_grupo: gid).toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }
      await batch2.commit(continueOnError: true);

      // final List<Map<String, dynamic>> maps3 =
      //     await baseDatos.query(TablasNombres.EstudianteGrupo.name);
      // List<EstudianteGrupo> e = List<EstudianteGrupo>.from(maps3.map((modelo) {
      //   print(modelo.toString());
      //   return EstudianteGrupo.fromMap(modelo);
      // }));

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> borrarTodo() async {
    try {
      var baseDatos = await db;
      await baseDatos.delete(TablasNombres.Asistencia.name);
      await baseDatos.delete(TablasNombres.Estudiante.name);
      await baseDatos.delete(TablasNombres.Grupo.name);
      await baseDatos.delete(TablasNombres.EstudianteGrupo.name);

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
