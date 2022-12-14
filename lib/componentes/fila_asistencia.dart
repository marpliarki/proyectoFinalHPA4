import 'package:flutter/material.dart';

typedef void Callback();

class FilaAsistencia extends StatelessWidget {
  FilaAsistencia(this.columna1, this.columna2, this.columna3,
      {super.key, this.callback});
  String columna1;
  String columna2;
  String columna3;
  Callback? callback;

  @override
  Widget build(BuildContext context) {
    var c = columna3.toLowerCase();
    Color colorFila = Colors.redAccent;

    if (c == "presente") {
      colorFila = Colors.greenAccent;
    } else if (c == "tardanza") {
      colorFila = Colors.yellow;
    } else if (c == "con excusa") {
      colorFila = Colors.orangeAccent;
    }

    return Material(
        color: colorFila,
        child: new InkWell(
            onTap: () {
              if (callback != null) {
                callback!();
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    columna1,
                    textAlign: TextAlign.center,
                  )),
                  Expanded(
                      child: Text(
                    columna2,
                    textAlign: TextAlign.center,
                  )),
                  Expanded(
                      child: Text(
                    columna3,
                    textAlign: TextAlign.center,
                  )),
                ],
              ),
            )));
  }
}

Expanded rowWidget(String Row) {
  return Expanded(
    child: Text(
      Row,
      textAlign: TextAlign.center,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
    ),
  );
}

class EncabezadosAsistencia extends StatelessWidget {
  EncabezadosAsistencia(this.columna1, this.columna2, this.columna3,
      {super.key});
  String columna1;
  String columna2;
  String columna3;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        rowWidget(columna1),
        rowWidget(columna2),
        rowWidget(columna3),
      ],
    );
  }
}
