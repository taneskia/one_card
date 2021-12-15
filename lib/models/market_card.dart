class MarketCard {
  int? _id;
  final String _marketName;
  final String _barcode;
  final String _barcodeType;
  final String _imagePath;

  MarketCard(
      this._marketName, this._barcode, this._barcodeType, this._imagePath,
      [this._id]);

  int? get id => _id;

  String get imagePath => _imagePath;

  String get barcodeType => _barcodeType;

  String get barcode => _barcode;

  String get marketName => _marketName;

  Map<String, dynamic> toMap() {
    return {
      'market_name': _marketName,
      'barcode': _barcode,
      'barcode_type': _barcodeType,
      'image_path': _imagePath
    };
  }

  factory MarketCard.fromMap(Map<String, dynamic> map) => MarketCard(
      map['market_name'],
      map['barcode'],
      map['barcode_type'],
      map['image_path'],
      map['id']);
}
