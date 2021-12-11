import 'package:barcode_scan/barcode_scan.dart';
import 'package:barcode_widget/barcode_widget.dart';

class BarcodeFormatToType {
  static BarcodeType convert(BarcodeFormat format) {
    return BarcodeType.values.toList().firstWhere((type) =>
        type.toString().toLowerCase().contains(format.name.toLowerCase())
    );
  }
}
