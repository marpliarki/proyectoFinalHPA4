import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto1hpa4/componentes/datos/control_db_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:proyecto1hpa4/componentes/change_notifiers/usuario_model.dart';
import 'package:proyecto1hpa4/componentes/clases/Grupo.dart';
import 'package:proyecto1hpa4/componentes/clases/Usuario.dart';
import 'package:proyecto1hpa4/componentes/datos/control_db.dart';
import 'package:proyecto1hpa4/componentes/funciones.dart';
import 'package:proyecto1hpa4/componentes/tarjeta_grupo.dart';
import 'package:proyecto1hpa4/pantallas/asistencia_view.dart';
import 'package:proyecto1hpa4/pantallas/compartido/componente_superior.dart';
import 'package:proyecto1hpa4/pantallas/grupo_view.dart';
import 'package:proyecto1hpa4/pantallas/login_view.dart';
import 'package:proyecto1hpa4/pantallas/main_view/compartido/datos_usuario.dart';

import '../../componentes/colores.dart';
import '../../componentes/titulos.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  List<Grupo> grupos = [];
  bool resultadosCargados = false;

  @override
  void initState() {
    super.initState();

    Provider.of<UsuarioModel>(context, listen: false)
        .cargarUsuario()
        .then((value) {
      Usuario? u =
          Provider.of<UsuarioModel>(context, listen: false).usuarioActual;

      if (u != null) {
        ControlDb.getGrupos(u.id_entidad, u.tipo).then((value) {
          if (value != null) {
            setState(() {
              grupos = value;
            });
          } else {
            print("Error al cargar grupos");
          }
          setState(() {
            resultadosCargados = true;
          });
        });
      }
    });
  }

  void callbackGrupo(Grupo grupo) {
    Usuario? usuario =
        Provider.of<UsuarioModel>(context, listen: false).usuarioActual;
    if (usuario != null) {
      if (usuario.tipo == TipoUsuario.profesor) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GrupoView(grupo: grupo),
            ));
      } else if (usuario.tipo == TipoUsuario.estudiante) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AsistenciaView(
                    grupo: grupo,
                    estudiante_id: usuario.id_entidad,
                    nombre: Provider.of<UsuarioModel>(context, listen: false)
                        .nombreCompleto,
                  )),
        );
      }
    }
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
                  "Listado de clases",
                  tipo: TipoTitulo.h1,
                ),
                const SizedBox(height: 10),
                resultadosCargados
                    ? Expanded(
                        child: grupos.isNotEmpty
                            ? ListView.builder(
                                itemCount: grupos.length,
                                itemBuilder: (context, index) {
                                  return TarjetaGrupo(
                                    grupos[index],
                                    callback: (grupo) => callbackGrupo(grupo),
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
