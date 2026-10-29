import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:sap/core/error/failure.dart';
import 'package:sap/features/mfgorder/data/datasource/mfgorder_datasource_repository.dart';
import 'package:sap/features/mfgorder/data/model/get_mfgorder_model.dart';
import 'package:get/get.dart';
import '../model/mfgorder_details_model.dart';

class MfgOrderDataSourceImpl implements MfgOrderSourceRepository {
  @override
  Future<Either<Failure, List<MfgOrderModel>>> fetchMfgOrder() async {
    try {
      print('Fetching stock data for MfgOrder');
      final response = await http.get(Uri.parse(
          "http://183.82.2.246:8000/EPEQRCODESCAN_TRP/XSJS/GetWorkOrderMFG.xsjs"));
      print('Response received for bin name fetch request');
      print(response.body);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        List<MfgOrderModel> stockReports = jsonResponse.values.map((item) => MfgOrderModel.fromJson(item)).toList();
        return Right(stockReports);
      } else {
        return Left(Failure(statusCode: response.statusCode, message: 'Failed to fetch data!'));
      }
    } catch (err) {
      return Left(Failure(statusCode: 500, message: 'Error occurred!'));
    }
  }

  @override
  Future<Either<Failure, List<MfgDetailsModel>>> fetchMfgDetails(int DocEntry,  bincode) async {
    try {
      print('Fetching Mfgorder details$DocEntry,$bincode');
      final response = await http.get(Uri.parse(
          "http://183.82.2.246:8000/EPEQRCODESCAN_TRP/XSJS/GetWorkOrderDetailsMFG.xsjs?DocEntry=$DocEntry&Bincode=$bincode"));
      print(' from mfgorder details');
      print(response);
      print(response);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        List<MfgDetailsModel> stockDetails = jsonResponse.values.map((item) => MfgDetailsModel.fromJson(item)).toList();
        return Right(stockDetails);
      } else {
        return Left(Failure(statusCode: response.statusCode, message: 'Failed to fetch data!'));
      }
    } catch (err) {
      return Left(Failure(statusCode: 500, message: 'Error occurred!'));
    }
  }
}
