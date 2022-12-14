import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto1hpa4/componentes/change_notifiers/debug_model.dart';
import 'package:proyecto1hpa4/componentes/clases/Usuario.dart';
import 'package:proyecto1hpa4/componentes/datos/control_db.dart';
import 'package:proyecto1hpa4/componentes/colores.dart';
import 'package:proyecto1hpa4/componentes/change_notifiers/usuario_model.dart';
import 'package:proyecto1hpa4/componentes/datos/control_db_api.dart';
import 'package:proyecto1hpa4/componentes/pruebas/pruebas.dart';
import 'package:proyecto1hpa4/componentes/txtcampo.dart';
import 'package:proyecto1hpa4/pantallas/asistencia_view.dart';
import 'package:proyecto1hpa4/pantallas/grupo_view.dart';
import 'package:proyecto1hpa4/pantallas/main_view/main_view.dart';
import 'package:proyecto1hpa4/pantallas/main_view/main_view_admin.dart';
import 'package:proyecto1hpa4/pantallas/listado_view.dart';
import 'package:proyecto1hpa4/pantallas/registro_view.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final ControladorCorreo = TextEditingController();
  final ControladorContrasena = TextEditingController();
  final Shader linearGradient = LinearGradient(
    colors: <Color>[COLOR_SECUNDARIO, COLOR_PRINCIPAL],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 400.0, 0.0));

  void iniciarSesion({String? correo, String? contrasena}) {
    ControlDbApi.getEstadoConexion().then((value) {
      if (value) {
        ControlDb.loguearUsuario(correo ?? ControladorCorreo.text,
                contrasena ?? ControladorContrasena.text)
            .then((logueado) {
          if (logueado != null) {
            //Se obtiene el objeto global
            var usuario = context.read<UsuarioModel>();
            //Se setean los datos globales del usuario logueado
            usuario.setearUsuario(logueado);
            usuario.guardarUsuario();
            //Ir a la pantalla principal

            if (logueado.tipo == TipoUsuario.admin) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MainViewAdmin()),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MainView()),
              );
            }
          } else {
            var snackBar = const SnackBar(
                content: Text('Combinación de cédula y contraseña no válidos'));

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        });
      } else {
        var snackBar =
            const SnackBar(content: Text('No se pudo conectar al servidor'));

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  mostrarDialogDebug() {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => Dialog(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        child: Text("Iniciar Sin API"),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MainView()),
                          );
                        },
                      ),
                      Visibility(
                        child: ElevatedButton(
                          child: Text("Iniciar con estudiante"),
                          onPressed: () {
                            iniciarSesion(
                                correo: dotenv.env['CORREO_ESTUDIANTE'] ?? "",
                                contrasena: "123456789");
                          },
                        ),
                        visible: dotenv.env['CORREO_ESTUDIANTE'] != "",
                      ),
                      ElevatedButton(
                        child: Text("Iniciar con profesor"),
                        onPressed: () {
                          iniciarSesion(
                              correo: "antonio@utp.ac.pa",
                              contrasena: "123456789");
                        },
                      ),
                      ElevatedButton(
                        child: Text("Iniciar con admin"),
                        onPressed: () {
                          iniciarSesion(
                              correo: "danger@utp.ac.pa",
                              contrasena: "123456789");
                        },
                      ),
                      Visibility(
                        child: ElevatedButton(
                            child: Text("Ir a asistencias"),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AsistenciaView(
                                        estudiante_id: int.parse(
                                            dotenv.env['ID_ESTUDIANTE'] ?? "1"),
                                        grupo: GRUPO_PRUEBA,
                                        nombre:
                                            dotenv.env['NOMBRE_ESTUDIANTE'] ??
                                                "Estudiante prueba")),
                              );
                            }),
                        visible: dotenv.env['NOMBRE_ESTUDIANTE'] != "" &&
                            dotenv.env['ID_ESTUDIANTE'] != "",
                      ),
                      ElevatedButton(
                        child: Text("Ir a grupo"),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GrupoView(
                                      grupo: GRUPO_PRUEBA,
                                    )),
                          );
                        },
                      ),
                      ElevatedButton(
                        child: Text("Ir a lista estudiantes"),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListadoView(
                                      grupo: GRUPO_PRUEBA,
                                    )),
                          );
                        },
                      ),
                      ElevatedButton(
                        child: Text("Ir a registro asistencia"),
                        onPressed: () async {
                          DateTime ahora = DateTime.now();
                          DateTime? pickeddate = await showDatePicker(
                              context: context,
                              initialDate: ahora,
                              firstDate: DateTime(2000),
                              lastDate:
                                  DateTime(ahora.year, ahora.month, ahora.day));

                          if (pickeddate != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegistroView(
                                        grupo: GRUPO_PRUEBA,
                                        fechahora: pickeddate,
                                        liberarRestricciones: true,
                                      )),
                            );
                          }
                        },
                      ),
                      ElevatedButton(
                        child: Consumer<DebugModel>(
                            builder: (context, debug, child) {
                          return Text(
                              "PRFD ${debug.permitirRegistroFueraDeDia ? "Activado" : "Desactivado"}");
                        }),
                        onPressed: () {
                          context.read<DebugModel>().togglePRFD();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "Presente!",
                          style: TextStyle(
                              fontSize: 70,
                              fontFamily: 'GochiHand',
                              fontWeight: FontWeight.bold,
                              //https://stackoverflow.com/questions/51686868/gradient-text-in-flutter
                              foreground: Paint()..shader = linearGradient),
                        )),
                    Text("Una app para tomar la asistencia"),
                    TxtCampo(
                      nombre: "Correo",
                      controlador: ControladorCorreo,
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: TxtCampo(
                        nombre: "Contraseña",
                        controlador: ControladorContrasena,
                        contrasena: true,
                      ),
                    ),
                    //const SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: COLOR_SECUNDARIO),
                      onPressed: () {
                        iniciarSesion();
                      },
                      //Esto muestra un dialog para hacer depuraciones
                      onLongPress: () => mostrarDialogDebug(),
                      child: const Padding(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 15),
                          child: Text(
                            "Ingresar",
                            style: TextStyle(fontSize: 25),
                          )),
                    ),
                  ],
                ));
          },
        )));
  }
}
