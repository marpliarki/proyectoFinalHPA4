extension StringExtension on String {
  String f_primeraMayuscula() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

extension DateOnlyCompare on DateTime {
  bool esMismaFecha(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  String obtenerFecha() {
    return "$year-${month < 10 ? "0$month" : month}-${day < 10 ? "0$day" : day}";
  }

  String obtenerHora() {
    return "${hour < 10 ? "0$hour" : hour}:${minute < 10 ? "0$minute" : minute}";
  }
}

String? obtenerNombreEstadoAsistencia(int num) {
  List<String> nombres = ["Presente", "Tardanza", "Ausente", "Con Excusa"];
  try {
    return nombres[num - 1];
  } catch (e) {
    return null;
  }
}
