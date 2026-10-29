import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:sap/API/URLConst.dart';
import 'package:sap/core/error/failure.dart';
import 'package:sap/features/homeScreen/data/datasource/bin_datasource_repository.dart';
import 'package:sap/features/homeScreen/data/model/get_bin_model.dart';
import 'package:get/get.dart';
class BinNameDataSourceImpl implements BinNameSourceRepository {
  @override
  Future<Either<Failure, BinNameModel>> fetchbinName(String warehouse, String binCode) async {
    try {
      print('Fetching bin name for Warehouse: $warehouse, BinCode: $binCode');


      final response = await http.get(Uri.parse("http://183.82.2.246:8000/EPEQRCODESCAN_TRP/XSJS/Get_Stockreport.xsjs?WHSCode=$warehouse&BinLocationCode=$binCode&page_type=GetStockBinCodeName"));

      print('Response received for bin name fetch request.');

    //  print(response);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        print('Response bin data: $data');
        BinNameModel name = BinNameModel.fromJson(data);
        return Right(name);
      } else {
        return Left(Failure(statusCode: response.statusCode, message: 'Failed to fetch bin Name!'));
      }
    } catch (err) {
      return Left(Failure(statusCode: 500, message: 'Error occurred!'));
    }
  }
}
