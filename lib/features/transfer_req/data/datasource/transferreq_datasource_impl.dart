import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:sap/API/URLConst.dart';
import 'package:sap/core/error/failure.dart';
import '../datasource/transferreq_datasource_repository.dart';
import '../model/warehouse_model.dart';
import 'package:get/get.dart';
import '../model/transfer_model.dart';
import '../model/verification_model.dart';
import '../model/transferreq_details_model.dart';
class WarehouseDataSourceImpl implements WarehouseSourceRepository {
  @override
  Future<Either<Failure, List<WarehouseModel>>> fetchwarehouse() async {
    try {
      print('Fetching bin name for Warehouse:');
      final response = await http.get(Uri.parse(
          "http://183.82.2.246:8000/EPEQRCODESCAN_TRP/XSJS/GetWarehouses.xsjs"));
      print('Response received for bin name fetch request.');

      //  print(response);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        List<WarehouseModel> stockReports = jsonResponse.values.map((item) =>
            WarehouseModel.fromJson(item)).toList();
        return Right(stockReports);
      } else {
        return Left(Failure(
            statusCode: response.statusCode, message: 'Failed to fetch data!'));
      }
    } catch (err) {
      return Left(Failure(statusCode: 500, message: 'Error occurred!'));
    }
  }

  @override
  Future<Either<Failure, List<TransferModel>>> fetchtransfer() async {
    try {
      final response = await http.get(Uri.parse(
          "http://183.82.2.246:8000/EPEQRCODESCAN_TRP/XSJS/GetSTockTransferRequest.xsjs"));
      print('Response status code: ${response.statusCode}');
      print('Response transfer body: ${response.body}');
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        List<TransferModel> workOrders = jsonResponse.values.map((item) =>
            TransferModel.fromJson(item)).toList();
        return Right(workOrders);
      } else {
        return Left(Failure(
            statusCode: response.statusCode,
            message: 'Failed to fetch transfer!'));
      }
    } catch (err) {
      return Left(Failure(statusCode: 500, message: 'Error occurred!'));
    }
  }


  @override
  Future<Either<Failure, List<Transferreqdetails>>> transferreqdetails(int DocEntry) async {
    try {
      print('Fetching transferreq details : $DocEntry,');
      final response = await http.get(Uri.parse(
        "http://183.82.2.246:8000/EPEQRCODESCAN_TRP/XSJS/GetStockTransferDetails.xsjs?DocEntry=$DocEntry"));
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        List<Transferreqdetails> workOrdersview = jsonResponse.values.map((item) => Transferreqdetails.fromJson(item)).toList();
        print('transfer details success');
        return Right(workOrdersview);
      } else {
        return Left(Failure(
            statusCode: response.statusCode, message: 'Failed to fetch data!'));
      }
    } catch (err) {
      return Left(Failure(statusCode: 500, message: 'Error occurred!'));
    }
  }



  @override
  Future<Either<Failure, List<VerifyModel>>> fetchbinverify(int bin, int whs, String itemcode) async {
    print("=$bin&WHSCode=$whs&ItemCode=$itemcode");
    try {
      final response = await http.get(Uri.parse(
          "http://183.82.2.246:8000/EPEQRCODESCAN_TRP/XSJS/GetBinQtyCompare.xsjs?WHSCode=$whs&ItemCode=$itemcode"));
      print('Response Verify body: ${response.body}');
      if (response.statusCode == 200) {
        print('verification success');
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        List<VerifyModel> details = jsonResponse.values.map((item) =>
            VerifyModel.fromJson(item)).toList();
        return Right(details);
      } else {
        return Left(Failure(
            statusCode: response.statusCode,
            message: 'Failed to fetch transfer!'));
      }
    } catch (err) {
      return Left(Failure(statusCode: 500, message: 'Error occurred!'));
    }
  }
}
