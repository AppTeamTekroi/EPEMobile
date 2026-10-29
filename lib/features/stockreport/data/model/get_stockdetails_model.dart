import 'dart:convert';
class StockDetailsModel {
  String type;
  String itemCode;
  String description;
  String docDate;
  String jrnlMemo;
  double obQty;
  double inQty;
  double OutQty;
  String warehouse;

  StockDetailsModel({
    required this.type,
    required this.itemCode,
    required this.description,
    required this.docDate,
    required this.jrnlMemo,
    required this.obQty,
    required this.inQty,
    required this.OutQty,
    required this.warehouse,
  });

  factory StockDetailsModel.fromJson(Map<String, dynamic> json) {
    return StockDetailsModel(
      type: json['Type'],
      itemCode: json['ItemCode'],
      description: json['Dscription'],
      docDate: json['DocDate'],
      jrnlMemo: json['JrnlMemo'],
      obQty: double.parse(json['OBQty']),
      inQty: double.parse(json['InQty']),
      OutQty: double.parse(json['OutQty']),
      warehouse: json['Warehouse'],
    );
  }

}
