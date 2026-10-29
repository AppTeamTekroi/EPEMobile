import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sap/login/presentation/loginScreen.dart';
import 'package:sap/features/homeScreen/presentation/homeScreen.dart';
import 'package:sap/login/controller/login_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _checkLoginStatus() async {
    final LoginController loginController = Get.put(LoginController());
    await loginController.loadLoginState();
    return loginController.isLogin.value;
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ERP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder<bool>(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()), // Show a loading indicator while waiting
            );
          } else {
            if (snapshot.hasData && snapshot.data == true) {
              return const HomeScreen(); // Redirect to HomeScreen if logged in
            } else {
              return const LoginScreen(); // Redirect to LoginScreen if not logged in
            }
          }
        },
      ),
    );
  }
}
