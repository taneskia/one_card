import 'dart:async' show Future;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class ImageService {

  static List<String> imagePaths = [];

  static Future<String> findPathForName(String name) async {
    if(imagePaths.isEmpty) {
      await loadImagePaths();
    }

    return imagePaths.firstWhere((element) => element.contains(name.toLowerCase()));
  }

  static Future loadImagePaths() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    imagePaths = manifestMap.keys
        .where((String key) => key.contains('assets/images'))
        .toList();
  }
}