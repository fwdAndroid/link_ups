import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:link_up/get_controller/base_controller.dart';
import 'package:link_up/helper/router/route_path.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  bool _isInAsyncCall = false;
  TextEditingController emailController = new TextEditingController();
  BaseController baseController = Get.find(tag: BaseController().toString());

  final _formKey = GlobalKey<FormState>();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void _sendPasswordResetLink() async {
    await _firebaseAuth
        .sendPasswordResetEmail(email: emailController.text.trim())
        .then((result) {
      setState(() {
        _isInAsyncCall = false;
      });
      baseController.alert1(
          'Password reset link has been successfully sent to your inbox!');
    }).catchError((error) {
      setState(() {
        _isInAsyncCall = false;
      });
      print(error.toString());
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          width: width,
          height: height,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 80,
                ),
                Text(
                  'recovery_password'.tr,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Container(
                  width: width * 0.6,
                  height: height * 0.3,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/image/splash.png'),
                    ),
                  ),
                ),
                Container(
                  width: width * 0.85,
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: EdgeInsets.all(width * 0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              // icon: const Icon(Icons.email),
                              hintText: 'enter_your_email'.tr,
                              labelText: 'email'.tr,
                              contentPadding: EdgeInsets.only(
                                  left: 10.0,
                                  top: 5.0,
                                  right: 10.0,
                                  bottom: 10.0),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue)),
                            ),
                            validator: (value) {
                              if (value == null || value == '') {
                                return 'please_enter_email'.tr;
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'you_will_receive_new_pass'.tr,
                            style: TextStyle(fontSize: 12),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Container(
                              child: SizedBox(
                            width: double.infinity,
                            height: 40,
                            child: RaisedButton(
                              color: Colors.red[700],
                              child: Text(
                                'send_link_to_inbox'.tr,
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _sendPasswordResetLink();
                                  setState(() {
                                    _isInAsyncCall = true;
                                  });
                                }
                              },
                            ),
                          )),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "already_have_an_account".tr,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RoutePath.login_screen);
                                },
                                child: Text(
                                  'log_in'.tr,
                                  style: TextStyle(
                                    color: Colors.red[900],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
