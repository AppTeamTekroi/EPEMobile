import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:sap/core/error/failure.dart';
import 'package:sap/features/stockreport/data/datasource/stock_report_datasource_repository.dart';
import 'package:sap/features/stockreport/data/model/get_stockreport_model.dart';
import 'package:sap/features/stockreport/data/model/get_stockdetails_model.dart';

class StockReportDataSourceImpl implements StockReportSourceRepository {
  @override
  Future<Either<Failure, List<StockReportModel>>> fetchStockData(String warehouse, String binCode) async {
    try {
      print('Fetching stock data for warehouse: $warehouse, binCode: $binCode');
      final response = await http.get(Uri.parse(
          "http://183.82.2.246:8000/EPEQRCODESCAN_TRP/XSJS/Get_Stockreport.xsjs?WHSCode=$warehouse&BinLocationCode=$binCode&page_type=GetStockreport"));
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        List<StockReportModel> stockReports = jsonResponse.values.map((item) => StockReportModel.fromJson(item)).toList();
        return Right(stockReports);
      } else {
        return Left(Failure(statusCode: response.statusCode, message: 'Failed to fetch data!'));
      }
    } catch (err) {
      return Left(Failure(statusCode: 500, message: 'Error occurred!'));
    }
  }

  @override
  Future<Either<Failure, List<StockDetailsModel>>> fetchStockDetails(String itemcode, String fromdate, String todate) async {
    try {
      print('Fetching stock details for item code: $itemcode, from date: $fromdate, to date: $todate');
      final response = await http.get(Uri.parse(
          "http://183.82.2.246:8000/EPEQRCODESCAN_TRP/XSJS/Get_ItemWiseDetails.xsjs?ItemCode=$itemcode&FromDate=$fromdate&ToDate=$todate"));
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
print(' from fetch stock details');
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        List<StockDetailsModel> stockDetails = jsonResponse.values.map((item) => StockDetailsModel.fromJson(item)).toList();
        return Right(stockDetails);
      } else {
        return Left(Failure(statusCode: response.statusCode, message: 'Failed to fetch data!'));
      }
    } catch (err) {
      return Left(Failure(statusCode: 500, message: 'Error occurred!'));
    }
  }
}
