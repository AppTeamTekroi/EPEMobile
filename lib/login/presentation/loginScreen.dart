import 'package:sap/login/controller/login_controller.dart';
import 'package:sap/ui/Buttons/CustomButton.dart';
import 'package:sap/ui/color/appColor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:sap/features/homeScreen/presentation/homeScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginController loginController = Get.put(LoginController(), permanent: true);

  bool showCredentialsText = false;


  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
              colors: [AppColors.primary, AppColors.primary],
            ),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child:

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: height * 0.10,
                ),
                Padding(
                  padding: EdgeInsets.only(left: width * 0.075),
                  child: const Text(
                    "Welcome!",
                    style: TextStyle(
                        fontSize: 40,
                        letterSpacing: 2,
                        color: Colors.black,
                        fontWeight: FontWeight.w900),
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.only(left: width * 0.075),
                //   child: Container(
                //     height: 150,
                //     child: Image(
                //       fit: BoxFit.cover,
                //       image: AssetImage(
                //         'lib/ui/assets/client.png',
                //       ),
                //     ),
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.only(
                      left: width * 0.075,
                      right: width * 0.075,
                      top: width * 0.045,
                      bottom: width * 0.075),
                  child: Container(
                    height: 50,
                    child:const Image(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      'lib/ui/assets/client.png',
                    ),
                  ),
                ),
          ),
                Padding(
                  padding: EdgeInsets.only(
                      left: width * 0.075,
                      right: width * 0.075,
                      top: width * 0.035,
                      bottom: width * 0.075),
                  child: Container(
                    height: height * 0.44,
                    width: width * 0.85,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          const Text('UserName'),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(9)),
                            child: TextFormField(
                              controller: loginController.usernameController,
                              style: TextStyle(
                                // fontFamily: 'REM',
                                fontSize: 20,
                                // fontWeight: FontWeight.w300,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'UserName',
                                hintStyle: TextStyle(
                                    color: Colors.grey.withOpacity(0.8),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                                contentPadding:
                                const EdgeInsets.only(left: 12, top: 7),

                              ),
                              onChanged: (val) {

                                  loginController.UserName.value = val;
                                  },
                            ),
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          const Text('Password'),
                          Obx(
                                () => Container(
                                margin:
                                const EdgeInsets.symmetric(vertical: 10),
                                height: 50,
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(9)),
                                child: TextFormField(
                                  obscureText:
                                  loginController.isPasswordVisible.value,
                                  controller:
                                  loginController.passwordController,
                                  obscuringCharacter: '*',
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Password',
                                    hintStyle: TextStyle(
                                        color: Colors.grey.withOpacity(0.8),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                    contentPadding: const EdgeInsets.only(
                                        left: 12, top: 14),
                                    suffixIcon: GestureDetector(
                                        onTap: () {
                                          loginController
                                              .togglePasswordVisibility();
                                        },
                                        child: loginController
                                            .isPasswordVisible.value
                                            ? const Icon(
                                          Icons.visibility_off,
                                          color: AppColors.mainblue,
                                        )
                                            : const Icon(
                                          Icons.visibility,
                                          color: AppColors.mainblue,
                                        )),
                                  ),
                                  onChanged: (value) {
                                    loginController.Password.value = value;
                                  },
                                )),
                          ),

                      SizedBox(
                            height: height * 0.03,
                          ),
                          Obx(
                                () => Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: Center(
                                child: CustomButton(
                                  title: 'Login',
                                  buttonText: loginController.isLoading.value == true
                                      ? const CircularProgressIndicator(
                                    color: AppColors.white,
                                  )
                                      : const Text(
                                    'Login',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  ),
                                  backgroundColor: AppColors.mainblue,
                                  height: 40,
                                  width: width * 0.9,
                                  borderRadius: 12,
                                  onPressed: () async {
                                    Get.off(() => HomeScreen());


     //                                loginController.usernameController.text.isEmpty ||
     //                                    loginController.passwordController.text.isEmpty
     //                                    ? Container(
     //                                  padding: const EdgeInsets.symmetric(horizontal: 20),
     //                                  child: Text(
     //                                    'Please enter credentials',
     //                                    style: TextStyle(
     //                                      color: Colors.red, // Set text color to red
     //                                      fontSize: 14, // Corrected font size
     //                                    ),
     //                                  ),
     //                                )
     //                                    : SizedBox(); // Placeholder for other widgets
     //
     //                                 if(loginController.usernameController.text.isEmpty) {
     //                                   Fluttertoast.showToast(
     //                                     msg: "enter username",
     //                                     toastLength: Toast.LENGTH_SHORT,
     //                                     gravity: ToastGravity.CENTER,
     //                                     timeInSecForIosWeb: 1,
     //                                     backgroundColor: Colors.red,
     //                                     textColor: Colors.white,
     //                                     fontSize: 16.0,
     //                                   );
     // }
     //
     //                                 if(loginController.passwordController.text.isEmpty) {
     //                                   Fluttertoast.showToast(
     //                                     msg: "Please enter password.",
     //                                     toastLength: Toast.LENGTH_SHORT,
     //                                     gravity: ToastGravity.CENTER,
     //                                     timeInSecForIosWeb: 1,
     //                                     backgroundColor: Colors.red,
     //                                     textColor: Colors.white,
     //                                     fontSize: 16.0,
     //                                   );
     // }
     //                           if(loginController.usernameController.text.isNotEmpty && loginController.passwordController.text.isNotEmpty) {
     //                                   try {
     //                                       final response = await loginController
     //                                           .loginUser();
     //                                       if (response["SessionId"] != null &&
     //                                           response["SessionId"]
     //                                               .isNotEmpty) {
     //                                         final SharedPreferences _prefs =
     //                                         await SharedPreferences
     //                                             .getInstance();
     //                                         _prefs.setString('sessionid',
     //                                          loginController.SessionId);
     //                                         loginController.usernameController
     //                                             .clear();
     //                                         loginController.passwordController
     //                                             .clear();
     //                                         Get.off(() => HomeScreen());
     //                                         return; // Exit the function after successful login
     //                                     } else if(response["error"] != null){
     //                                         QuickAlert.show(
     //                                           context: context,
     //                                           title: 'Failed',
     //                                           type: QuickAlertType.error,
     //                                           text: 'check login credentials',
     //                                         );
     //
     //                                       }
     //                                       else {
     //                                       QuickAlert.show(
     //                                         context: context,
     //                                         title: 'Failed',
     //                                         type: QuickAlertType.error,
     //                                         text: 'server erroe',
     //                                       );
     //                                     }
     //                                   } catch (e) {
     //                                     print('Server error: $e');
     //                                     QuickAlert.show(
     //                                       context: context,
     //                                       title: 'Failed',
     //                                       type: QuickAlertType.error,
     //                                       text: 'Failed to login. Please try again later.',
     //                                     );
     //                                   } finally {
     //                                     loginController.isLoading.value = false;
     //                                   }
     //                                }
     //                                loginController.isLogin.value = false;
                                  },
                                ),
                              ),
                            ),
                          ),


                          Align(
                            alignment: Alignment.bottomRight,
                            child: Image(
                              height: height * 0.05, // Adjust the height of the image
                              image: AssetImage('lib/ui/assets/my.png'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              ],
            ),


          ),
        ),
      ),

    );
  }
}
