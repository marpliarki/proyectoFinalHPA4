import 'package:flutter/material.dart';
import 'package:proyecto1hpa4/componentes/clases/Grupo.dart';
import 'package:proyecto1hpa4/componentes/colores.dart';
import 'package:proyecto1hpa4/componentes/titulos.dart';

typedef void Callback(Grupo grupo);

class TarjetaGrupo extends StatelessWidget {
  TarjetaGrupo(this.item, {super.key, required this.callback});
  final Grupo item;
  Callback callback;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
          onTap: (() {
            if (callback != null) {
              callback(item);
            }
          }),
          child: ListTile(
            leading: CircleAvatar(
                backgroundColor: COLOR_SECUNDARIO,
                child: Icon(
                  Icons.handyman,
                  color: Colors.white,
                  size: 20.0,
                )),
            title: Titulo(
              item.asignatura,
              tipo: TipoTitulo.h3,
              alinear: TextAlign.start,
            ),
            subtitle: Text(item.grupo, style: TextStyle(color: Colors.grey)),
          )),
    );
  }
}
