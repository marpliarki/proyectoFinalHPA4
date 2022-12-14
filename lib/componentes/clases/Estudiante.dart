import 'dart:convert';

class Estudiante {
  int id;
  String nombre;
  String apellido;
  String cedula;
  String correo;
  String? foto_url;
  Estudiante({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.cedula,
    required this.correo,
    this.foto_url,
  });

  Estudiante copyWith({
    int? id,
    String? nombre,
    String? apellido,
    String? cedula,
    String? correo,
    String? foto_url,
  }) {
    return Estudiante(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      apellido: apellido ?? this.apellido,
      cedula: cedula ?? this.cedula,
      correo: correo ?? this.correo,
      foto_url: foto_url ?? this.foto_url,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'nombre': nombre});
    result.addAll({'apellido': apellido});
    result.addAll({'cedula': cedula});
    result.addAll({'correo': correo});
    if (foto_url != null) {
      result.addAll({'foto_url': foto_url});
    }

    return result;
  }

  factory Estudiante.fromMap(Map<String, dynamic> map) {
    return Estudiante(
      id: map['id']?.toInt() ?? 0,
      nombre: map['nombre']?.trim() ?? '',
      apellido: map['apellido']?.trim() ?? '',
      cedula: map['cedula'] ?? '',
      correo: map['correo'] ?? '',
      foto_url: map['foto_url'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Estudiante.fromJson(String source) =>
      Estudiante.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Estudiante(id: $id, nombre: $nombre, apellido: $apellido, cedula: $cedula, correo: $correo, foto_url: $foto_url)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Estudiante &&
        other.id == id &&
        other.nombre == nombre &&
        other.apellido == apellido &&
        other.cedula == cedula &&
        other.correo == correo &&
        other.foto_url == foto_url;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nombre.hashCode ^
        apellido.hashCode ^
        cedula.hashCode ^
        correo.hashCode ^
        foto_url.hashCode;
  }
}
