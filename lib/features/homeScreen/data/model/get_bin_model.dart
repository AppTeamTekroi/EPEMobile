class BinNameModel {
  final String BinName;


  BinNameModel({
    required this.BinName,

  });

  factory BinNameModel.fromJson(Map<String, dynamic> json) {
    print('ederagtehteghyjyj');
    print(json['BinName']);
    return BinNameModel(
      BinName: json['BinName'],

    );
  }
}
