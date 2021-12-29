import 'package:flutter/material.dart';
import 'package:one_card/models/market_card.dart';
import 'package:one_card/services/market_card_service.dart';

import 'market_card_display.dart';

class MarketImagePicker extends StatefulWidget {
  final Function onTapped;

  const MarketImagePicker({Key? key, required this.onTapped}) : super(key: key);

  @override
  State<MarketImagePicker> createState() => _MarketImagePickerState(onTapped);
}

class _MarketImagePickerState extends State<MarketImagePicker> {
  final MarketCardService _marketCardService = MarketCardService();
  List<MarketCard> _knownCards = [];
  final Function onTapped;

  _MarketImagePickerState(this.onTapped);

  @override
  void initState() {
    super.initState();
    _loadKnownCards();
  }

  _loadKnownCards() async {
    await _marketCardService.knownMarketCards
        .then((value) => setState(() => _knownCards = value));
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      scrollDirection: Axis.horizontal,
      crossAxisCount: 1,
      children: _knownCards
          .map((e) => MarketCardDisplay(
                marketCard: e,
                onDeleted: () {},
                imageOnlyMode: true,
                onTapped: (String marketName) => onTapped(marketName),
              ))
          .toList(),
    );
  }
}
