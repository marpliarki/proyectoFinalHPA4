import 'package:flutter/material.dart';

import 'package:proyecto1hpa4/componentes/clases/Estudiante.dart';
import 'package:proyecto1hpa4/componentes/clases/Grupo.dart';
import 'package:proyecto1hpa4/componentes/colores.dart';
import 'package:proyecto1hpa4/componentes/datos/control_db.dart';
import 'package:proyecto1hpa4/componentes/funciones.dart';
import 'package:proyecto1hpa4/componentes/tarjeta_estudiante.dart';
import 'package:proyecto1hpa4/componentes/titulos.dart';
import 'package:proyecto1hpa4/pantallas/asistencia_view.dart';
import 'package:proyecto1hpa4/pantallas/compartido/componente_superior.dart';

class ListadoView extends StatefulWidget {
  ListadoView({super.key, required this.grupo});

  Grupo grupo;

  @override
  State<StatefulWidget> createState() => ListadoViewState();
}

class ListadoViewState extends State<ListadoView> {
  List<Estudiante> estudiantes = [];
  bool resultadosCargados = false;

  @override
  void initState() {
    super.initState();
    ControlDb.getEstudiantesPorGrupo(widget.grupo.id).then((value) {
      if (value != null) {
        setState(() {
          estudiantes = value;
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
    return Scaffold(
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ComponenteSuperior(
                      titulo: "Estudiantes",
                      icono: Icons.arrow_back,
                      callback: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(height: 5),
                    Row(children: <Widget>[
                      Flexible(
                          child: Titulo(widget.grupo.asignatura,
                              tipo: TipoTitulo.h2, alinear: TextAlign.left)),
                    ]),
                    Divider(height: 20, color: COLOR_SECUNDARIO),
                    resultadosCargados
                        ? Expanded(
                            child: estudiantes.isNotEmpty
                                ? ListView.builder(
                                    itemCount: estudiantes.length,
                                    itemBuilder: (context, index) {
                                      return TarjetaEstudiante(
                                        estudiantes[index],
                                        callback: (estudiante) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AsistenciaView(
                                                      grupo: widget.grupo,
                                                      estudiante_id:
                                                          estudiante.id,
                                                      nombre:
                                                          "${estudiante.nombre.f_primeraMayuscula()} ${estudiante.apellido.f_primeraMayuscula()}",
                                                    )),
                                          );
                                        },
                                      );
                                    },
                                  )
                                : Titulo(
                                    "Sin estudiantes",
                                    tipo: TipoTitulo.h2,
                                  ))
                        : CircularProgressIndicator(color: COLOR_PRINCIPAL)
                  ],
                ))));
  }
}
