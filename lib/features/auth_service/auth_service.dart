import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sap/core/error/failure.dart';

import '../../API/URLConst.dart';

class AuthService {
  Future<Either<Failure, Map<String, dynamic>>> login(
      String UserName, String Password) async {


  print(UserName);
    print(Password);
    try {
      final url = Uri.parse(URLConst.loginURL);
      print('$UserName,$Password,rajhckvafetr loginnnnn');
      final Map<String, dynamic> requestBody = {
        'UserName': UserName,
        'Password': Password,
      };
      print(requestBody);

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );
      print("response in auth");
      print('post response ${response.body}');

      if (response.statusCode == 200) {
        final dynamic responseData = jsonDecode(response.body);
        return Right(responseData); // Return successful response wrapped in Right
      } else {
        // Handle failure case
        return Left(Failure(
            statusCode: response.statusCode,
            message: 'Failed to post inventory data'));
      }
    } catch (e) {
      // Catch any exceptions and rethrow
      print('Exception: $e');
      return Left(Failure(
          statusCode: 500, message: 'Failed to transfer stock: $e'));
    }
  }
}
