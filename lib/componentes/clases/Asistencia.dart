import 'dart:convert';

class Asistencia {
  int id;
  String fecha;
  String hora;
  int estudiante_id;
  int grupo_asignatura_id;
  int estado_asistencia_id;

  Asistencia({
    required this.id,
    required this.fecha,
    required this.hora,
    required this.estudiante_id,
    required this.grupo_asignatura_id,
    required this.estado_asistencia_id,
  });

  Asistencia copyWith({
    int? id,
    String? fecha,
    String? hora,
    int? estudiante_id,
    int? grupo_asignatura_id,
    int? estado_asistencia_id,
  }) {
    return Asistencia(
      id: id ?? this.id,
      fecha: fecha ?? this.fecha,
      hora: hora ?? this.hora,
      estudiante_id: estudiante_id ?? this.estudiante_id,
      grupo_asignatura_id: grupo_asignatura_id ?? this.grupo_asignatura_id,
      estado_asistencia_id: estado_asistencia_id ?? this.estado_asistencia_id,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'fecha': fecha});
    result.addAll({'hora': hora});
    result.addAll({'estudiante_id': estudiante_id});
    result.addAll({'grupo_asignatura_id': grupo_asignatura_id});
    result.addAll({'estado_asistencia_id': estado_asistencia_id});

    return result;
  }

  factory Asistencia.fromMap(Map<String, dynamic> map) {
    return Asistencia(
      id: map['id']?.toInt() ?? 0,
      fecha: map['fecha'] ?? '',
      hora: map['hora'] ?? '',
      estudiante_id: map['estudiante_id']?.toInt() ?? 0,
      grupo_asignatura_id: map['grupo_asignatura_id']?.toInt() ?? 0,
      estado_asistencia_id: map['estado_asistencia_id']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Asistencia.fromJson(String source) =>
      Asistencia.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Asistencia(id: $id, fecha: $fecha, hora: $hora, estudiante_id: $estudiante_id, grupo_asignatura_id: $grupo_asignatura_id, estado_asistencia_id: $estado_asistencia_id)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Asistencia &&
        other.id == id &&
        other.fecha == fecha &&
        other.hora == hora &&
        other.estudiante_id == estudiante_id &&
        other.grupo_asignatura_id == grupo_asignatura_id &&
        other.estado_asistencia_id == estado_asistencia_id;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        fecha.hashCode ^
        hora.hashCode ^
        estudiante_id.hashCode ^
        grupo_asignatura_id.hashCode ^
        estado_asistencia_id.hashCode;
  }
}
