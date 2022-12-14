import 'dart:convert';

class Grupo {
  /// El id del grupo
  int id;

  /// El nombre de la asignatura que corresponde
  String asignatura;

  String codigo_asignatura;
  int docente_id;

  /// Ejemplo: 1IL141
  String grupo;

  /// Ejemplo: II SEM 2022
  String periodo;

  Grupo({
    required this.id,
    required this.asignatura,
    required this.codigo_asignatura,
    required this.docente_id,
    required this.grupo,
    required this.periodo,
  });

  Grupo copyWith({
    int? id,
    String? asignatura,
    String? codigo_asignatura,
    int? docente_id,
    String? grupo,
    String? periodo,
  }) {
    return Grupo(
      id: id ?? this.id,
      asignatura: asignatura ?? this.asignatura,
      codigo_asignatura: codigo_asignatura ?? this.codigo_asignatura,
      docente_id: docente_id ?? this.docente_id,
      grupo: grupo ?? this.grupo,
      periodo: periodo ?? this.periodo,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'asignatura': asignatura});
    result.addAll({'codigo_asignatura': codigo_asignatura});
    result.addAll({'docente_id': docente_id});
    result.addAll({'grupo': grupo});
    result.addAll({'periodo': periodo});

    return result;
  }

  factory Grupo.fromMap(Map<String, dynamic> map) {
    return Grupo(
      id: map['id']?.toInt() ?? 0,
      asignatura: map['asignatura'] ?? '',
      codigo_asignatura: map['codigo_asignatura'] ?? '',
      docente_id: map['docente_id']?.toInt() ?? 0,
      grupo: map['grupo'] ?? '',
      periodo: map['periodo'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Grupo.fromJson(String source) => Grupo.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Grupo(id: $id, asignatura: $asignatura, codigo_asignatura: $codigo_asignatura, docente_id: $docente_id, grupo: $grupo, periodo: $periodo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Grupo &&
        other.id == id &&
        other.asignatura == asignatura &&
        other.codigo_asignatura == codigo_asignatura &&
        other.docente_id == docente_id &&
        other.grupo == grupo &&
        other.periodo == periodo;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        asignatura.hashCode ^
        codigo_asignatura.hashCode ^
        docente_id.hashCode ^
        grupo.hashCode ^
        periodo.hashCode;
  }
}
