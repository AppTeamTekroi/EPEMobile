class WorkOrderNeGModel {
  String fromWarehouse;
  String toWarehouse;
  String uTrpfmapp;
  String uTrppdno;
  List<StockTransferLine> stockTransferLines;

  WorkOrderNeGModel({
    required this.fromWarehouse,
    required this.toWarehouse,
    required this.uTrpfmapp,
    required this.uTrppdno,
    required this.stockTransferLines,
  });

  factory WorkOrderNeGModel.fromJson(Map<String, dynamic> json) {
    var list = json['StockTransferLines'] as List;
    List<StockTransferLine> stockTransferLinesList = list.map((i) => StockTransferLine.fromJson(i)).toList();

    return WorkOrderNeGModel(
      fromWarehouse: json['FromWarehouse'],
      toWarehouse: json['ToWarehouse'],
      uTrpfmapp: json['U_TRPFMAPP'],
      uTrppdno: json['U_TRPPDNO'],
      stockTransferLines: stockTransferLinesList,
    );
  }

  Map<String, dynamic> toJson() {
    List<Map> stockTransferLinesList = this.stockTransferLines.map((i) => i.toJson()).toList();

    return {
      'FromWarehouse': fromWarehouse,
      'ToWarehouse': toWarehouse,
      'U_TRPFMAPP': uTrpfmapp,
      'U_TRPPDNO': uTrppdno,
      'StockTransferLines': stockTransferLinesList,
    };
  }
}

class StockTransferLine {
  String itemCode;
  String quantity;
  String fromWarehouseCode;
  String warehouseCode;
  String uTrptobin;
  String uTrptobnm;

  StockTransferLine({
    required this.itemCode,
    required this.quantity,
    required this.fromWarehouseCode,
    required this.warehouseCode,
    required this.uTrptobin,
    required this.uTrptobnm,
  });

  factory StockTransferLine.fromJson(Map<String, dynamic> json) {
    return StockTransferLine(
      itemCode: json['ItemCode'],
      quantity: json['Quantity'],
      fromWarehouseCode: json['FromWarehouseCode'],
      warehouseCode: json['WarehouseCode'],
      uTrptobin: json['U_TRPTOBIN'],
      uTrptobnm: json['U_TRPTOBNM'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ItemCode': itemCode,
      'Quantity': quantity,
      'FromWarehouseCode': fromWarehouseCode,
      'WarehouseCode': warehouseCode,
      'U_TRPTOBIN': uTrptobin,
      'U_TRPTOBNM': uTrptobnm,
    };
  }
}