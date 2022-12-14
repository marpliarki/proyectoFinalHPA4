import 'package:flutter/material.dart';
import 'dart:math';

const MaterialColor colorPrimario = Colors.indigo;

Color colorize(n, range) {
  var amp = 1;
  var d = (n / range) * pi;
  var r = ((sin(d + pi * 0.5) + amp) / 2) * 255 * 1;
  var g = ((sin(d + pi * 2) + amp) / 2) * 255 * 0.75;
  var b = ((sin(d + pi * 1.5) + amp) / 2) * 255 * 0.85;
  return Color.fromARGB(255, r.round(), g.round(), b.round());
}

const Color COLOR_PRINCIPAL = Colors.indigoAccent;
const Color COLOR_SECUNDARIO = Colors.pinkAccent;
