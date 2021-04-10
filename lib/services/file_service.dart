import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<File> _getFile() async {
  final Directory directory = await getApplicationDocumentsDirectory();

  return File("${directory.path}/data.json");
}

Future<File> saveData(List dados) async {
  String dataJson = json.encode(dados);
  final File file = await _getFile();
  return file.writeAsString(dataJson);
}

Future<String> readData() async {
  try {
    final File file = await _getFile();
    return file.readAsString();
  } catch (e) {
    return null;
  }
}
