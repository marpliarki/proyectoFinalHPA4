import 'package:flutter/material.dart';
import 'package:proyecto1hpa4/componentes/titulos.dart';

class Tarjeta extends StatelessWidget {
  const Tarjeta(this.nombre, this.cedula, {super.key});
  final String nombre;
  final String cedula;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 20.0,
            )),
        title: Titulo(
          nombre,
          tipo: TipoTitulo.h3,
          alinear: TextAlign.start,
        ),
        subtitle: Text(cedula, style: TextStyle(color: Colors.grey)),
      ),
    );
  }
}
