import 'package:dartz/dartz.dart';
import 'package:sap/core/error/failure.dart';
import 'package:sap/features/stockreport/data/model/get_stockreport_model.dart';
import 'package:sap/features/stockreport/data/model/get_stockdetails_model.dart';

abstract class StockReportSourceRepository {
  Future<Either<Failure, List<StockReportModel>>> fetchStockData(String warehouse, String binCode);
  Future<Either<Failure, List<StockDetailsModel>>> fetchStockDetails(String itemcode, String fromdate, String todate);
}
