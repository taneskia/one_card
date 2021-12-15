import 'package:flutter/material.dart';
import 'package:one_card/add_card_screen.dart';
import 'package:one_card/services/market_card_service.dart';
import 'package:one_card/widgets/market_card_display.dart';
import 'package:one_card/widgets/subtitle.dart';
import 'package:one_card/widgets/wide_button.dart';

import 'models/market_card.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final MarketCardService _marketCardService = MarketCardService();
  List<MarketCard> _cards = [];

  @override
  void initState() {
    super.initState();
    _cards = _marketCardService.cards;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Subtitle(subtitleText: 'Suggested'),
      buildSuggestedGrid(),
      const Subtitle(subtitleText: 'All'),
      buildAllGrid(),
      buildAddButton(),
    ]);
  }

  Widget buildSuggestedGrid() {
    return Expanded(
      child: GridView.count(
        scrollDirection: Axis.horizontal,
        crossAxisCount: 1,
        children: _marketCardService.cards
            .map((e) => MarketCardDisplay(marketCard: e))
            .toList(),
      ),
    );
  }

  Widget buildAllGrid() {
    return Expanded(
      flex: 2,
      child: GridView.count(
        scrollDirection: Axis.horizontal,
        crossAxisCount: 2,
        children: _cards.map((e) => MarketCardDisplay(marketCard: e)).toList(),
      ),
    );
  }

  Widget buildAddButton() {
    return WideButton(buttonText: "Add new card", onPressed: navigateToAddCard);
  }

  void navigateToAddCard() async {
    dynamic result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AddCardScreen(),
        ));

    if (result != null && result as bool) {
      setState(() => _cards = _marketCardService.cards);
    }
  }
}
