class PostReceiptModel {
  final List<DocumentLine> documentLines;

  PostReceiptModel({required this.documentLines});

  Map<String, dynamic> toJson() {
    return {
      'DocumentLines': documentLines.map((line) => line.toJson()).toList(),
    };
  }
}

class DocumentLine {

  final int baseType;
  final int baseEntry;
  final double quantity;
  final List<DocumentLinesBinAllocation> documentLinesBinAllocations;

  DocumentLine({
    required this.baseType,
    required this.baseEntry,
    required this.quantity,
    required this.documentLinesBinAllocations,
  });

  Map<String, dynamic> toJson() {
    return {
      'BaseType': baseType,
      'BaseEntry': baseEntry,
      'Quantity': quantity,

      'DocumentLinesBinAllocations': documentLinesBinAllocations.map((allocation) => allocation.toJson()).toList(),
    };
  }
}

class DocumentLinesBinAllocation {
  final String binAbsEntry;
  final double quantity;

  DocumentLinesBinAllocation({
    required this.binAbsEntry,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'BinAbsEntry': binAbsEntry,
      'Quantity': quantity,
    };
  }
}
