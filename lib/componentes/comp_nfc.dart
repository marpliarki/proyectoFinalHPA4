import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:nfc_manager/nfc_manager.dart';

NdefRecord crearRegistroTexto(String texto) {
  const languageCode = 'en';

  return NdefRecord(
    typeNameFormat: NdefTypeNameFormat.nfcWellknown,
    type: Uint8List.fromList([0x54]),
    identifier: Uint8List(0),
    payload: Uint8List.fromList([
      languageCode.length,
      ...ascii.encode(languageCode),
      ...utf8.encode(texto),
    ]),
  );
}

String encriptarDatos(String cedula, int id) {
  String intermedio = '$cedula@$id';
  String codificado = base64.encode(utf8.encode(intermedio));
  var digest = sha256.convert(utf8.encode(codificado));
  return digest.toString();
}
