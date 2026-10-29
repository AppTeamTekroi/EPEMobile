import 'package:dartz/dartz.dart';
import 'package:sap/features/homeScreen/data/model/get_bin_model.dart';
import '../../../../core/error/failure.dart';

abstract class BinNameSourceRepository {
  Future<Either<Failure, BinNameModel>> fetchbinName(String warehouse, String binCode);
}
