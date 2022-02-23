import 'dart:convert';
import 'dart:io';

import 'package:cube_painter/data/persist.dart';
import 'package:cube_painter/out.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

const noWarn = out;

class Assets {
  static Future<Map<String, dynamic>> loadJson(String filePath) async {
    final String json = await rootBundle.loadString(filePath);

    Map<String, dynamic> map = jsonDecode(json);
    return map;
  }

  static Future<List<String>> getFilePaths(String folderPath) async {
    final manifestJson = await rootBundle.loadString('AssetManifest.json');

    final fileNames = jsonDecode(manifestJson)
        .keys
        .where((String key) => key.startsWith(folderPath + '/'));

    return fileNames.toList();
  }

  static Future<void> copyAllFromTo(
      String fromAssetFolderPath, String toAppFolderPath) async {
    final assetFilePaths = await getFilePaths(fromAssetFolderPath);

    final Directory appFolder = await getApplicationDocumentsDirectory();
    final String appFolderPath = '${appFolder.path}${Platform.pathSeparator}';

    for (String filePath in assetFilePaths) {
      final fileName = filePath.split(Platform.pathSeparator).last;
      final String appFilePath = '$appFolderPath$fileName';
      final String json = await rootBundle.loadString(filePath);
      await saveString(filePath: appFilePath, string: json);
    }
  }
}
