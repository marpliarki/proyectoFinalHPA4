import 'package:flutter/material.dart';
import 'package:proyecto1hpa4/componentes/clases/Estudiante.dart';
import 'package:proyecto1hpa4/componentes/colores.dart';
import 'package:proyecto1hpa4/componentes/titulos.dart';

typedef void Callback(Estudiante estudiante);

class TarjetaEstudiante extends StatelessWidget {
  const TarjetaEstudiante(this.item, {super.key, this.callback});
  final Estudiante item;
  final Callback? callback;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
          onTap: () {
            if (callback != null) {
              callback!(item);
            }
          },
          child: ListTile(
            leading: const CircleAvatar(
                backgroundColor: COLOR_SECUNDARIO,
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 20.0,
                )),
            title: Titulo(
              "${item.nombre.trim()} ${item.apellido}",
              tipo: TipoTitulo.h3,
              alinear: TextAlign.start,
            ),
            subtitle: Text(item.cedula, style: TextStyle(color: Colors.grey)),
          )),
    );
  }
}
