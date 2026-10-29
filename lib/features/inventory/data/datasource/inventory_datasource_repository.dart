import 'package:dartz/dartz.dart';
import 'package:sap/features/inventory/data/model/post_inventory_model.dart';

import '../../../../core/enum/post_enum_response.dart';
import '../../../../core/error/failure.dart';

abstract class InventorySourceRepository {
  Future<Either<Failure, dynamic>> postInventoryData(StockTransferModel data);


}
