import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:one_card/services/barcode_format_to_type_service.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({Key? key}) : super(key: key);

  @override
  _AddCardScreenState createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
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
          barcode: Barcode.fromType(BarcodeFormatToType.convert(format)),
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
}
