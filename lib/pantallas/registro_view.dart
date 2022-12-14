import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nfc_manager/nfc_manager.dart';

import 'package:proyecto1hpa4/componentes/clases/Asistencia.dart';
import 'package:proyecto1hpa4/componentes/clases/AsistenciaRegistro.dart';
import 'package:proyecto1hpa4/componentes/clases/Grupo.dart';
import 'package:proyecto1hpa4/componentes/colores.dart';
import 'package:proyecto1hpa4/componentes/datos/control_db.dart';
import 'package:proyecto1hpa4/componentes/datos/control_db_api.dart';
import 'package:proyecto1hpa4/componentes/fila_asistencia.dart';
import 'package:proyecto1hpa4/componentes/funciones.dart';
import 'package:proyecto1hpa4/componentes/titulos.dart';
import 'package:proyecto1hpa4/pantallas/compartido/componente_superior.dart';

class RegistroView extends StatefulWidget {
  RegistroView(
      {super.key,
      required this.grupo,
      required this.fechahora,
      this.liberarRestricciones = false});

  Grupo grupo;
  DateTime fechahora;
  bool liberarRestricciones;

  @override
  State<StatefulWidget> createState() => RegistroViewState();
}

class RegistroViewState extends State<RegistroView> {
  List<AsistenciaRegistro> asistencias = [];
  bool resultadosCargados = false;
  bool sePuedeRegistrar = false;
  int estadoRegistro = 0;
  bool hayInternet = true;

  late DateTime horaPantalla;

  @override
  void initState() {
    super.initState();
    setState(() {
      horaPantalla = DateTime.now();
    });
    cargarDeApi();
  }

  cargarDeApi() async {
    var a = await ControlDb.getAsistenciasPorGrupo(widget.grupo.id) ?? [];
    var e = await ControlDb.getEstudiantesPorGrupo(widget.grupo.id) ?? [];
    List<AsistenciaRegistro> ar = [];
    Iterable<Asistencia> af;

    af = a.where((element) {
      try {
        var fecha = DateTime.parse(element.fecha);
        return fecha.esMismaFecha(widget.fechahora);
      } catch (e) {
        try {
          var a = element.fecha.split("-");
          var fecha =
              DateTime(int.parse(a[0]), int.parse(a[1]), int.parse(a[2]));
          return fecha.esMismaFecha(widget.fechahora);
        } catch (e) {
          return false;
        }
      }
    });
    if (af.isNotEmpty) {
      for (var asistencia in af) {
        for (var estudiante in e) {
          if (asistencia.estudiante_id == estudiante.id) {
            ar.add(AsistenciaRegistro.porUnion(estudiante, asistencia));
          }
        }
      }
    } else {
      if ((DateTime.now().esMismaFecha(widget.fechahora) ||
              widget.liberarRestricciones) &&
          e.isNotEmpty &&
          await ControlDbApi.getEstadoConexion()) {
        for (var estudiante in e) {
          ar.add(AsistenciaRegistro(
              nombre: estudiante.nombre,
              apellido: estudiante.apellido,
              cedula: estudiante.cedula,
              fecha: widget.fechahora.obtenerFecha(),
              hora: "",
              estudiante_id: estudiante.id,
              grupo_asignatura_id: widget.grupo.id,
              estado_asistencia_id: 3));
        }
        setState(() {
          sePuedeRegistrar = true;
        });
      }
    }

    setState(() {
      asistencias = ar;
      resultadosCargados = true;
    });
  }

  enviarDatos() async {
    print("RegistroView.enviarDatos");
    var ahora = DateFormat('hh:mm a').format(DateTime.now());
    var lista = [...asistencias];
    for (var a in lista) {
      if (a.hora == "") {
        a.hora = ahora;
      }
    }

    var resultado = await ControlDb.setAsistencias(lista);

    showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: Text(resultado ? 'Listo' : 'Error'),
        content: Text(resultado
            ? 'Asistencias registradas'
            : 'Hubo problemas con algunas asistencias'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'OK');
              Navigator.pop(context, 'OK');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  iniciarNFC() {
    try {
      NfcManager.instance.isAvailable().then((value) {
        NfcManager.instance.startSession(
          onDiscovered: (tag) async {
            try {
              Ndef? ndef = Ndef.from(tag);

              if (ndef != null) {
                var cachedMessage = ndef.cachedMessage;
                if (cachedMessage != null) {
                  List<String> lista = [];

                  for (var i
                      in Iterable.generate(cachedMessage.records.length)) {
                    var record = cachedMessage.records[i];
                    var languageCodeLength = record.payload.first;
                    var languageCodeBytes =
                        record.payload.sublist(1, 1 + languageCodeLength);
                    var textBytes =
                        record.payload.sublist(1 + languageCodeLength);
                    lista.add(utf8.decode(textBytes));
                  }
                  if (lista.isNotEmpty) {
                    setState(() {
                      for (var i = 0; i < asistencias.length; i++) {
                        if (lista[0] == asistencias[i].hash) {
                          modificarAsistencia(i, nfc: true);
                          break;
                        }
                      }
                    });
                  }
                }
              } else {
                print('El tag no es compatible con NDEF');
              }
            } catch (e) {
              await NfcManager.instance.stopSession().catchError((_) {
                print(e);
              });
              setState(() {});
            }
          },
        ).catchError((e) {
          print(e);
        });
      }).catchError((e) {
        print(e);
      });
    } catch (e) {
      print(e);
    }
  }

  alSalir() {
    if (estadoRegistro > 0) {
      showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
          title: Text("Advertencia"),
          content: Text(
              '¿Está seguro de que desea salir? Se perderán todos los datos!'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, "Cancel"),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  modificarAsistencia(int index, {nfc = false}) {
    if (estadoRegistro > 0 &&
        estadoRegistro < 4 &&
        asistencias[index].estado_asistencia_id == 3) {
      if (nfc) {
        var snackBar = SnackBar(
            content: Text(
                'Estudiante registrado: ${asistencias[index].nombreCompleto}'));

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      setState(() {
        asistencias[index].estado_asistencia_id =
            estadoAsistencia(estadoRegistro);
        asistencias[index].hora = DateFormat('hh:mm a').format(DateTime.now());
        ;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    try {
      NfcManager.instance.stopSession().catchError((e) {
        print(e);
      });
    } catch (e) {
      print(e);
    }
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
                        asistencias[index].nombreCompleto,
                        asistencias[index].hora,
                        obtenerNombreEstadoAsistencia(
                                asistencias[index].estado_asistencia_id) ??
                            "-",
                        callback: () => modificarAsistencia(index));
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
                      titulo: "Registro Asistencia",
                      icono: Icons.arrow_back,
                      callback: () {
                        alSalir();
                      },
                    ),
                    Row(children: <Widget>[
                      Flexible(
                          child: Titulo(widget.grupo.asignatura,
                              tipo: TipoTitulo.h2, alinear: TextAlign.left)),
                    ]),
                    Row(children: <Widget>[
                      Expanded(
                        child: Text(
                          'Fecha: ${widget.fechahora.obtenerFecha()}',
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Visibility(
                        visible: sePuedeRegistrar,
                        child: Expanded(
                            child: Text(
                          'Hora: ${DateFormat('hh:mm a').format(horaPantalla)}',
                          style: const TextStyle(fontSize: 20),
                          textAlign: TextAlign.right,
                        )),
                      )
                    ]),
                    const SizedBox(height: 10),
                    Visibility(
                      child: IndicadorEstadoRegistro(estadoRegistro),
                      visible: sePuedeRegistrar,
                    ),
                    Visibility(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Flexible(
                                child: Text(
                              "No hay internet para registrar",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            )),
                          ]),
                      visible: !hayInternet,
                    ),
                    Divider(height: 20, color: COLOR_SECUNDARIO),
                    EncabezadosAsistencia("Nombre", "Hora", "Estado"),
                    const SizedBox(height: 10),
                    contenido,
                    const SizedBox(height: 10),
                    BotonRegistro(
                      sePuedeRegistrar: sePuedeRegistrar,
                      estado: estadoRegistro,
                      callback: () {
                        setState(() {
                          print(estadoRegistro);
                          if (estadoRegistro == 0) {
                            iniciarNFC();
                          }
                          if (estadoRegistro < 4) {
                            estadoRegistro++;

                            if (estadoRegistro >= 4) {
                              try {
                                NfcManager.instance
                                    .stopSession()
                                    .catchError((e) {
                                  print(e);
                                });
                                enviarDatos();
                              } catch (e) {
                                print(e);
                              }
                            }
                          }
                        });
                      },
                    )
                  ],
                ))));
  }
}

class IndicadorEstadoRegistro extends StatelessWidget {
  IndicadorEstadoRegistro(this.estado, {super.key});
  int estado;
  @override
  Widget build(BuildContext context) {
    String texto;

    if (estado == 0) {
      texto = "No se registró hoy";
    } else if (estado == 1) {
      texto = "Registrando Asistencias";
    } else if (estado == 2) {
      texto = "Registrando Tardanzas";
    } else {
      texto = "Registrando Ausentes con excusa";
    }

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Flexible(
          child: Text(
        texto,
        style: TextStyle(
            color: COLOR_SECUNDARIO, fontWeight: FontWeight.bold, fontSize: 20),
      )),
    ]);
  }
}

class BotonRegistro extends StatelessWidget {
  BotonRegistro(
      {super.key,
      required this.sePuedeRegistrar,
      required this.estado,
      this.callback});
  bool sePuedeRegistrar;
  int estado;
  final VoidCallback? callback;

  @override
  Widget build(BuildContext context) {
    String texto = "Empezar";

    if (estado == 0) {
      texto = "Empezar";
    } else if (estado == 1) {
      texto = "Continuar";
    } else if (estado == 2) {
      texto = "Continuar";
    } else if (estado == 3) {
      texto = "Terminar";
    } else {
      texto = "Enviando";
    }

    return Visibility(
      visible: sePuedeRegistrar,
      child: ElevatedButton(
        onPressed: estado < 4 ? () => callback!() : null,
        style: ElevatedButton.styleFrom(backgroundColor: COLOR_PRINCIPAL),
        child: Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 15),
            child: Text(
              texto,
              style: TextStyle(fontSize: 25),
            )),
      ),
    );
  }
}

int estadoAsistencia(int estado) {
  if (estado < 3) {
    return estado;
  } else if (estado == 3) {
    return 4;
  }
  return 3;
}
