import 'package:flutter/material.dart';
import 'package:one_card/add_card_screen.dart';
import 'package:one_card/services/market_card_service.dart';
import 'package:one_card/widgets/market_card_display.dart';

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
      const ListTile(title: Text('Suggested', style: TextStyle(fontSize: 20))),
      const Divider(thickness: 1, height: 0, indent: 10, endIndent: 10),
      buildSuggestedGrid(),
      const ListTile(title: Text('All', style: TextStyle(fontSize: 20))),
      const Divider(thickness: 1, height: 0, indent: 10, endIndent: 10),
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
        children: _cards
            .map((e) => MarketCardDisplay(marketCard: e))
            .toList(),
      ),
    );
  }

  Widget buildAddButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ElevatedButton(
          style: ButtonStyle(
            fixedSize:
                MaterialStateProperty.all<Size>(const Size.fromWidth(1000)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          child: const Text("Add new card"),
          onPressed: navigateToAddCard,
        ),
      ),
    );
  }

  void navigateToAddCard() async {
    dynamic result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AddCardScreen(),
        ));

    if(result != null && result as bool) {
      setState(() => _cards = _marketCardService.cards);
    }
  }
}
