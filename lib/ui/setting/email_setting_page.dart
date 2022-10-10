import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:link_up/get_controller/auth_controller.dart';

class EmailSettingPage extends StatefulWidget {
  @override
  _EmailSettingPageState createState() => _EmailSettingPageState();
}

class _EmailSettingPageState extends State<EmailSettingPage> {
  AuthController authController = Get.find(tag: AuthController().toString());

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GetBuilder(
        init: authController,
        builder: (_) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.green.shade900,
              centerTitle: true,
              title: Text(
                'email_settings'.tr,
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                ),
              ),
              elevation: 10,
            ),
            body: Container(
                color: Colors.grey[200],
                width: width,
                height: height,
                padding: EdgeInsets.symmetric(vertical: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'email'.tr.toUpperCase(),
                          style: TextStyle(fontSize: 18, color: Colors.black45),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                authController.user!.value.email,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Icon(
                                Icons.check,
                                color: Colors.blue,
                                size: 30,
                              )
                            ],
                          )),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          'your_email_is_verified'.tr,
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: width,
                        color: Colors.white,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          'send_email_verification'.tr,
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black45,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 190,
                        child: ListView(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.black26, width: 0.5))),
                              child: ListTile(
                                title: Text(
                                  'new_matches'.tr,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                trailing: Container(
                                  height: 40,
                                  width: 75,
                                  padding:
                                      EdgeInsets.only(left: 10.0, top: 10.0),
                                  child: Switch(
                                    value: authController
                                        .newMatchesNotification.value,
                                    activeColor: Colors.red,
                                    onChanged: (value) {
                                      authController
                                          .updateNewMatchesNotification(value);
                                      authController.updateProfile(
                                          context: context);
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.black26, width: 0.5))),
                              child: ListTile(
                                title: Text(
                                  'messages'.tr,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                trailing: Container(
                                  height: 40,
                                  width: 75,
                                  padding:
                                      EdgeInsets.only(left: 10.0, top: 10.0),
                                  child: Switch(
                                    value: authController
                                        .newMessageNotification.value,
                                    activeColor: Colors.red,
                                    onChanged: (value) {
                                      authController
                                          .updateMessageNotification(value);
                                      authController.updateProfile(
                                          context: context);
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.black26, width: 0.5))),
                              child: ListTile(
                                title: Text(
                                  'promotions'.tr,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text('i_want_receive_updates'.tr),
                                trailing: Container(
                                  height: 40,
                                  width: 75,
                                  padding:
                                      EdgeInsets.only(left: 10.0, top: 10.0),
                                  child: Switch(
                                    value: authController
                                        .promotionNotification.value,
                                    activeColor: Colors.red,
                                    onChanged: (value) {
                                      authController
                                          .updatePromotionNotification(value);
                                      authController.updateProfile(
                                          context: context);
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'you_can_unsubscribe'.tr,
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    ],
                  ),
                )),
          );
        });
  }
}
