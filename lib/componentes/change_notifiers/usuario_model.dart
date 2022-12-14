import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:proyecto1hpa4/componentes/clases/Usuario.dart';
import 'package:proyecto1hpa4/componentes/funciones.dart';

class UsuarioModel extends ChangeNotifier {
  String get nombreCompleto =>
      "${usuarioActual?.nombre.f_primeraMayuscula()} ${usuarioActual?.apellido.f_primeraMayuscula()}";

  Usuario? usuarioActual;

  void setearUsuario(Usuario u) {
    usuarioActual = u;
    notifyListeners();
  }

  Future<bool> guardarUsuario() async {
    if (usuarioActual != null) {
      final prefs = await SharedPreferences.getInstance();
      bool result = await prefs.setString(
          "usuario", jsonEncode(usuarioActual!.toMapSharedPreferences()));
      return result;
    }
    return false;
  }

  Future<bool> cargarUsuario() async {
    if (usuarioActual == null) {
      final prefs = await SharedPreferences.getInstance();
      String? u = prefs.getString('usuario');

      if (u != null) {
        Map<String, dynamic> mapaUsuario =
            jsonDecode(u) as Map<String, dynamic>;
        Usuario usuario = Usuario.fromMapSharedPreferences(mapaUsuario);

        setearUsuario(usuario);

        return true;
      }
    }
    return false;
  }
}
