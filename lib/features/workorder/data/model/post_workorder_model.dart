// post_workorder_model.dart

class PostIssueModel {
  final List<DocumentLine> documentLines;

  PostIssueModel({required this.documentLines});

  Map<String, dynamic> toJson() {
    return {
      'DocumentLines': documentLines.map((line) => line.toJson()).toList(),
    };
  }
}

class DocumentLine {
  final String baseType;
  final int baseEntry;
  final int baseLine;
  final List<DocumentLinesBinAllocation> documentLinesBinAllocations;

  DocumentLine({
    required this.baseType,
    required this.baseEntry,
    required this.baseLine,
    required this.documentLinesBinAllocations,
  });

  Map<String, dynamic> toJson() {
    return {
      'BaseType': baseType,
      'BaseEntry': baseEntry,
      'BaseLine': baseLine,
      'DocumentLinesBinAllocations': documentLinesBinAllocations
          .map((allocation) => allocation.toJson())
          .toList(),
    };
  }
}

class DocumentLinesBinAllocation {
  final int binAbsEntry;
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
