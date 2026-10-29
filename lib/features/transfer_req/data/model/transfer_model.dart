class TransferModel {
  final int docNum;
  final int docEntry;
  final dynamic startDate;
  final String itemCode;
  final String prodName;
  final double plannedQty;
  final double cmpltQty;
  final double openQty;
  final double stockCompare;
  final String BinFlag;
  final String BinName;
  final String BinCode;
  TransferModel({
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

  factory TransferModel.fromJson(Map<String, dynamic> json) {

    return TransferModel(
      docNum: json['DocNum'] ?? "",
      docEntry: json['DocEntry'] ?? '',
      startDate: DateTime.parse(json['StartDate']),
      itemCode: json['ItemCode'] ?? '',
      prodName: json['ProdName'] ?? '',
      plannedQty: double.parse(json['PlannedQty']) ?? 0,
      cmpltQty: double.parse(json['CmpltQty']) ?? 0,
      openQty: double.parse(json['OpenQty']) ?? 0,
      stockCompare: double.parse(json['StockCompare']) ?? 0,
      BinFlag : json['BinFlag'] ?? '',
      BinCode : json['BinCode'] ?? "",
      BinName : json['BinName'] ?? '',
    );
  }
}
