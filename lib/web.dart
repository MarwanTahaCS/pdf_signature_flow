// ignore: import_of_legacy_library_into_null_safe
import 'package:universal_html/html.dart';
import 'dart:convert';

Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
  AnchorElement(
      href:
          "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
    ..setAttribute("download", fileName)
    ..click();
}
