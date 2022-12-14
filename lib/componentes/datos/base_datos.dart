import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

enum TablasNombres { Estudiante, Grupo, Asistencia, EstudianteGrupo }

class BaseDatos {
  static final String NOMBRE_BD = 'datosV2.db';

  static Future<String> getDireccionBd() async {
    return join(await getDatabasesPath(), NOMBRE_BD);
  }

  static Future<Database> crearBaseDatos() async {
    return await openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), NOMBRE_BD),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) async {
        // Run the CREATE TABLE statement on the database.
        await db.execute(
          """CREATE TABLE "Estudiante" (
              "id"	INTEGER,
              "nombre"	TEXT,
              "apellido"	TEXT,
              "cedula"	TEXT,
              "correo"	TEXT,
              "foto_url"	INTEGER,
              PRIMARY KEY("id")
            )""",
        );

        await db.execute(
          """CREATE TABLE "Grupo" (
              "id"	INTEGER,
              "asignatura"	TEXT,
              "codigo_asignatura"	TEXT,
              "docente_id"	INTEGER,
              "grupo"	TEXT,
              "periodo"	TEXT,
              PRIMARY KEY("id")
            )""",
        );
        await db.execute(
          """CREATE TABLE "Asistencia" (
              "id"	INTEGER,
              "fecha"	TEXT,
              "hora"	TEXT,
              "estudiante_id"	INTEGER,
              "grupo_asignatura_id"	INTEGER,
              "estado_asistencia_id"	INTEGER,
              PRIMARY KEY("id")
            )""",
        );
        await db.execute(
          """CREATE TABLE "EstudianteGrupo" (
              "id_estudiante"	INTEGER,
              "id_grupo"	INTEGER,
              PRIMARY KEY("id_estudiante","id_grupo")
            )""",
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }
}
