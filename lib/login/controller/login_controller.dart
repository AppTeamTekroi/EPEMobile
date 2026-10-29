import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sap/features/auth_service/auth_service.dart';
import 'package:sap/login/presentation/loginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sap/features/homeScreen/presentation/homeScreen.dart';


class LoginController extends GetxController {
  final AuthService authService = AuthService();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  var otpVisibility = false.obs;
  var isPasswordVisible = true.obs;
  var Password = "".obs;
  var isLoading = false.obs;
  var isLogin = false.obs;
  var UserName = "".obs;
  var SessionId = "";

  void togglePasswordVisibility() {
    isPasswordVisible.toggle();
  }

  @override
  void onInit() {
    super.onInit();
    loadLoginState();
  }

  Future<dynamic> loadLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    isLogin.value = prefs.getBool('isLogin') ?? false;
    SessionId = prefs.getString('sessionid') ?? '';

  }

  Future<dynamic> loginUser() async {
    final String UserName = usernameController.text;
    final String Password = passwordController.text;
    try {
      isLoading.value = true;
      // Call login method from AuthService
      var response = await authService.login(
        UserName,
        Password,
      );
      var responseData;
      response.fold(
            (failure) {
          responseData .clear();
          print('Failure in transfer stocks : ${failure.message}');
          responseData = 'Failure in transfer tocks: ${failure.message}';
        },
            (res) => responseData = res,
      );

      if (responseData["SessionId"] != null && responseData["SessionId"].isNotEmpty) {
        SessionId = responseData["SessionId"];
        isLogin.value = true;
        saveLoginState();
        Get.to(() => const HomeScreen());
      } else {
        isLogin.value = false;
        saveLoginState();
      }

      return responseData;
    } catch (e) {
      print('Exception: $e');
      throw Exception('Failed to login: $e');
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> logOutUser() async {
    isLogin.value = false;
    SessionId = '';
    await saveLoginState();
    Get.off(() => const LoginScreen());
  }

  Future<void> saveLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLogin', isLogin.value);
    prefs.setString('sessionid', SessionId);
  }
}