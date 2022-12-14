import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:provider/provider.dart';
import 'package:proyecto1hpa4/componentes/datos/control_db_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:proyecto1hpa4/componentes/change_notifiers/usuario_model.dart';
import 'package:proyecto1hpa4/componentes/clases/Estudiante.dart';
import 'package:proyecto1hpa4/componentes/colores.dart';
import 'package:proyecto1hpa4/componentes/comp_nfc.dart';
import 'package:proyecto1hpa4/componentes/datos/control_db.dart';
import 'package:proyecto1hpa4/componentes/funciones.dart';
import 'package:proyecto1hpa4/componentes/tarjeta_estudiante.dart';
import 'package:proyecto1hpa4/componentes/titulos.dart';
import 'package:proyecto1hpa4/pantallas/compartido/componente_superior.dart';
import 'package:proyecto1hpa4/pantallas/login_view.dart';
import 'package:proyecto1hpa4/pantallas/main_view/compartido/datos_usuario.dart';

class MainViewAdmin extends StatefulWidget {
  const MainViewAdmin({super.key});

  @override
  State<MainViewAdmin> createState() => _MainViewAdminState();
}

class _MainViewAdminState extends State<MainViewAdmin> {
  List<Estudiante> estudiantes = [];
  bool resultadosCargados = false;

  @override
  void initState() {
    super.initState();
    Provider.of<UsuarioModel>(context, listen: false).cargarUsuario();

    ControlDb.getEstudiantes().then((value) {
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

  void abrirDialogEscritura(Estudiante u) {
    NfcManager.instance.isAvailable().then((value) {
      showDialog<String>(
        //Para que no se pueda quitar fuera del dialog
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(
              'Grabando tag para ${u.nombre.trim().f_primeraMayuscula()} ${u.apellido.f_primeraMayuscula()}'),
          content: Container(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            //https://stackoverflow.com/questions/54669630/flutter-auto-size-alertdialog-to-fit-list-content
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.nfc_rounded,
                size: 100,
              ),
              Titulo(
                "Acerca un tag para grabar la información",
                tipo: TipoTitulo.h3,
              )
            ],
          )),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                NfcManager.instance
                    .stopSession()
                    .then((value) => Navigator.pop(context, 'Cancel'))
                    .catchError((e) {
                  print(e);
                  Navigator.pop(context, 'Cancel');
                });
              },
              child: const Text('Cancelar'),
            )
          ],
        ),
      );

      NfcManager.instance.startSession(
        onDiscovered: (tag) async {
          try {
            Ndef? ndef = Ndef.from(tag);

            if (ndef != null) {
              if (ndef.isWritable) {
                try {
                  final listaRecords = [
                    crearRegistroTexto(encriptarDatos(u.cedula, u.id))
                  ];
                  final message = NdefMessage(listaRecords);
                  await ndef.write(message);
                  NfcManager.instance
                      .stopSession()
                      .then((value) => Navigator.pop(context, 'Cancel'))
                      .catchError((_) {});
                  print("Exito escribiendo");
                } catch (e) {
                  print(e.toString());
                }
              }
            } else {
              print('El tag no es compatible con NDEF');
            }
          } catch (e) {
            await NfcManager.instance.stopSession().catchError((_) {});
          }
        },
      ).catchError((e) => print(e));
    }).catchError((e) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('No se pudo acceder al NFC'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: <Widget>[
                Consumer<UsuarioModel>(builder: (context, usuario, child) {
                  return ComponenteSuperior(
                    titulo:
                        usuario.usuarioActual?.tipo.name.f_primeraMayuscula() ??
                            "Usuario",
                    icono: Icons.logout,
                    callback: () {
                      SharedPreferences.getInstance().then((prefs) {
                        prefs.remove('usuario');
                      }).then((value) => ControlDbLocal.borrarTodo());

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginView()),
                      );
                    },
                  );
                }),
                DatosUsuario(),
                const Divider(
                  height: 20,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                  color: COLOR_SECUNDARIO,
                ),
                Titulo(
                  "Listado de estudiantes",
                  tipo: TipoTitulo.h1,
                ),
                const SizedBox(height: 10),
                resultadosCargados
                    ? Expanded(
                        child: estudiantes.isNotEmpty
                            ? ListView.builder(
                                itemCount: estudiantes.length,
                                itemBuilder: (context, index) {
                                  return TarjetaEstudiante(
                                    estudiantes[index],
                                    callback: (e) => abrirDialogEscritura(e),
                                  );
                                },
                              )
                            : Titulo(
                                "Sin clases",
                                tipo: TipoTitulo.h2,
                              ))
                    : CircularProgressIndicator(color: COLOR_PRINCIPAL)
              ]),
            ),
          ),
        ));
  }
}
