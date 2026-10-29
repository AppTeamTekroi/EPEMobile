import 'package:dartz/dartz.dart';
import 'package:sap/features/mfgorder/data/model/mfgorder_details_model.dart';
import '../model/get_mfgorder_model.dart';
import '../../../../core/error/failure.dart';


abstract class MfgOrderSourceRepository {
  Future<Either<Failure, List<MfgOrderModel>>> fetchMfgOrder() ;
  Future<Either<Failure, List<MfgDetailsModel>>> fetchMfgDetails(int DocEntry,String bincode);
}
