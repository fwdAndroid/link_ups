import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:link_up/get_controller/auth_controller.dart';
import 'package:link_up/helper/router/route_path.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:share_plus/share_plus.dart';

class DrawerScreen extends StatefulWidget {
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  AuthController authController = Get.find(tag: AuthController().toString());

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  Future _signOutConfirmDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.black,
            title: Text(
              'confirm_logout'.tr,
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'are_you_sure_logout'.tr,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Row(
                      children: [
                        Container(
                          width: 100,
                          height: 40,
                          child: RaisedButton(
                            child: Text(
                              "no".tr,
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide(color: Colors.white)),
                            color: Colors.black,
                            padding: EdgeInsets.all(8.0),
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Container(
                          width: 100,
                          height: 40,
                          child: RaisedButton(
                            child: Text(
                              "yes".tr,
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            onPressed: () {
                              WidgetsBinding.instance
                                  .addPostFrameCallback((timeStamp) {
                                authController.signOut(context);
                              });
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide(color: Colors.white)),
                            color: Colors.red[900],
                            padding: EdgeInsets.all(8.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
  }

  RateMyApp rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    minDays: 7,
    minLaunches: 10,
    remindDays: 7,
    remindLaunches: 10,
    googlePlayIdentifier: 'fr.skyost.example',
    appStoreIdentifier: '1491556149',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder(
          init: authController,
          builder: (_) {
            return ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            "assets/dra.png",
                          ),
                          fit: BoxFit.cover)),
                  accountName: Text(
                    (authController.user?.value.firstName ?? '') +
                        ' ' +
                        (authController.user?.value.lastName ?? ''),
                  ),
                  accountEmail: Text(authController.user!.value.email),
                  currentAccountPicture: GestureDetector(
                    onTap: () {
                      Navigator.popAndPushNamed(
                          context, RoutePath.profile_page);
                    },
                    child: (authController.user!.value.avatar != '' &&
                            authController.user?.value.avatar != null)
                        ? CircleAvatar(
                            backgroundColor: Colors.orange,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(
                                  authController.user!.value.avatar,
                                  scale: 1.0),
                            ),
                          )
                        : CircleAvatar(
                            backgroundColor: Colors.orange,
                            child: Text(
                              authController.user!.value.firstName,
                              style: TextStyle(fontSize: 30.0),
                            ),
                          ),
                  ),
                ),
                ListTile(
                  leading: Image.asset(
                    "assets/home.png",
                    height: 20,
                    width: 20,
                  ),
                  title: Text("home".tr),
                  onTap: () {
                    Navigator.popAndPushNamed(context, RoutePath.home_screen);
                  },
                  // trailing: Icon(
                  //   Icons.arrow_forward,
                  //   color: Colors.black,
                  //   size: 20,
                  // ),
                ),
                ListTile(
                  leading: Image.asset(
                    "assets/discuss-issue.png",
                    height: 20,
                    width: 20,
                  ),
                  title: Text("chat_now".tr),
                  onTap: () {
                    Navigator.popAndPushNamed(
                        context, RoutePath.chat_home_page);
                  },
                  // trailing: Icon(
                  //                 Icons.arrow_forward,
                  //              color: Colors.black,
                  //           size: 20,
                  //      ),
                ),
                ListTile(
                  leading: Image.asset(
                    "assets/advice.png",
                    height: 20,
                    width: 20,
                  ),
                  title: Text("subscription".tr),
                  onTap: () {
                    Navigator.popAndPushNamed(
                        context, RoutePath.subscription_page_one);
                  },
                  // trailing: Icon(
                  //                 Icons.arrow_forward,
                  //              color: Colors.black,
                  //           size: 20,
                  //      ),
                ),
                ListTile(
                  leading: Image.asset(
                    "assets/promotion(1).png",
                    height: 20,
                    width: 20,
                  ),
                  title: Text("push_notification".tr),
                  onTap: () {
                    Navigator.popAndPushNamed(
                        context, RoutePath.notification_page);
                  },
                  // trailing: Icon(
                  //                 Icons.arrow_forward,
                  //              color: Colors.black,
                  //           size: 20,
                  //      ),
                ),
                ListTile(
                   leading: Image.asset(
                    "assets/paper.png",
                    height: 20,
                    width: 20,
                  ),
                  title: Text("legal_support".tr),
                  onTap: () {
                    Navigator.pushNamed(context, RoutePath.legal_and_support);
                    // Navigator.pop(context);
                  },
                  // trailing: Icon(
                  //                 Icons.arrow_forward,
                  //              color: Colors.black,
                  //           size: 20,
                  //      ),
                ),
                ListTile(
                  leading: Image.asset(
                    "assets/control-center.png",
                    height: 20,
                    width: 20,
                  ),
                  title: Text("settings".tr),
                  onTap: () {
                    Navigator.popAndPushNamed(
                        context, RoutePath.setting_screen);
                  },
                  // trailing: Icon(
                  //                 Icons.arrow_forward,
                  //              color: Colors.black,
                  //           size: 20,
                  //      ),
                ),
                ListTile(
                   leading: Image.asset(
                    "assets/share.png",
                    height: 20,
                    width: 20,
                  ),
                  title: Text("share".tr),
                  onTap: () {
                    Share.share(
                        "https://play.google.com/store/apps/details?id=com.bluskies.linkUp");
                  },
                  // trailing: Icon(
                  //                 Icons.arrow_forward,
                  //              color: Colors.black,
                  //           size: 20,
                  //      ),
                ),
                ListTile(
                   leading: Image.asset(
                    "assets/advice.png",
                    height: 20,
                    width: 20,
                  ),
                  title: Text("rate_this_app".tr),
                  onTap: () {
                    rateMyApp.showRateDialog(
                      context,
                      title: 'rate_this_app'.tr, // The dialog title.
                      message: 'rate_app_description'.tr, // The dialog message.
                      rateButton: 'rate'.tr, // The dialog "rate" button text.
                      noButton: 'no_thanks'.tr, // The dialog "no" button text.
                      laterButton:
                          'maybe_later', // The dialog "later" button text.
                      listener: (button) {
                        // The button click listener (useful if you want to cancel the click event).
                        switch (button) {
                          case RateMyAppDialogButton.rate:
                            print('Clicked on "Rate".');
                            break;
                          case RateMyAppDialogButton.later:
                            print('Clicked on "Later".');
                            break;
                          case RateMyAppDialogButton.no:
                            print('Clicked on "No".');
                            break;
                        }

                        return true; // Return false if you want to cancel the click event.
                      },
                      ignoreNativeDialog:
                          true, // Set to false if you want to show the Apple's native app rating dialog on iOS or Google's native app rating dialog (depends on the current Platform).
                      dialogStyle: const DialogStyle(), // Custom dialog styles.
                      onDismissed: () => rateMyApp
                          .callEvent(RateMyAppEventType.laterButtonPressed),
                      // Called when the user dismissed the dialog (either by taping outside or by pressing the "back" button).
                      // contentBuilder: (context, defaultContent) => content, // This one allows you to change the default dialog content.
                      // actionsBuilder: (context) => [], // This one allows you to use your own buttons.
                    );
                  },
                  // trailing: Icon(
                  //                 Icons.arrow_forward,
                  //              color: Colors.black,
                  //           size: 20,
                  //      ),
                ),
                ListTile(
                  leading: Image.asset(
                    "assets/log-out.png",
                    height: 20,
                    width: 20,
                  ),
                  title: Text("log_out".tr),
                  onTap: () {
                    _signOutConfirmDialog(context);
                  },
                  // trailing: Icon(
                  //                 Icons.arrow_forward,
                  //              color: Colors.black,
                  //           size: 20,
                  //      ),
                ),
              ],
            );
          }),
    );
  }
}
