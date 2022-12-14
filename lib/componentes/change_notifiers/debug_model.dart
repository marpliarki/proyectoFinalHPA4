import 'package:flutter/cupertino.dart';

class DebugModel extends ChangeNotifier {
  bool apiDisponible = true;
  bool permitirRegistroFueraDeDia = false;

  void setApiDisponible(bool estado) {
    apiDisponible = estado;
  }

  /// Cambia el estado de permitirRegistroFueraDeDia
  void togglePRFD() {
    permitirRegistroFueraDeDia = !permitirRegistroFueraDeDia;
    notifyListeners();
  }
}
