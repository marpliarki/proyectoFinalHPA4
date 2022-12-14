import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:proyecto1hpa4/componentes/change_notifiers/debug_model.dart';
import 'package:proyecto1hpa4/componentes/clases/Grupo.dart';
import 'package:proyecto1hpa4/componentes/colores.dart';
import 'package:proyecto1hpa4/componentes/funciones.dart';
import 'package:proyecto1hpa4/componentes/titulos.dart';
import 'package:proyecto1hpa4/pantallas/compartido/componente_superior.dart';
import 'package:proyecto1hpa4/pantallas/listado_view.dart';
import 'package:proyecto1hpa4/pantallas/registro_view.dart';

class GrupoView extends StatefulWidget {
  GrupoView({super.key, required this.grupo});

  Grupo grupo;

  @override
  State<StatefulWidget> createState() => GrupoViewState();
}

class GrupoViewState extends State<GrupoView> {
  TextEditingController _date = TextEditingController();

  DateTime fecha = DateTime.now();
  DateTime fechaHoy = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var textoBoton = fecha.esMismaFecha(fechaHoy)
        ? "Registrar Asistencias"
        : "Ver Asistencias";

    return Scaffold(
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ComponenteSuperior(
                      titulo: "Grupo",
                      icono: Icons.arrow_back,
                      callback: () {
                        Navigator.pop(context);
                      },
                    ),
                    Row(
                      children: [
                        Flexible(
                            child: Titulo(
                          widget.grupo.asignatura,
                          tipo: TipoTitulo.h2,
                          alinear: TextAlign.left,
                        )),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(children: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListadoView(
                                      grupo: widget.grupo,
                                    )),
                          );
                        },
                        child: Text(
                          'Ver lista de estudiantes',
                        ),
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size(50, 30),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            alignment: Alignment.centerLeft,
                            foregroundColor: COLOR_PRINCIPAL),
                      ),
                    ]),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _date,
                      readOnly: true,
                      decoration: const InputDecoration(
                          icon: Icon(
                            Icons.calendar_today_rounded,
                            color: COLOR_SECUNDARIO,
                          ),
                          labelText: 'Buscar por fecha',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: COLOR_SECUNDARIO),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: COLOR_SECUNDARIO),
                          ),
                          iconColor: COLOR_SECUNDARIO,
                          labelStyle: TextStyle(color: COLOR_SECUNDARIO)),
                      onTap: () async {
                        DateTime ahora = DateTime.now();

                        DateTime? pickeddate = await showDatePicker(
                            context: context,
                            initialDate: ahora,
                            firstDate: DateTime(2000),
                            lastDate:
                                DateTime(ahora.year, ahora.month, ahora.day));

                        if (pickeddate != null) {
                          setState(() {
                            _date.text =
                                DateFormat('dd-MM-yyyy').format(pickeddate);
                          });

                          fecha = pickeddate;
                        }
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegistroView(
                                    grupo: widget.grupo,
                                    fechahora: fecha,
                                    liberarRestricciones:
                                        Provider.of<DebugModel>(context,
                                                listen: false)
                                            .permitirRegistroFueraDeDia,
                                  )),
                        );
                      },
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 15),
                          child: Text(
                            textoBoton,
                            style: TextStyle(fontSize: 25),
                          )),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: COLOR_PRINCIPAL),
                    ),
                    Center(
                    child: Lottie.network('https://assets9.lottiefiles.com/packages/lf20_tpa51dr0.json')),
                  ],
                ))));
  }
}
