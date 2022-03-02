import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:one_card/services/barcode_service.dart';
import 'package:one_card/services/market_card_service.dart';
import 'package:one_card/widgets/custom_barcode_scanner.dart';
import 'package:one_card/widgets/market_image_picker.dart';
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
            const Subtitle(subtitleText: 'Select your shop'),
            buildMarketImagePicker(),
            const Subtitle(subtitleText: 'Card Details'),
            buildNameFormField(),
            const Subtitle(subtitleText: 'Scan your card'),
            buildScannedBarcode(),
            buildSaveButton(),
          ],
        ));
  }

  Widget buildMarketImagePicker() {
    return Expanded(
      child: MarketImagePicker(
        onTapped: (String marketName) => setState(() {
          name = marketName;
          _nameTextController.text = marketName;
          nameFormValid = true;
        }),
      ),
    );
  }

  Widget buildScannedBarcode() {
    return Expanded(
        child: CustomBarcodeScanner(
      onBarcodeScanned: (barcode, format) => setState(() {
        this.barcode = barcode;
        this.format = format;
      }),
    ));
  }

  Widget buildNameFormField() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextFormField(
        decoration: const InputDecoration(
          icon: Icon(Icons.store, size: 30),
          hintText: 'Use Latin letters only',
          labelStyle: TextStyle(fontSize: 18),
          labelText: 'Shop name',
        ),
        textCapitalization: TextCapitalization.sentences,
        controller: _nameTextController,
        onChanged: _nameTextChanged,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          RegExp regex = RegExp("^[a-zA-Z ]{2,}\$");
          if (value != null && !regex.hasMatch(value)) {
            nameFormValid = false;
            return 'Name should be in Latin letters\nName should be longer than 2 characters';
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
