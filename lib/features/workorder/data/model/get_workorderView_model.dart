import 'dart:convert';

class WorkOrderView {
  final int lineNum;
  final String itemcode;
  final String plannedqty;
  final String binqty;

 final String warehouse;

  WorkOrderView({
    required this.lineNum,
    required this.itemcode,
    required this.plannedqty,
    required this.binqty,
    required this.warehouse,
  });

  factory WorkOrderView.fromJson(Map<String, dynamic> json) {
    return WorkOrderView(
      lineNum: json['LineNum'] ?? 0,
      itemcode: json['ItemCode'] ?? '',
      plannedqty: json['PlannedQty'] ?? '',
      binqty: json['BinQty'] ?? 'null',
      warehouse: json['wareHouse'] ?? "",
    );
  }
}
