import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../datasource/post_datasource_repository.dart';
import '../model/post_workorder_model.dart';
import '../model/post_receipt_model.dart';
import '../../../../core/error/failure.dart';
import 'package:sap/API/URLConst.dart';
import '../model/post_workorderneg_model.dart';
class PostDataSourceImpl implements PostSourceRepository {
  @override
  Future<Either<Failure, dynamic>> postData(PostIssueModel data) async {
    try {
      final List<Map<String, dynamic>> jsonData = data.documentLines.map((line) => line.toJson()).toList();
      final String jsonString = jsonEncode({
        "DocumentLines": jsonData,
      });

      print('Body: $jsonString');
      var response = await http.post(
         Uri.parse(URLConst.issueforproduction),
         body: jsonString,
         headers: {'Content-Type': 'application/json'},
       );

      print('Post response ${response.body}');

      if (response.statusCode == 200) {
        final dynamic responseData = jsonDecode(response.body);
        return Right(responseData); // Return successful response wrapped in Right
      } else {
        // Handle failure case
        return Left(Failure(statusCode: response.statusCode, message: 'Failed to post issue production'));
      }
    } catch (e) {
      // Catch any exceptions and rethrow
      print('Exception: $e');
      return Left(Failure(statusCode: 500, message: 'Failed to post issue production: $e'));
    }
  }


  @override
  Future<Either<Failure, dynamic>> postReceiptData(PostReceiptModel data) async {
    try {
      final List<Map<String, dynamic>> jsonData = data.documentLines.map((line) => line.toJson()).toList();
      final String jsonString = jsonEncode({
        "DocumentLines": jsonData,
      });
      print('Body: $jsonString');

      var response = await http.post(
        Uri.parse(URLConst.receipt),
        body: jsonString,
        headers: {'Content-Type': 'application/json'},
      );

      print('Post receipt response ${response.body}');

      if (response.statusCode == 200) {
       // final dynamic responseData = "success";
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Right(jsonResponse);
       // return Right(response);
      } else {
        // Handle failure case
        return Left(Failure(statusCode: response.statusCode, message: 'Failed to post receipt'));
      }
    } catch (e) {
      // Catch any exceptions and rethrow
      print('Exception: $e');
      return Left(Failure(statusCode: 500, message: 'Failed to post report: $e'));
    }
  }


  @override
  Future<Either<Failure, Map<String, dynamic>>> postWorkNEGData(WorkOrderNeGModel data) async {
    try {
      final Map<String, dynamic> jsonData = data.toJson();
      final String jsonString = jsonEncode(jsonData);

      print('Body: $jsonString');
      var response = await http.post(
        Uri.parse(URLConst.requiredissueproduction),
        body: jsonString,
        headers: {'Content-Type': 'application/json'},
      );

      print('post response ${response.body}');

      if (response.statusCode == 200) {
        final dynamic responseData = jsonDecode(response.body);
        return Right(responseData);
      } else {
        // Handle failure case
        return Left(Failure(statusCode: response.statusCode, message: 'Failed to post neg  data'));
      }
    } catch (e) {
      // Catch any exceptions and rethrow
      print('Exception: $e');
      return Left(Failure(statusCode: 500, message: 'Failed to required workorder components: $e'));
    }
  }



}
