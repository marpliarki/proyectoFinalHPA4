import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto1hpa4/componentes/change_notifiers/usuario_model.dart';
import 'package:proyecto1hpa4/componentes/colores.dart';
import 'package:proyecto1hpa4/componentes/titulos.dart';

class ComponenteSuperior extends StatelessWidget {
  ComponenteSuperior(
      {super.key, required this.titulo, required this.icono, this.callback});
  String titulo;
  IconData icono;
  VoidCallback? callback;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(children: [
        Expanded(
            child: Consumer<UsuarioModel>(builder: (context, usuario, child) {
          return Titulo(
            titulo,
            alinear: TextAlign.left,
          );
        })),
        ElevatedButton(
          onPressed: () {
            if (callback != null) {
              callback!();
            }
          },
          child: Icon(
            icono,
            color: Colors.white,
            size: 30.0,
          ),
          style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              padding: EdgeInsets.all(24),
              elevation: 0,
              backgroundColor: COLOR_SECUNDARIO),
        ),
      ]),
    );
  }
}
