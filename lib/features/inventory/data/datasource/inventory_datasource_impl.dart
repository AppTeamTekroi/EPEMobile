import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:sap/API/URLConst.dart';
import 'package:get/get.dart';
import 'package:sap/core/enum/post_enum_response.dart';
import 'package:sap/core/error/failure.dart';
import 'package:sap/features/inventory/data/datasource/inventory_datasource_repository.dart';
import 'package:sap/features/inventory/data/model/post_inventory_model.dart';

class InventoryDataSourceImpl implements InventorySourceRepository {
  @override
  Future<Either<Failure, Map<String, dynamic>>> postInventoryData(StockTransferModel data) async {
    try {
      final Map<String, dynamic> jsonData = data.toJson();
      final String jsonString = jsonEncode(jsonData);

      print('Body: $jsonString');
      var response = await http.post(Uri.parse(URLConst.postInventoryURL),
        body: jsonString,
        headers: {'Content-Type': 'application/json'},
      );

      print('post response ${response.body}');

      if (response.statusCode == 200) {
        final dynamic responseData = jsonDecode(response.body);
        return Right(responseData);
      } else {
        // Handle failure case
        return Left(Failure(statusCode: response.statusCode, message: 'Failed to post inventory data'));
      }
    } catch (e) {
      // Catch any exceptions and rethrow
      print('Exception: $e');
      return Left(Failure(statusCode: 500, message: 'Failed to transfer stock: $e'));
    }
  }
}
