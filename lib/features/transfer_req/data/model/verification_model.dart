class VerifyModel {
  final int absEntry;
  final String binName;
  final String onHandQty;

  VerifyModel({
    required this.absEntry,
    required this.binName,
    required this.onHandQty,
  });

    factory VerifyModel.fromJson(Map<String, dynamic> json) {
      print(json['BinName']);
    return VerifyModel(
      absEntry: json['AbsEntry'] ?? 0,
      binName: json['BinName'] ?? "",
      onHandQty: json['OnHandQty'] ?? '',
    );
  }
}





