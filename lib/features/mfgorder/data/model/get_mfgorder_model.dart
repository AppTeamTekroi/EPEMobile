class MfgOrderModel {
  int docNum;
  int docEntry;
  DateTime startDate;
  String itemCode;
  String prodName;
  double plannedQty;
  double cmpltQty;
  double openQty;
  double stockCompare;
  final String BinFlag;
  final String BinName;
  final String BinCode;
  MfgOrderModel({
    required this.docNum,
    required this.docEntry,
    required this.startDate,
    required this.itemCode,
    required this.prodName,
    required this.plannedQty,
    required this.cmpltQty,
    required this.openQty,
    required this.stockCompare,
    required this.BinFlag,
    required this.BinName,
    required this.BinCode,
  });

  factory MfgOrderModel.fromJson(Map<String, dynamic> json) {
    return MfgOrderModel(
      docNum: json['DocNum'],
      docEntry: json['DocEntry'],
      startDate: DateTime.parse(json['StartDate']),
      itemCode: json['ItemCode'],
      prodName: json['ProdName'],
      plannedQty: double.parse(json['PlannedQty']),
      cmpltQty: double.parse(json['CmpltQty']),
      openQty: double.parse(json['OpenQty']),
      stockCompare: double.parse(json['StockCompare']),
      BinFlag: json['BinFlag'] ?? '',
      BinCode : json['BinCode'] ?? 0,
      BinName : json['BinName'] ?? '',
    );
  }
}
