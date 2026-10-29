import 'package:dartz/dartz.dart';
import '../model/transfer_model.dart';
import '../../../../core/error/failure.dart';

abstract class TransferSourceRepository {
  Future<Either<Failure, List<TransferModel>>> fetchTransfer() ;
}
