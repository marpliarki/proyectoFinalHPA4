import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto1hpa4/componentes/change_notifiers/usuario_model.dart';
import 'package:proyecto1hpa4/componentes/colores.dart';
import 'package:proyecto1hpa4/componentes/titulos.dart';
import 'package:proyecto1hpa4/pantallas/mi_perfil_view.dart';

class DatosUsuario extends StatelessWidget {
  const DatosUsuario({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          //color: Colors.red,
          child: Consumer<UsuarioModel>(
        builder: (context, usuario, child) {
          return Row(children: [
            CircleAvatar(
              //https://stackoverflow.com/questions/51513429/how-to-do-rounded-corners-image-in-flutter
              radius: 50, // Image radius
              backgroundColor: COLOR_PRINCIPAL,
              child: ClipOval(
                  child: Image.asset(
                "assets/images/nerd.png", //usuario.foto,
                fit: BoxFit.contain,
                height: 90,
              )),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Titulo(usuario.nombreCompleto, tipo: TipoTitulo.h2),
                  Text(usuario.usuarioActual?.cedula ?? "X-XXX-XXXX"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MiPerfilView(
                                  usuario.usuarioActual?.nombre ?? "SIN NOMBRE",
                                  usuario.usuarioActual?.apellido ??
                                      "SIN APELLIDO",
                                  usuario.usuarioActual?.correo ?? "SIN CORREO",
                                  usuario.usuarioActual?.cedula ??
                                      "SIN CEDULA")));
                    },
                    child: const Text('Ver perfil'),
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(50, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.centerLeft),
                  )
                ],
              ),
            ))
          ]);
        },
      )),
    );
  }
}
