import 'package:one_card/models/market_card.dart';
import 'dart:async' show Future;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class MarketCardService {
  static final MarketCardService _service = MarketCardService._private();
  static List<String> imagePaths = [];

  // ignore: prefer_final_fields  
  List<MarketCard> _cards = [];


  factory MarketCardService() {
    return _service;
  }

  MarketCardService._private();

  List<MarketCard> get cards => _cards;

  Future saveMarketCart(String name, String barcode, String barcodeType) async {
    String imagePath = await _findImagePathForName(name);
    MarketCard marketCard = MarketCard(name, barcode, barcodeType, imagePath);
    _cards.add(marketCard);
  }

  static Future<String> _findImagePathForName(String name) async {
    if(imagePaths.isEmpty) {
      await _loadImagePaths();
    }
    // TODO: use generic image if one with appropriate name is not found
    return imagePaths.firstWhere((element) => element.toLowerCase().contains(name.toLowerCase()));
  }

  static Future _loadImagePaths() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    imagePaths = manifestMap.keys
        .where((String key) => key.contains('assets/images'))
        .toList();
  }
}
