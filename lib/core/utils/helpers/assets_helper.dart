import 'dart:convert';
import 'package:flutter/services.dart';

//this is used to parse the json from asset
class AssetsHelper {
  static Future<String> loadJsonFromAssets(String filePath) async {
    String jsonString = await rootBundle.loadString(filePath);
    return jsonString;
  }

  static Future<List<String>> loadAllJsonFilesFromAssetFolder({
    required String folderPath,
  }) async {
    // Get the asset manifest
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    // Filter for JSON files from the specified folder
    final List<String> jsonPaths =
        manifestMap.keys
            .where(
              (String key) =>
                  key.startsWith(folderPath) && key.endsWith('.json'),
            )
            .toList();

    // Load all JSON files
    List<String> allData = [];
    for (String path in jsonPaths) {
      final String jsonString = await loadJsonFromAssets(path);
      allData.add(jsonString);
    }
    return allData;
  }
}
