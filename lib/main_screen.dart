import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:one_card/add_card_screen.dart';
import 'package:one_card/services/location_service.dart';
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

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  final MarketCardService _marketCardService = MarketCardService();
  final LocationService _locationService = LocationService();
  List<MarketCard> _cards = [];
  List<MarketCard> _suggestedCards = [];
  DateTime _lastLoadedSuggested = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    loadCards();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        DateTime.now().difference(_lastLoadedSuggested).inMinutes > 5) {
      _lastLoadedSuggested = DateTime.now();
      loadCards();
    }
  }

  Future loadCards() async {
    _marketCardService.cards.then((cards) {
      setState(() => _cards = cards);
      setState(() => _suggestedCards = cards);
      context.loaderOverlay.show();
      _locationService.filerNearbyPlaces(cards).onError((error, stackTrace) {
        context.loaderOverlay.hide();
        return _cards;
      }).then((suggestedCards) {
        setState(() => _suggestedCards = suggestedCards);
        context.loaderOverlay.hide();
      });
    });
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
      child: LoaderOverlay(
        overlayOpacity: 0.2,
        child: GridView.count(
          scrollDirection: Axis.horizontal,
          crossAxisCount: 1,
          children: _suggestedCards
              .map((e) => MarketCardDisplay(
                    marketCard: e,
                    onDeleted: (id) {
                      _marketCardService.deleteMarketCard(id);
                      loadCards();
                    },
                  ))
              .toList(),
        ),
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
            .map((e) => MarketCardDisplay(
                  marketCard: e,
                  onDeleted: (id) {
                    _marketCardService.deleteMarketCard(id);
                    loadCards();
                  },
                ))
            .toList(),
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
      loadCards();
    }
  }
}
