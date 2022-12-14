import 'dart:convert';

import 'package:proyecto1hpa4/componentes/clases/Asistencia.dart';
import 'package:proyecto1hpa4/componentes/clases/Estudiante.dart';
import 'package:proyecto1hpa4/componentes/comp_nfc.dart';
import 'package:proyecto1hpa4/componentes/funciones.dart';

class AsistenciaRegistro {
  int? id;
  String fecha;
  String hora;
  int estudiante_id;
  int grupo_asignatura_id;
  int estado_asistencia_id;
  String nombre;
  String apellido;
  String cedula;
  AsistenciaRegistro({
    this.id,
    required this.fecha,
    required this.hora,
    required this.estudiante_id,
    required this.grupo_asignatura_id,
    required this.estado_asistencia_id,
    required this.nombre,
    required this.apellido,
    required this.cedula,
  });

  String get nombreCompleto =>
      "${nombre.f_primeraMayuscula()} ${apellido.f_primeraMayuscula()}";

  String get hash => encriptarDatos(cedula, estudiante_id);

  factory AsistenciaRegistro.porUnion(
      Estudiante estudiante, Asistencia asistencia) {
    return AsistenciaRegistro(
        id: asistencia.id,
        fecha: asistencia.fecha,
        hora: asistencia.hora,
        estudiante_id: asistencia.estudiante_id,
        grupo_asignatura_id: asistencia.grupo_asignatura_id,
        estado_asistencia_id: asistencia.estado_asistencia_id,
        nombre: estudiante.nombre,
        apellido: estudiante.apellido,
        cedula: estudiante.cedula);
  }

  Map<String, dynamic> toAPIMap() {
    final result = <String, dynamic>{};
    result.addAll({'fecha': fecha});
    result.addAll({'hora': hora});
    result.addAll({'estudiante_id': estudiante_id});
    result.addAll({'grupo_asignatura_id': grupo_asignatura_id});
    result.addAll({'estado_asistencia_id': estado_asistencia_id});

    return result;
  }

  String toAPIJson() => json.encode(toAPIMap());

  AsistenciaRegistro copyWith({
    int? id,
    String? fecha,
    String? hora,
    int? estudiante_id,
    int? grupo_asignatura_id,
    int? estado_asistencia_id,
    String? nombre,
    String? apellido,
    String? cedula,
  }) {
    return AsistenciaRegistro(
      id: id ?? this.id,
      fecha: fecha ?? this.fecha,
      hora: hora ?? this.hora,
      estudiante_id: estudiante_id ?? this.estudiante_id,
      grupo_asignatura_id: grupo_asignatura_id ?? this.grupo_asignatura_id,
      estado_asistencia_id: estado_asistencia_id ?? this.estado_asistencia_id,
      nombre: nombre ?? this.nombre,
      apellido: apellido ?? this.apellido,
      cedula: cedula ?? this.cedula,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (id != null) {
      result.addAll({'id': id});
    }
    result.addAll({'fecha': fecha});
    result.addAll({'hora': hora});
    result.addAll({'estudiante_id': estudiante_id});
    result.addAll({'grupo_asignatura_id': grupo_asignatura_id});
    result.addAll({'estado_asistencia_id': estado_asistencia_id});
    result.addAll({'nombre': nombre});
    result.addAll({'apellido': apellido});
    result.addAll({'cedula': cedula});

    return result;
  }

  factory AsistenciaRegistro.fromMap(Map<String, dynamic> map) {
    return AsistenciaRegistro(
      id: map['id']?.toInt(),
      fecha: map['fecha'] ?? '',
      hora: map['hora'] ?? '',
      estudiante_id: map['estudiante_id']?.toInt() ?? 0,
      grupo_asignatura_id: map['grupo_asignatura_id']?.toInt() ?? 0,
      estado_asistencia_id: map['estado_asistencia_id']?.toInt() ?? 0,
      nombre: map['nombre'] ?? '',
      apellido: map['apellido'] ?? '',
      cedula: map['cedula'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AsistenciaRegistro.fromJson(String source) =>
      AsistenciaRegistro.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AsistenciaRegistro(id: $id, fecha: $fecha, hora: $hora, estudiante_id: $estudiante_id, grupo_asignatura_id: $grupo_asignatura_id, estado_asistencia_id: $estado_asistencia_id, nombre: $nombre, apellido: $apellido, cedula: $cedula)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AsistenciaRegistro &&
        other.id == id &&
        other.fecha == fecha &&
        other.hora == hora &&
        other.estudiante_id == estudiante_id &&
        other.grupo_asignatura_id == grupo_asignatura_id &&
        other.estado_asistencia_id == estado_asistencia_id &&
        other.nombre == nombre &&
        other.apellido == apellido &&
        other.cedula == cedula;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        fecha.hashCode ^
        hora.hashCode ^
        estudiante_id.hashCode ^
        grupo_asignatura_id.hashCode ^
        estado_asistencia_id.hashCode ^
        nombre.hashCode ^
        apellido.hashCode ^
        cedula.hashCode;
  }
}
