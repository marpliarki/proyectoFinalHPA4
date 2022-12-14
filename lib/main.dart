import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:proyecto1hpa4/componentes/change_notifiers/debug_model.dart';
import 'package:proyecto1hpa4/componentes/change_notifiers/usuario_model.dart';
import 'package:proyecto1hpa4/componentes/clases/Usuario.dart';
import 'package:proyecto1hpa4/componentes/colores.dart';
import 'package:proyecto1hpa4/pantallas/main_view/main_view.dart';
import 'package:proyecto1hpa4/pantallas/main_view/main_view_admin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'componentes/scroll.dart';
import 'package:proyecto1hpa4/pantallas/login_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print(e);
  }

  final prefs = await SharedPreferences.getInstance();
  String? u = prefs.getString('usuario');
  TipoUsuario t = TipoUsuario.usuario;

  if (u != null) {
    Map<String, dynamic> mapaUsuario = jsonDecode(u) as Map<String, dynamic>;
    Usuario usuario = Usuario.fromMapSharedPreferences(mapaUsuario);
    t = usuario.tipo;
  }

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<UsuarioModel>(
        create: ((context) => UsuarioModel()),
      ),
      ChangeNotifierProvider<DebugModel>(
        create: ((context) => DebugModel()),
      )
    ],
    child: MyApp(
      iniciarSesion: u == null,
      tipo: t,
    ),
  ));
}

class MyApp extends StatelessWidget {
  MyApp({super.key, required this.iniciarSesion, required this.tipo});
  bool iniciarSesion;
  TipoUsuario tipo;

  @override
  Widget build(BuildContext context) {
    Widget pantalla = iniciarSesion
        ? LoginView()
        : (tipo == TipoUsuario.admin ? MainViewAdmin() : MainView());

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Presente!',
        scrollBehavior: MyCustomScrollBehavior(),
        theme: ThemeData(
          primarySwatch: colorPrimario,
        ),
        home: pantalla);
  }
}
