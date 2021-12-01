import 'package:flutter/material.dart';
import 'package:one_card/add_card_screen.dart';
import 'package:one_card/widgets/market_card_display.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
        children: List.generate(8, (index) {
          if (index % 2 == 0) {
            return MarketCardDisplay(
                marketName: "Tinex $index",
                imagePath: "https://www.e-tinex.mk/img/tinex_logo_r.png");
          } else {
            return MarketCardDisplay(
                marketName: "Kam $index",
                imagePath:
                    "https://lh3.googleusercontent.com/proxy/9VWqE_00pq4E_YSlVbrrLQb9f57xP_3lLaKRJo60rAe9aMNegstdjAgljrwuN9NKKdDHDQ34NgpNWrOGjNG5vUO22EcJXniLvH5ZOw");
          }
        }),
      ),
    );
  }

  Widget buildAllGrid() {
    return Expanded(
      flex: 2,
      child: GridView.count(
        scrollDirection: Axis.horizontal,
        crossAxisCount: 2,
        children: List.generate(8, (index) {
          if (index % 2 == 0) {
            return MarketCardDisplay(
                marketName: "Tinex $index",
                imagePath: "https://www.e-tinex.mk/img/tinex_logo_r.png");
          } else {
            return MarketCardDisplay(
                marketName: "Kam $index",
                imagePath:
                    "https://lh3.googleusercontent.com/proxy/9VWqE_00pq4E_YSlVbrrLQb9f57xP_3lLaKRJo60rAe9aMNegstdjAgljrwuN9NKKdDHDQ34NgpNWrOGjNG5vUO22EcJXniLvH5ZOw");
          }
        }),
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

  void navigateToAddCard() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AddCardScreen(),
        ));
  }
}
