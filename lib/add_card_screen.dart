import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:one_card/services/barcode_service.dart';
import 'package:one_card/services/market_card_service.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({Key? key}) : super(key: key);

  @override
  _AddCardScreenState createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final MarketCardService _marketCardService = MarketCardService();

  final _nameTextController = TextEditingController();

  String name = "";
  String barcode = "";
  BarcodeFormat format = BarcodeFormat.code128;
  bool scanFailed = false;
  String formatErrorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.black),
            title:
                const Text('My Page', style: TextStyle(color: Colors.black))),
        body: Column(
          children: [
            const ListTile(
                title: Text('Scan your card', style: TextStyle(fontSize: 20))),
            const Divider(thickness: 1, height: 0, indent: 10, endIndent: 10),
            buildScannedBarcode(),
            buildScanButton(),
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  labelText: "Shop name",
                ),
                controller: _nameTextController,
                onChanged: _nameTextChanged,
              ),
            ),
            buildSaveButton()
          ],
        ));
  }

  Widget buildScannedBarcode() {
    Widget widget;
    if (scanFailed && formatErrorMessage.isNotEmpty) {
      widget = const Center(
          child: Text("Scanned failed. Barcode type not recognized."));
    } else if (scanFailed) {
      widget = const Center(child: Text("Scanned failed. Please try again."));
    } else if (barcode.isEmpty) {
      widget = const Center(child: Text("Scanned barcode will appear here"));
    } else {
      widget = Padding(
        padding: const EdgeInsets.all(15.0),
        child: BarcodeWidget(
          barcode: Barcode.fromType(BarcodeService.formatToType(format)),
          data: barcode,
        ),
      );
    }
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: widget,
    );
  }

  Widget buildScanButton() {
    return Padding(
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
        child: const Text("Scan"),
        onPressed: () async {
          var result = await BarcodeScanner.scan();
          setState(() {
            barcode = result.rawContent;
            format = result.format;
            scanFailed = result.type == ResultType.Error ? true : false;
            formatErrorMessage = result.formatNote;
          });
        },
      ),
    );
  }

  Widget buildSaveButton() {
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
          child: const Text("Save"),
          onPressed: () async {
            // TODO: create a named function outside of this widget and add validation
            await _marketCardService.saveMarketCart(
                name, barcode, BarcodeService.formatToString(format));
            Navigator.pop(context, true);
          },
        ),
      ),
    );
  }

  void _nameTextChanged(String value) {
    setState(() {
      name = _nameTextController.value.text;
    });
  }
}
