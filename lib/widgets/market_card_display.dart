import 'package:flutter/material.dart';

class MarketCardDisplay extends StatelessWidget {
  final String marketName;
  final String imagePath;

  const MarketCardDisplay(
      {Key? key, required this.marketName, required this.imagePath})
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
                child: Image.network(imagePath),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    marketName,
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
