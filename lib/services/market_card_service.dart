import 'package:one_card/models/market_card.dart';

class MarketCardService {
  static final MarketCardService _service = MarketCardService._private();

  // ignore: prefer_final_fields
  List<MarketCard> _cards = List.generate(10, (index) {
    if (index % 2 == 0) {
      return MarketCard("Kam", "abc", "assets/images/kam.jpg");
    } else {
      return MarketCard("Tinex", "abc", "assets/images/tinex.jpg");
    }
  });

  factory MarketCardService() {
    return _service;
  }

  MarketCardService._private();

  List<MarketCard> get cards => _cards;

  // Future saveMarketCart() {
  //   // needs to find the appropriate image path and save a new card
  // }
}
