import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:one_card/models/market_card.dart';
import 'package:one_card/services/barcode_service.dart';

class MarketCardDisplay extends StatelessWidget {
  final MarketCard marketCard;

  const MarketCardDisplay({Key? key, required this.marketCard})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await showDialog(
            context: context,
            builder: (_) => _buildBarcodeDialog());
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 3,
        margin: const EdgeInsets.all(7),
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

  Widget _buildBarcodeDialog() {
    return Dialog(
      insetPadding: const EdgeInsets.all(10.0),
      child: SizedBox(
        width: double.infinity,
        height: 200,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: BarcodeWidget(
            barcode: Barcode.fromType(
                BarcodeService.stringToType(marketCard.barcodeType)),
            data: marketCard.barcode,
          ),
        ),
      ),
    );
  }
}
