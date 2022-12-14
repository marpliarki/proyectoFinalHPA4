import 'package:flutter/material.dart';
import 'package:proyecto1hpa4/componentes/colores.dart';
import 'package:proyecto1hpa4/componentes/titulos.dart';
import 'package:proyecto1hpa4/pantallas/compartido/componente_superior.dart';

class MiPerfilView extends StatelessWidget {
  final String _nombre;
  final String _apellido;
  final String _correo;
  final String _cedula;

  const MiPerfilView(this._nombre, this._apellido, this._correo, this._cedula,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //TITULO
                    ComponenteSuperior(
                      titulo: "Mi Perfil",
                      icono: Icons.arrow_back,
                      callback: () {
                        Navigator.pop(context);
                      },
                    ),
                    //IMAGEN DE PERFIL
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            child: CircleAvatar(
                                //https://stackoverflow.com/questions/51513429/how-to-do-rounded-corners-image-in-flutter
                                radius: 50, // Image radius
                                backgroundColor: COLOR_PRINCIPAL,
                                child: ClipOval(
                                    child: Image.asset(
                                  "assets/images/nerd.png", //usuario.foto,
                                  fit: BoxFit.contain,
                                  height: 90,
                                ))),
                          ))
                        ]),

                    //INFORMACION DE PERFIL
                    const Titulo("Nombre", tipo: TipoTitulo.h2),
                    Text(_nombre),
                    const Titulo("Apellido", tipo: TipoTitulo.h2),
                    Text(_apellido),
                    const Titulo("Cédula", tipo: TipoTitulo.h2),
                    Text(_cedula),
                    const Titulo("Correo", tipo: TipoTitulo.h2),
                    Text(_correo)
                  ],
                ))));
  }
}
