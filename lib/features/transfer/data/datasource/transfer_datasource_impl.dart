import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:sap/API/URLConst.dart';
import 'package:sap/core/error/failure.dart';
import '../datasource/transfer_datasource_repository.dart';
import '../model/transfer_model.dart';
import 'package:get/get.dart';
class TransferDataSourceImpl implements TransferSourceRepository {
  @override
  Future<Either<Failure, List<TransferModel>>> fetchTransfer() async {
    print('hitting transfer');
    try {
      final response = await http.get(Uri.parse("http://183.82.2.246:8000/EPEQRCODESCAN_TRP/XSJS/GetStockTransfer.xsjs"));
      print(" tansfer details body${response.body}");
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        List<TransferModel> Transfer = jsonResponse.values.map((item) => TransferModel.fromJson(item)).toList();
        return Right(Transfer);
      } else {
        print('issue in transfer');

        return Left(Failure(statusCode: response.statusCode, message: 'Failed to fetch data!'));
      }
    } catch (err) {
      print(err);
      return Left(Failure(statusCode: 500, message: 'Error occurred!'));
    }
  }
}
