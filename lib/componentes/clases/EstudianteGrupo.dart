import 'dart:convert';

class EstudianteGrupo {
  int id_estudiante;
  int id_grupo;
  EstudianteGrupo({
    required this.id_estudiante,
    required this.id_grupo,
  });

  EstudianteGrupo copyWith({
    int? id_estudiante,
    int? id_grupo,
  }) {
    return EstudianteGrupo(
      id_estudiante: id_estudiante ?? this.id_estudiante,
      id_grupo: id_grupo ?? this.id_grupo,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id_estudiante': id_estudiante});
    result.addAll({'id_grupo': id_grupo});

    return result;
  }

  factory EstudianteGrupo.fromMap(Map<String, dynamic> map) {
    return EstudianteGrupo(
      id_estudiante: map['id_estudiante']?.toInt() ?? 0,
      id_grupo: map['id_grupo']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory EstudianteGrupo.fromJson(String source) =>
      EstudianteGrupo.fromMap(json.decode(source));

  @override
  String toString() =>
      'EstudianteGrupo(id_estudiante: $id_estudiante, id_grupo: $id_grupo)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EstudianteGrupo &&
        other.id_estudiante == id_estudiante &&
        other.id_grupo == id_grupo;
  }

  @override
  int get hashCode => id_estudiante.hashCode ^ id_grupo.hashCode;
}
