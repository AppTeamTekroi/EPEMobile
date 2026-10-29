class MfgDetailsModel {
  int lineNum;
  String itemCode;
  String plannedQty;
  final String binqty;
  final String warehouse;

  MfgDetailsModel({
    required this.lineNum,
    required this.itemCode,
    required this.plannedQty,

    required this.binqty,
    required this.warehouse,
  });

  factory MfgDetailsModel.fromJson(Map<String, dynamic> json) {
    return MfgDetailsModel(
      lineNum: json['LineNum'] ?? 0,
      itemCode: json['ItemCode'] ?? "",
      plannedQty: json['PlannedQty'] ?? '',

      binqty: json['BinQty'] ?? '',
      warehouse: json['wareHouse'] ?? "",
    );
  }

}
