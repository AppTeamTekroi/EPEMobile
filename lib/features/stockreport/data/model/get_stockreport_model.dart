class StockReportModel {
  final String itemCode;
  final String itemName;
  final String whsCode;
  final int binLocationCode;
  final String onHandQty;
  final String uom;

  StockReportModel({
    required this.itemCode,
    required this.itemName,
    required this.whsCode,
    required this.binLocationCode,
    required this.onHandQty,
    required this.uom,
  });

  factory StockReportModel.fromJson(Map<String, dynamic> json) {

    return StockReportModel(
      itemCode: json['ItemCode'] ?? '', // Use an empty string as a default value
      itemName: json['ItemName'] ?? '',
      whsCode: json['WhsCode'] ?? '',
      binLocationCode: json['BINLOCATIONCODE'] ?? 0, // Use 0 as a default value for integers
      onHandQty: json['OnHandQty'] ?? '',
      uom: json['UOM'] ?? '',
    );
  }
}