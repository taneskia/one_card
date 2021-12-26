import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:one_card/models/market_card.dart';
import 'package:one_card/services/barcode_service.dart';
class MarketCardDisplay extends StatelessWidget {
  final MarketCard marketCard;
  final Function onDeleted;

  const MarketCardDisplay(
      {Key? key, required this.marketCard, required this.onDeleted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await showDialog(
            context: context, builder: (_) => _buildBarcodeDialog(context));
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

  Widget _buildBarcodeDialog(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(10.0),
      child: SizedBox(
        width: double.infinity,
        height: 250,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBarcodeWidget(),
              _buildDialogButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBarcodeWidget() {
    return BarcodeWidget(
      barcode:
          Barcode.fromType(BarcodeService.stringToType(marketCard.barcodeType)),
      data: marketCard.barcode,
    );
  }

  Widget _buildDialogButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close)),
        IconButton(
            onPressed: () => _onDeletePressed(context),
            icon: const Icon(Icons.delete))
      ],
    );
  }

  void _onDeletePressed(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () => Navigator.pop(context),
    );

    Widget deleteButton = TextButton(
      child: const Text("Delete"),
      onPressed: () {
        onDeleted(marketCard.id);
        // Pops the AlertDialog
        Navigator.pop(context);
        // Pops the parent, in this case the barcode Dialog
        _popFromNavigator(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Confirm delete?"),
      actions: [
        cancelButton,
        deleteButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _popFromNavigator(BuildContext context) {
    Navigator.pop(context);
  }
}
