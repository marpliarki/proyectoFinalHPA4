import 'package:flutter/material.dart';
import 'package:proyecto1hpa4/componentes/titulos.dart';

import 'colores.dart';

class TxtCampo extends StatelessWidget {
  TxtCampo(
      {super.key,
      required this.nombre,
      this.pista,
      required this.controlador,
      this.contrasena = false});
  final String nombre;
  final String? pista;
  final TextEditingController controlador;
  bool contrasena;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Titulo(
          nombre,
          tipo: TipoTitulo.h2,
          alinear: TextAlign.left,
        ),
        const SizedBox(height: 2),
        TextField(
          decoration: InputDecoration(
            enabledBorder: new OutlineInputBorder(
              borderSide: BorderSide(color: COLOR_PRINCIPAL),
            ),
            focusedBorder: new OutlineInputBorder(
              borderSide: BorderSide(color: COLOR_PRINCIPAL),
            ),
            hintText: "Ingresa tu ${nombre.toLowerCase()}",
          ),
          cursorColor: COLOR_PRINCIPAL,
          controller: controlador,
          obscureText: contrasena,
          enableSuggestions: false,
          autocorrect: false,
        )
      ],
    );
  }
}
