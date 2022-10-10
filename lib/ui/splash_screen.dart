import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:link_up/get_controller/auth_controller.dart';
import 'package:link_up/helper/router/route_path.dart';
import 'package:link_up/introscreens/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AuthController authController = Get.find(tag: AuthController().toString());

  checkAuth(BuildContext context) async {
    var _shared = await SharedPreferences.getInstance();
    String? _id = _shared.getString('user_id');
    if (_id != null && _id != '') {
      String id = _id;
      authController.getUser(id, context).then((value) {
        Navigator.pushNamed(context, RoutePath.home_screen);
      });
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (builder) => Welcome()));
    }
  }

  @override
  void initState() {
    checkAuth(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder(
          init: authController,
          builder: (_) {
            return Container(
              width: width,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/asd.png',
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fill,
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
