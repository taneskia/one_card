import 'package:barcode_scan/barcode_scan.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:one_card/services/barcode_service.dart';

class CustomBarcodeScanner extends StatefulWidget {

  final void Function(String barcode, BarcodeFormat format) onBarcodeScanned;

  const CustomBarcodeScanner({Key? key, required this.onBarcodeScanned}) : super(key: key);

  @override
  _CustomBarcodeScannerState createState() => _CustomBarcodeScannerState(onBarcodeScanned);
}

class _CustomBarcodeScannerState extends State<CustomBarcodeScanner> {
  final void Function(String barcode, BarcodeFormat format) onBarcodeScanned;

  String barcode = "";
  BarcodeFormat format = BarcodeFormat.code128;
  bool scanFailed = false;
  String formatErrorMessage = "";

  _CustomBarcodeScannerState(this.onBarcodeScanned);

  @override
  Widget build(BuildContext context) {
    Widget widget;
    if (scanFailed && formatErrorMessage.isNotEmpty) {
      widget =
          buildNoCardScanned("Scanned failed. Barcode type not recognized.");
    } else if (scanFailed) {
      widget = buildNoCardScanned("Scanned failed. Please try again.");
    } else if (barcode.isEmpty) {
      widget = buildNoCardScanned("Scanned barcode will appear here.");
    } else {
      widget = BarcodeWidget(
        barcode: Barcode.fromType(BarcodeService.formatToType(format)),
        data: barcode,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: GestureDetector(
        onTap: () async {
          var result = await BarcodeScanner.scan();
          setState(() {
            barcode = result.rawContent;
            format = result.format;
            scanFailed = result.type == ResultType.Error ? true : false;
            formatErrorMessage = result.formatNote;
          });
          onBarcodeScanned(barcode, format);
        },
        child: SizedBox(
          width: double.infinity,
          height: 200,
          child: widget,
        ),
      ),
    );
  }
}

Widget buildNoCardScanned(String message) {
  return DottedBorder(
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
  );
}
