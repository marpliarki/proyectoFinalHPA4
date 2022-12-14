import 'dart:core';

/// 1 Admin, ninguno
/// 2 Profesor, profesor_id
/// 3 Estudiante, estudiante_id
enum TipoUsuario { admin, profesor, estudiante, usuario }

class Usuario {
  final int id;
  final String nombre;
  final String apellido;
  final String cedula;
  final String correo;

  String? foto_url;

  final String created_at;
  final String updated_at;
  final TipoUsuario tipo;
  final int role;

  late int id_entidad;

  Usuario(
      {required this.id,
      required this.nombre,
      required this.apellido,
      required this.cedula,
      required this.correo,
      required this.created_at,
      required this.updated_at,
      required this.tipo,
      required this.role,
      required this.id_entidad});

  factory Usuario.fromMap(Map<String, dynamic> json) {
    return Usuario(
        id: json['id'],
        nombre: json['nombres'].trim(),
        apellido: json['apellidos'].trim(),
        cedula: json['cedula'],
        correo: json['email'],
        role: json['role'],
        created_at: json['created_at'],
        updated_at: json['updated_at'],
        tipo: TipoUsuario.values[json['role'] - 1],
        id_entidad: json['estudiante_id'] ?? json['docente_id'] ?? 0);
  }

  factory Usuario.fromMapSharedPreferences(Map<String, dynamic> json) {
    return Usuario(
        id: json['id'],
        nombre: json['nombre'],
        apellido: json['apellido'],
        cedula: json['cedula'],
        correo: json['correo'],
        role: json['role'],
        created_at: json['created_at'],
        updated_at: json['updated_at'],
        tipo: TipoUsuario.values[json['role'] - 1],
        id_entidad: json['id_entidad']);
  }

  Map<String, dynamic> toMapSharedPreferences() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'nombre': nombre});
    result.addAll({'apellido': apellido});
    result.addAll({'cedula': cedula});
    result.addAll({'correo': correo});
    result.addAll({'created_at': created_at});
    result.addAll({'updated_at': updated_at});
    result.addAll({'role': role});
    result.addAll({'id_entidad': id_entidad});

    return result;
  }
}
