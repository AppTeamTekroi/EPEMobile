import 'package:dartz/dartz.dart';
import '../model/warehouse_model.dart';
import '../../../../core/error/failure.dart';
import '../model/transfer_model.dart';
import'../model/verification_model.dart';
import'../model/transferreq_details_model.dart';
abstract class WarehouseSourceRepository {
  Future<Either<Failure, List<WarehouseModel>>> fetchwarehouse() ;
  Future<Either<Failure, List<TransferModel>>> fetchtransfer();
  Future<Either<Failure, List<VerifyModel>>> fetchbinverify(int bin, int whs, String itemcode);
  Future<Either<Failure, List<Transferreqdetails>>> transferreqdetails(int DocEntry);

  }
