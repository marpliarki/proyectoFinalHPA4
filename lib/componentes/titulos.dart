import 'package:flutter/material.dart';

enum TipoTitulo { h1, h2, h3, h4, h5, h6 }

class Titulo extends StatelessWidget {
  const Titulo(this.texto,
      {super.key,
      this.tipo = TipoTitulo.h1,
      this.color = Colors.black,
      this.alinear = TextAlign.center});
  final String texto;
  final TipoTitulo tipo;
  final Color color;
  final TextAlign alinear;
  @override
  Widget build(BuildContext context) {
    double tamano = 35;

    switch (tipo) {
      case TipoTitulo.h1:
        break;
      case TipoTitulo.h2:
        tamano = 25;
        break;
      case TipoTitulo.h3:
        tamano = 15;
        break;
      default:
    }

    return Text(texto,
        textAlign: alinear,
        style: TextStyle(
          fontSize: tamano,
          fontWeight: FontWeight.bold,
          color: color,
        ));
  }
}
