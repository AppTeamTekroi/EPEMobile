class StockTransferModel {
  final String fromWarehouse;
  final String toWarehouse;
  final String ProdDoc;
  final String yes;

  final List<StockTransferLine> stockTransferLines;

  StockTransferModel({
    required this.fromWarehouse,
    required this.toWarehouse,
    required this.stockTransferLines,
    required this.ProdDoc,
     required this.yes,
  });

  Map<String, dynamic> toJson() {
    return {
      'FromWarehouse': fromWarehouse,
      'ToWarehouse': toWarehouse,
      'U_TRPFMAPP' :yes,
      'U_TRPPDNO':ProdDoc,
      'StockTransferLines': stockTransferLines.map((line) => line.toJson()).toList(),
    };
  }

  static StockTransferModel fromJson(Map<String, dynamic> json) {
    return StockTransferModel(
      fromWarehouse: json['FromWarehouse'],
      toWarehouse: json['ToWarehouse'],
      yes : json['U_TRPFMAPP'],
      ProdDoc : json['U_TRPPDNO'],
      stockTransferLines: List<StockTransferLine>.from(
        json['StockTransferLines'].map((line) => StockTransferLine.fromJson(line)),
      ),
    );
  }
}
class StockTransferLine {
  final String itemCode;
  final double quantity;
  final String fromWarehouseCode;
  final String warehouseCode;
  final List<StockTransferLineBinAllocation> stockTransferLinesBinAllocations;

  StockTransferLine({
    required this.itemCode,
    required this.quantity,
    required this.fromWarehouseCode,
    required this.warehouseCode,
    required this.stockTransferLinesBinAllocations,
  });

  Map<String, dynamic> toJson() {
    return {
      'ItemCode': itemCode,
      'Quantity': quantity,
      'FromWarehouseCode': fromWarehouseCode,
      'WarehouseCode': warehouseCode,
      'StockTransferLinesBinAllocations': stockTransferLinesBinAllocations.map((allocation) => allocation.toJson()).toList(),
    };
  }

  static StockTransferLine fromJson(Map<String, dynamic> json) {
    return StockTransferLine(
      itemCode: json['ItemCode'],
      quantity: json['Quantity'],
      fromWarehouseCode: json['FromWarehouseCode'],
      warehouseCode: json['WarehouseCode'],
      stockTransferLinesBinAllocations: List<StockTransferLineBinAllocation>.from(
        json['StockTransferLinesBinAllocations'].map((allocation) => StockTransferLineBinAllocation.fromJson(allocation)),
      ),
    );
  }
}
class StockTransferLineBinAllocation {
  final int binActionType;
  final String binAbsEntry;
  final double quantity;

  StockTransferLineBinAllocation({
    required this.binActionType,
    required this.binAbsEntry,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'BinActionType': binActionType,
      'BinAbsEntry': binAbsEntry,
      'Quantity': quantity,
    };
  }

  static StockTransferLineBinAllocation fromJson(Map<String, dynamic> json) {
    return StockTransferLineBinAllocation(
      binActionType: json['BinActionType'],
      binAbsEntry: json['BinAbsEntry'],
      quantity: json['Quantity'],
    );
  }
}

