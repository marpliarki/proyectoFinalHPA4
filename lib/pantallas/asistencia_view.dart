import 'package:flutter/material.dart';

import 'package:proyecto1hpa4/componentes/clases/Asistencia.dart';
import 'package:proyecto1hpa4/componentes/clases/Grupo.dart';
import 'package:proyecto1hpa4/componentes/colores.dart';
import 'package:proyecto1hpa4/componentes/datos/control_db.dart';
import 'package:proyecto1hpa4/componentes/fila_asistencia.dart';
import 'package:proyecto1hpa4/componentes/funciones.dart';
import 'package:proyecto1hpa4/componentes/titulos.dart';
import 'package:proyecto1hpa4/pantallas/compartido/componente_superior.dart';

class AsistenciaView extends StatefulWidget {
  AsistenciaView(
      {super.key,
      required this.estudiante_id,
      required this.grupo,
      required this.nombre});
  int estudiante_id;
  Grupo grupo;
  String nombre;

  @override
  State<AsistenciaView> createState() => _AsistenciaViewState();
}

class _AsistenciaViewState extends State<AsistenciaView> {
  List<Asistencia> asistencias = [];
  bool resultadosCargados = false;

  @override
  void initState() {
    super.initState();
    ControlDb.getAsistenciasPorGrupoEstudiante(
            widget.estudiante_id, widget.grupo.id)
        .then((value) {
      if (value != null) {
        setState(() {
          asistencias = value;
        });
      } else {
        print("Error al cargar estudiantes");
      }
      setState(() {
        resultadosCargados = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget contenido;

    if (resultadosCargados) {
      contenido = Expanded(
          child: asistencias.isNotEmpty
              ? ListView.separated(
                  itemCount: asistencias.length,
                  separatorBuilder: (context, index) {
                    return const Divider(color: Colors.grey, height: 0);
                  },
                  itemBuilder: (context, index) {
                    return FilaAsistencia(
                        asistencias[index].fecha,
                        asistencias[index].hora,
                        obtenerNombreEstadoAsistencia(
                                asistencias[index].estado_asistencia_id) ??
                            "-");
                  })
              : Titulo(
                  "Sin asistencias",
                  tipo: TipoTitulo.h2,
                ));
    } else {
      contenido = CircularProgressIndicator(color: COLOR_PRINCIPAL);
    }

    return Scaffold(
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ComponenteSuperior(
                      titulo: "Asistencia",
                      icono: Icons.arrow_back,
                      callback: () {
                        Navigator.pop(context);
                      },
                    ),
                    Row(children: <Widget>[
                      Titulo(
                        widget.nombre,
                        tipo: TipoTitulo.h2,
                        alinear: TextAlign.left,
                      )
                    ]),
                    Row(children: <Widget>[
                      Titulo(
                        widget.grupo.asignatura,
                        tipo: TipoTitulo.h3,
                        alinear: TextAlign.left,
                      )
                    ]),
                    const Divider(
                      height: 20,
                      thickness: 1,
                      indent: 0,
                      endIndent: 0,
                      color: COLOR_SECUNDARIO,
                    ),
                    EncabezadosAsistencia("Fecha", "Hora", "Estado"),
                    const SizedBox(
                      height: 12,
                    ),
                    contenido,
                  ],
                ))));
  }
}
