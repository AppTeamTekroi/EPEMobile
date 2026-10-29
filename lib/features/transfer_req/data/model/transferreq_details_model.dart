class Transferreqdetails {
  final int lineNum;
  final String itemCode;
  final String quantity;
  final String? binQty; // Nullable fields
  final String? binCode;
  final String? binName;
  final String fromWhsCode;
  final String toWhsCode;

  Transferreqdetails({
    required this.lineNum,
    required this.itemCode,
    required this.quantity,
    this.binQty,
    this.binCode,
    this.binName,
    required this.fromWhsCode,
    required this.toWhsCode,
  });

  factory Transferreqdetails.fromJson(Map<String, dynamic> json) {
    return Transferreqdetails(
      lineNum: json['LineNum'] ?? 0,
      itemCode: json['ItemCode'] ?? '',
      quantity: json['Quantity'] ?? '',
      binQty: json['BinQty'],
      binCode: json['BinCode'],
      binName: json['BinName'],
      fromWhsCode: json['FromWhsCode'] ?? '',
      toWhsCode: json['ToWhsCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'LineNum': lineNum,
      'ItemCode': itemCode,
      'Quantity': quantity,
      'BinQty': binQty,
      'BinCode': binCode,
      'BinName': binName,
      'FromWhsCode': fromWhsCode,
      'ToWhsCode': toWhsCode,
    };
  }
}
