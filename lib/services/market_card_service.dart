import 'package:one_card/models/market_card.dart';
import 'dart:async' show Future;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:one_card/services/db_service.dart';
import 'package:sqflite/sqflite.dart';

class MarketCardService {
  static final MarketCardService _service = MarketCardService._private();

  List<String> _imagePaths = [];

  // ignore: prefer_final_fields
  List<MarketCard> _cards = [];

  final DbService _dbService = DbService();

  factory MarketCardService() {
    return _service;
  }

  MarketCardService._private();

  Future<List<MarketCard>> get knownMarketCards async {
    if (_imagePaths.isEmpty) {
      await _loadImagePaths();
    }

    List<MarketCard> knownMarketCards = _imagePaths
        .map((imagePath) {
          String marketName = imagePath.split('/').last.split('.').first;
          marketName = marketName[0].toUpperCase() + marketName.substring(1);
          return MarketCard(marketName, "", "", imagePath);
        })
        .where((card) => card.marketName != 'Other')
        .toList();

    knownMarketCards.sort((a, b) => a.marketName.compareTo(b.marketName));

    return knownMarketCards;
  }

  Future<List<MarketCard>> get cards async {
    Database database = await _dbService.database;

    final List<Map<String, dynamic>> maps = await database.query('cards');

    return List.generate(maps.length, (i) => MarketCard.fromMap(maps[i]));
  }

  Future saveMarketCart(String name, String barcode, String barcodeType) async {
    String imagePath = await _findImagePathForName(name);
    MarketCard marketCard = MarketCard(name, barcode, barcodeType, imagePath);

    Database database = await _dbService.database;
    await database.insert('cards', marketCard.toMap());

    _cards.add(marketCard);
  }

  Future deleteMarketCard(int id) async {
    Database database = await _dbService.database;
    await database.delete('cards', where: 'id=$id');
  }

  Future<String> _findImagePathForName(String name) async {
    if (_imagePaths.isEmpty) {
      await _loadImagePaths();
    }
    // TODO: change the generic image to a completely royalty free
    return _imagePaths.firstWhere(
        (element) => element.toLowerCase().contains(name.toLowerCase()),
        orElse: () => "assets/images/other.jpg");
  }

  Future _loadImagePaths() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    _imagePaths = manifestMap.keys
        .where((String key) => key.contains('assets/images'))
        .toList();
  }
}
