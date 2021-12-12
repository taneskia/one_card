
class MarketCard {
  final String _marketName;
  final String _barcode;
  final String _barcodeType;
  final String _imagePath;

  MarketCard(this._marketName, this._barcode, this._barcodeType, this._imagePath);

  String get imagePath => _imagePath;

  String get barcodeType => _barcodeType;

  String get barcode => _barcode;

  String get marketName => _marketName;
}