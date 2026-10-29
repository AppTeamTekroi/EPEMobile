import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:sap/core/error/failure.dart';
import 'package:sap/features/workorder/data/datasource/workorder_datasource_repository.dart';
import 'package:sap/features/workorder/data/model/get_workorder_model.dart';
import 'package:sap/features/workorder/data/model/get_workorderView_model.dart';

class WorkOrderDataSourceImpl implements WorkOrderSourceRepository {
  @override

  Future<Either<Failure, List<WorkOrderModel>>> getworkorder() async {
    try {
      final response = await http.get(Uri.parse(
          "http://183.82.2.246:8000/EPEQRCODESCAN_TRP/XSJS/GetWorkOrder.xsjs"));
      print('Response status code: ${response.statusCode}');
       print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        List<WorkOrderModel> workOrders = jsonResponse.values.map((item) => WorkOrderModel.fromJson(item)).toList();
        return Right(workOrders);
      } else {
        print('failed');
        return Left(Failure(
            statusCode: response.statusCode, message: 'Failed to fetch data!'));
      }
    } catch (err) {
      print('$err');

      return Left(Failure(statusCode: 500, message: 'Error occurred!'));
    }
  }

  @override
  Future<Either<Failure, List<WorkOrderView>>> getworkorderView(int DocEntry, String bincode) async {
    try {
      print('Fetching workorder for warehouse: $DocEntry,$bincode');
      final response = await http.get(Uri.parse(
          "http://183.82.2.246:8000/EPEQRCODESCAN_TRP/XSJS/GetWorkOrderDetails.xsjs?DocEntry=$DocEntry&Bincode=$bincode"));
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        List<WorkOrderView> workOrdersview = jsonResponse.values.map((item) => WorkOrderView.fromJson(item)).toList();
        return Right(workOrdersview);
      } else {
        return Left(Failure(
            statusCode: response.statusCode, message: 'Failed to fetch data!'));
      }
    } catch (err) {
      return Left(Failure(statusCode: 500, message: 'Error occurred!'));
    }
  }
}
