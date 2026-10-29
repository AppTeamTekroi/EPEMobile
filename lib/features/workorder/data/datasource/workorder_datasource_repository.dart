import 'package:dartz/dartz.dart';
import 'package:sap/core/error/failure.dart';
import 'package:sap/features/workorder/data/model/get_workorderView_model.dart';
import 'package:sap/features/workorder/data/model/get_workorder_model.dart';

abstract class WorkOrderSourceRepository {
  Future<Either<Failure, List<WorkOrderModel>>> getworkorder();
  Future<Either<Failure, List<WorkOrderView>>> getworkorderView(int DocEntry, String bincode);
}
