import 'package:dartz/dartz.dart';
import '../model/post_workorder_model.dart';
import '../model/post_receipt_model.dart';
import '../../../../core/error/failure.dart';
import '../model/post_workorderneg_model.dart';
abstract class PostSourceRepository {
  Future<Either<Failure, dynamic>> postData(PostIssueModel data);
  Future<Either<Failure, dynamic>> postReceiptData(PostReceiptModel data);
  Future<Either<Failure, dynamic>> postWorkNEGData(WorkOrderNeGModel data);

  }
