import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:one_card/services/barcode_service.dart';
import 'package:one_card/services/market_card_service.dart';
import 'package:one_card/widgets/subtitle.dart';
import 'package:one_card/widgets/wide_button.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({Key? key}) : super(key: key);

  @override
  _AddCardScreenState createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final MarketCardService _marketCardService = MarketCardService();

  final _nameTextController = TextEditingController();

  String name = "";
  bool nameFormValid = false;
  String barcode = "";
  BarcodeFormat format = BarcodeFormat.code128;
  bool scanFailed = false;
  String formatErrorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.black),
            title: const Text('Add new card',
                style: TextStyle(color: Colors.black))),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const Subtitle(subtitleText: 'Card Details'),
                buildNameFormField(),
              ],
            ),
            Column(
              children: [
                const Subtitle(subtitleText: 'Scan your card'),
                buildScannedBarcode(),
                //buildScanButton(),
              ],
            ),
            buildSaveButton(),
          ],
        ));
  }

  Widget buildScannedBarcode() {
    Widget widget;
    if (scanFailed && formatErrorMessage.isNotEmpty) {
      widget =
          buildNoCardScanned("Scanned failed. Barcode type not recognized");
    } else if (scanFailed) {
      widget = buildNoCardScanned("Scanned failed. Please try again");
    } else if (barcode.isEmpty) {
      widget = buildNoCardScanned("Scanned barcode will appear here");
    } else {
      widget = Padding(
        padding: const EdgeInsets.all(15.0),
        child: BarcodeWidget(
          barcode: Barcode.fromType(BarcodeService.formatToType(format)),
          data: barcode,
        ),
      );
    }
    return GestureDetector(
      onTap: () async {
        var result = await BarcodeScanner.scan();
        setState(() {
          barcode = result.rawContent;
          format = result.format;
          scanFailed = result.type == ResultType.Error ? true : false;
          formatErrorMessage = result.formatNote;
        });
      },
      child: SizedBox(
        width: double.infinity,
        height: 200,
        child: widget,
      ),
    );
  }

  Widget buildScanButton() {
    return WideButton(
        buttonText: "Scan",
        onPressed: () async {
          var result = await BarcodeScanner.scan();
          setState(() {
            barcode = result.rawContent;
            format = result.format;
            scanFailed = result.type == ResultType.Error ? true : false;
            formatErrorMessage = result.formatNote;
          });
        });
  }

  Widget buildNameFormField() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextFormField(
        decoration: const InputDecoration(
          icon: Icon(Icons.store, size: 30),
          hintText: 'Enter the shop name using english letters',
          labelStyle: TextStyle(fontSize: 18),
          labelText: 'Shop name*',
        ),
        controller: _nameTextController,
        onChanged: _nameTextChanged,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          RegExp regex = RegExp("^[a-zA-Z]{2,}\$");
          if (value != null && !regex.hasMatch(value)) {
            nameFormValid = false;
            return 'Name should be in english letter\nName should be longer than 2 characters';
          }
          nameFormValid = true;
          return null;
        },
      ),
    );
  }

  Widget buildSaveButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: WideButton(
          disabled: !nameFormValid || barcode.isEmpty,
          buttonText: "Save",
          onPressed: _saveNewCard),
    );
  }

  Widget buildNoCardScanned(String message) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(10),
        dashPattern: const [6, 3],
        color: Colors.grey,
        strokeWidth: 2,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Tap to scan",
                style: TextStyle(fontSize: 20),
              ),
              Text(
                message,
                style: const TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _nameTextChanged(String value) {
    setState(() {
      name = _nameTextController.value.text;
    });
  }

  void _saveNewCard() async {
    await _marketCardService.saveMarketCart(
        name, barcode, BarcodeService.formatToString(format));
    Navigator.pop(context, true);
  }
}
