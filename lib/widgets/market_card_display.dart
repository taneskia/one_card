import 'package:flutter/material.dart';
import 'package:one_card/models/market_card.dart';

class MarketCardDisplay extends StatelessWidget {
  final MarketCard marketCard;

  const MarketCardDisplay(
      {Key? key, required this.marketCard})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      margin: const EdgeInsets.all(7),
      child: InkWell(
        splashColor: Theme.of(context).splashColor,
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Image(image: AssetImage(marketCard.imagePath)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    marketCard.marketName,
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
