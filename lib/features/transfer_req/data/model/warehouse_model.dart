class WarehouseModel {
  final String whsCode;

  WarehouseModel({required this.whsCode});

  factory WarehouseModel.fromJson(Map<String, dynamic> json) {
    return WarehouseModel(
      whsCode: json['WhsCode'] as String,
    );
  }
}
