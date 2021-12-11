import 'package:barcode_scan/barcode_scan.dart';
import 'package:barcode_widget/barcode_widget.dart';

class BarcodeService {
  static BarcodeType formatToType(BarcodeFormat format) {
    return BarcodeType.values.toList().firstWhere((type) =>
        type.toString().toLowerCase().contains(format.name.toLowerCase())
    );
  }
  static BarcodeType stringToType(String stringType) {
    return BarcodeType.values.toList().firstWhere((type) =>
        type.toString().toLowerCase().contains(stringType.toLowerCase())
    );
  }

  static String typeToString(BarcodeType type) {
    return type.toString().split(".")[1];
  }

  static String formatToString(BarcodeFormat format) {
    return format.name.toLowerCase();
  }
}
