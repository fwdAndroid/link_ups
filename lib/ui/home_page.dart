import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:link_up/get_controller/ChatController.dart';
import 'package:link_up/get_controller/auth_controller.dart';
import 'package:link_up/get_controller/home_controller.dart';
import 'package:link_up/helper/app_constant.dart';
import 'package:link_up/helper/drawer_manager.dart';
import 'package:link_up/helper/router/route_path.dart';
import 'package:link_up/model/user_model.dart';
import 'package:link_up/package/swipe_card_stack.dart';
import 'package:link_up/ui/DrawerScreen.dart';
import 'package:link_up/helper/app_config.dart' as config;
import 'package:link_up/ui/chat/calling/incomingCall.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  AuthController authController = Get.find(tag: AuthController().toString());
  HomeController homeController = Get.find(tag: HomeController().toString());
  ChatController chatController = Get.find(tag: ChatController().toString());
  AppLifecycleState appLifecycleState = AppLifecycleState.resumed;

  AppLifecycleState get getAppLifecycleState => appLifecycleState;

  String? selectedUserID, _selectAbuse;
  final GlobalKey<SwipeCardStackState> _swipeKey =
      GlobalKey<SwipeCardStackState>();

  var title = "Enter Your Address";
  var isLoading = false;
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> checkToken(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var _userid = pref.getString('user_id');

    if (_userid == null || _userid == '') {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.pushNamed(context, RoutePath.login_screen);
      });
    }
    if (authController.user?.value.uid == null) {
      if (_userid != null && _userid != '') {
        authController.getUser(_userid, context);
      }
    }
  }

  selectAbuse(BuildContext context, UserModel toUser) async {
    await db.collection('flaggedUsers').doc().set({
      'fromId': authController.user!.value.uid,
      'fromFirstName': authController.user!.value.firstName,
      'fromLastName': authController.user!.value.lastName,
      'toId': toUser.uid,
      'toFirstName': toUser.firstName,
      'toLastName': toUser.lastName,
      'message': _selectAbuse,
      'timestamp': Timestamp.now().millisecondsSinceEpoch,
    });
  }

  _selectAbuseDialog(
      BuildContext context, UserModel data, height, width, padding) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState2) {
            return AlertDialog(
              title: Text(
                'choose_cat'.tr,
                textAlign: TextAlign.center,
              ),
              content: Container(
                width: double.maxFinite,
                height: 360,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: config.App(context, height, width,
                          padding.vertical, padding.horizontal)
                      .abuseList
                      .length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 40,
                      child: RadioListTile(
                        title: Text(config.App(context, height, width,
                                padding.vertical, padding.horizontal)
                            .abuseList[index]),
                        value: config.App(context, height, width,
                                padding.vertical, padding.horizontal)
                            .abuseList[index],
                        groupValue: _selectAbuse,
                        onChanged: (value) {
                          setState2(() {
                            _selectAbuse = value.toString();
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('yes'.tr),
                  onPressed: () async {
                    await selectAbuse(context, data);
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text('no'.tr),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
        });
  }

  void gotoPlaceListPage(String title) {
    Navigator.pushNamed(context, RoutePath.place_list_screen,
        arguments: {'title': title});
  }

  void superLike(String friendId) {
    print("Love It");
  }

  void topShelf() {
    authController.alert1('Your profile set as top shelf to this user');
  }

  void _getCurrentUserLocation() async {
    await Geolocator.checkPermission().then((value) {
      if (value == LocationPermission.denied ||
          value == LocationPermission.deniedForever) {
        Geolocator.requestPermission();
      }
    });

    LocationSettings locationSettings =
        LocationSettings(accuracy: LocationAccuracy.best);
    await GeolocatorPlatform.instance
        .getCurrentPosition(locationSettings: locationSettings)
        .then((Position position) async {
      DrawerManager.shared.latitude = position.latitude.toString();
      DrawerManager.shared.longitude = position.longitude.toString();
      setState(() {});
    }).catchError((e) {
      print(e);
    });
  }

  void fetchProfiles() async {
    if (authController.user != null) {
      await homeController.fetchExploreList(
          linkMeWith: authController.user!.value.linkMeWith,
          nationality: authController.user!.value.countryCode.toString(),
          userID: authController.user!.value.uid!);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      appLifecycleState = state;
    });
    print(appLifecycleState);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    checkToken(context);
    fetchProfiles();
    homeController.missedMessage();
    _getCurrentUserLocation();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    homeController.timer?.value.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection('calls')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((e) {
      if (getAppLifecycleState == AppLifecycleState.resumed) {
        print(getAppLifecycleState);
        if (e.data() != null) {
          var jsonObject = e.data()!;
          if (jsonObject['receiver'] ==
                  FirebaseAuth.instance.currentUser!.uid &&
              jsonObject['response'] == 'Awaiting') {
            Map<String, dynamic> callInfo = {
              "channel_id": jsonObject['receiver'],
              "caller_picture": jsonObject['caller_picture'],
              "caller_name": jsonObject['caller_name'],
              "caller_uid": jsonObject['caller_uid'],
              "call_type": jsonObject['call_type'],
              "channel_name": jsonObject['channel_name']
            };
            Get.to(() => Incoming(callInfo));
          }

          // if (jsonObject['caller_uid'] == FirebaseAuth.instance.currentUser!.uid &&
          //     jsonObject['response'] == 'Awaiting') {
          //   Navigator.pushNamed(context, RoutePath.dial_call, arguments: {
          //     'call_type': jsonObject['call_type'],
          //     'channel_id': jsonObject['channel_id'],
          //     'receiver': chatController.endUser,
          //     'receiver_id': jsonObject['receiver']
          //   });
          // }
        }
      }
    });

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final padding = MediaQuery.of(context).padding;
    return GetBuilder(
      init: authController,
      builder: (_) {
        if (authController.user?.value == null) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          return Stack(
            children: [
              WillPopScope(
                onWillPop: () async => false,
                child: Scaffold(
                  appBar: AppBar(
                    elevation: 0,
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset("assets/Vector Smart Object 2.png"),
                    ),
                    backgroundColor: Color(0xff38ABD8),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(right: 18.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, RoutePath.notification_page);
                          },
                          child: Icon(Icons.notifications),
                        ),
                      ),
                    ],
                  ),
                  drawer: Drawer(
                    backgroundColor: Color(0XFF4E5B81),
                    child: DrawerScreen(),
                  ),
                  body: Container(
                    width: width,
                    height: height,
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/long.png"),
                                  fit: BoxFit.cover)),
                          padding: EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GetBuilder<AuthController>(
                                  init: authController,
                                  builder: (_) {
                                    return InkWell(
                                      child: Image.asset(
                                        'assets/Group 4 copy 3.png',
                                        width: 50,
                                        fit: BoxFit.fill,
                                        color:
                                            authController.user?.value.isClub ==
                                                        null ||
                                                    authController.user?.value
                                                            .isClub ==
                                                        false
                                                ? Colors.grey
                                                : null,
                                      ),
                                      onTap: () {
                                        if (authController.user?.value.isClub ==
                                                null ||
                                            authController.user?.value.isClub ==
                                                false) {
                                          authController
                                              .alert1("please_subscribe".tr);
                                        } else {}
                                      },
                                    );
                                  }),
                              InkWell(
                                child: Image.asset(
                                  'assets/Group 4 copy 4.png',
                                  width: 50,
                                  fit: BoxFit.fill,
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RoutePath.profile_page);
                                },
                              ),
                              InkWell(
                                child: Stack(
                                  children: [
                                    Image.asset(
                                      'assets/Group 4 copy 5.png',
                                      width: 50,
                                      fit: BoxFit.fill,
                                    ),
                                    GetBuilder(
                                      init: authController,
                                      builder: (_) {
                                        if (authController.user == null) {
                                          return SizedBox();
                                        }
                                        return Positioned(
                                          right: 0,
                                          top: 0,
                                          child: StreamBuilder(
                                            stream: db
                                                .collection('matches')
                                                .doc(authController
                                                    .user!.value.uid)
                                                .collection('matches')
                                                .where('me', isEqualTo: false)
                                                .where('friend',
                                                    isEqualTo: true)
                                                .snapshots(),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<QuerySnapshot>
                                                    snapShot) {
                                              if (!snapShot.hasData) {
                                                return new Container();
                                              } else if (snapShot
                                                      .data?.docs.length ==
                                                  0) {
                                                return Container();
                                              }
                                              return Container(
                                                width: 18,
                                                height: 18,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    shape: BoxShape.circle),
                                                child: Text(
                                                  snapShot.data?.docs.length
                                                          .toString() ??
                                                      '',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    )
                                  ],
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RoutePath.like_me_page);
                                },
                              ),
                              InkWell(
                                child: Stack(
                                  children: [
                                    Image.asset(
                                      'assets/Group 4 copy 5f.png',
                                      width: 50,
                                      fit: BoxFit.fill,
                                    ),
                                    homeController.missedMessageLength.value ==
                                            0
                                        ? Container()
                                        : Positioned(
                                            right: 0,
                                            top: 0,
                                            child: Container(
                                              width: 8,
                                              height: 8,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color:
                                                      Colors.greenAccent[700],
                                                  shape: BoxShape.circle),
                                            ),
                                          )
                                  ],
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RoutePath.chat_home_page);
                                },
                              ),
                              GetBuilder(
                                  init: authController,
                                  builder: (_) {
                                    return InkWell(
                                      child: Image.asset(
                                          authController.user?.value.isClub !=
                                                      null &&
                                                  authController
                                                          .user?.value.isClub ==
                                                      true
                                              ? 'assets/Group 4 copy 6.png'
                                              : 'assets/Group 4 copy 6.png',
                                          width: 50,
                                          fit: BoxFit.fill,
                                          color: authController
                                                      .user?.value.isClub ==
                                                  true
                                              ? Colors.green
                                              : Colors.grey),
                                      onTap: authController
                                                      .user?.value.isClub !=
                                                  null &&
                                              authController
                                                      .user?.value.isClub ==
                                                  true
                                          ? () {
                                              gotoPlaceListPage('club'.tr);
                                            }
                                          : () {
                                              authController.alert1(
                                                  'please_enable_in_acc'.tr);
                                            },
                                    );
                                  }),
                              GetBuilder(
                                  init: authController,
                                  builder: (_) {
                                    return InkWell(
                                      child: Image.asset(
                                          authController.user?.value
                                                      .isRestaurant ==
                                                  true
                                              ? 'assets/Group 4 copy 6d.png'
                                              : 'assets/Group 4 copy 6d.png',
                                          width: 50,
                                          fit: BoxFit.fill,
                                          color: authController.user?.value
                                                          .isRestaurant !=
                                                      null &&
                                                  authController.user?.value
                                                          .isRestaurant ==
                                                      true
                                              ? Colors.green
                                              : Colors.grey),
                                      onTap: authController.user?.value
                                                      .isRestaurant !=
                                                  null &&
                                              authController.user?.value
                                                      .isRestaurant ==
                                                  true
                                          ? () {
                                              gotoPlaceListPage(
                                                  'restaurant'.tr);
                                            }
                                          : () {
                                              authController.alert1(
                                                  'please_enable_acc'.tr);
                                            },
                                    );
                                  }),
                            ],
                          ),
                        ),
                        GetBuilder(
                            init: homeController,
                            builder: (_) {
                              return Expanded(
                                child: SwipeCardStack(
                                  key: _swipeKey,
                                  children:
                                      homeController.swipeCards.map((data) {
                                    return SwiperItem(builder:
                                        (SwiperPosition position,
                                            double progress) {
                                      if (data.runtimeType == UserModel) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(6)),
                                          ),
                                          child: Card(
                                            child: Stack(
                                              children: <Widget>[
                                                SizedBox.expand(
                                                  child: Material(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                    child: Image(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                        data.avatar,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 40,
                                                  width: 40,
                                                  margin:
                                                      EdgeInsets.only(left: 5),
                                                  child: Image(
                                                      image: AssetImage(
                                                          'assets/flags/png/${data.whichLatinCountryYouLinkedWith.toLowerCase()}.png')),
                                                ),
                                                SizedBox.expand(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Colors.transparent,
                                                          Colors.black54
                                                        ],
                                                        begin: Alignment.center,
                                                        end: Alignment
                                                            .bottomCenter,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment: Alignment.topLeft,
                                                  child: position
                                                              .toString()
                                                              .substring(15) ==
                                                          "None"
                                                      ? Container()
                                                      : RotationTransition(
                                                          turns:
                                                              new AlwaysStoppedAnimation(
                                                                  -15 / 360),
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10,
                                                                    top: 5,
                                                                    right: 10,
                                                                    bottom: 5),
                                                            margin:
                                                                EdgeInsets.all(
                                                                    20),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .green,
                                                                    width: 3)),
                                                            child: Text(
                                                              position.toString().substring(
                                                                          15) ==
                                                                      "Up"
                                                                  ? "love_it".tr
                                                                  : position.toString().substring(
                                                                              15) ==
                                                                          "Right"
                                                                      ? "LinkUp"
                                                                          .tr
                                                                      : "NAH"
                                                                          .tr,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .green,
                                                                  fontSize: 25,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          )),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 16.0,
                                                            horizontal: 16.0),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Row(
                                                          children: [
                                                            Container(
                                                              constraints:
                                                                  BoxConstraints(
                                                                maxWidth: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.6,
                                                              ),
                                                              child: Text(
                                                                  (data.firstName) +
                                                                      ' ' +
                                                                      (data
                                                                          .lastName),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          24.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700)),
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            if (!data.showMyAge)
                                                              GetBuilder(
                                                                  init:
                                                                      authController,
                                                                  builder: (_) {
                                                                    return Text(
                                                                        data.age
                                                                            .toString(),
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              20.0,
                                                                        ));
                                                                  }),
                                                            SizedBox(
                                                              width: 15,
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Container(
                                                          width: 250,
                                                          child: Text(
                                                              (data.aboutMe)
                                                                          .length >
                                                                      100
                                                                  ? (data.aboutMe)
                                                                          .substring(
                                                                              0,
                                                                              100) +
                                                                      ' . . . '
                                                                  : data
                                                                      .aboutMe,
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white)),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(data.job,
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10.0,
                                                            horizontal: 10.0),
                                                    child: IconButton(
                                                      icon: Icon(
                                                        Icons.remove_red_eye,
                                                        color: Colors.white,
                                                        size: 30,
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pushNamed(
                                                            context,
                                                            RoutePath
                                                                .user_detail_page,
                                                            arguments: {
                                                              'end_user': data
                                                            });
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment: Alignment.topRight,
                                                  child: Container(
                                                    child: IconButton(
                                                      icon: Icon(
                                                        Icons.more_vert,
                                                        color: Colors.black,
                                                        size: 30,
                                                      ),
                                                      onPressed: () {
                                                        _selectAbuseDialog(
                                                            context,
                                                            data,
                                                            height,
                                                            width,
                                                            padding);
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      } else
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(6)),
                                          ),
                                          child: Card(
                                            child: Stack(
                                              children: <Widget>[
                                                SizedBox.expand(
                                                  child: Material(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.0),
                                                      child: Image(
                                                        fit: BoxFit.cover,
                                                        image: NetworkImage(
                                                          data.image,
                                                        ),
                                                      )),
                                                ),
                                                Align(
                                                  alignment: Alignment.topRight,
                                                  child: Text(
                                                    'ADS',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                    });
                                  }).toList(),
                                  visibleCount: 10,
                                  stackFrom: StackFrom.None,
                                  translationInterval: 6,
                                  scaleInterval: 0.03,
                                  historyCount: 5,
                                  animationDuration:
                                      Duration(milliseconds: 200),
                                  onEnd: () => debugPrint("onEnd"),
                                  onSwipe: (int index,
                                      SwiperPosition position) async {
                                    if (homeController
                                            .swipeCards[index].runtimeType ==
                                        UserModel) {
                                      var totalSwiped = await FirebaseFirestore
                                          .instance
                                          .collection('swipes')
                                          .doc(authController.user?.value.uid)
                                          .collection('seen_by_date')
                                          .where('date',
                                              isEqualTo:
                                                  AppConstant().getTodaysDate())
                                          .get();

                                      if (totalSwiped.docs.length >= 25 &&
                                          authController.user?.value.isClub ==
                                              false) {
                                        _swipeKey.currentState?.rewind();
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text(
                                              'you_have_reached_free_limit'.tr,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 17,
                                              ),
                                            ),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  Navigator.pushNamed(
                                                      context,
                                                      RoutePath
                                                          .subscription_page_one);
                                                },
                                                child: Text('buy_premium'.tr),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .resolveWith(
                                                                (states) =>
                                                                    Colors
                                                                        .red)),
                                                child: Text('close'.tr),
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        chatController.addSeenToDb(
                                          userId:
                                              authController.user!.value.uid!,
                                          friendId: homeController
                                                  .swipeCards[_swipeKey
                                                          .currentState!
                                                          .currentIndex +
                                                      1]
                                                  .uid ??
                                              '',
                                        );
                                        if (position == SwiperPosition.Right) {
                                          chatController.matchesLike(
                                              context,
                                              homeController
                                                      .swipeCards[_swipeKey
                                                              .currentState!
                                                              .currentIndex +
                                                          1]
                                                      .uid ??
                                                  '',
                                              homeController
                                                  .swipeCards[_swipeKey
                                                          .currentState!
                                                          .currentIndex +
                                                      1]
                                                  .avatar);
                                        } else if (position ==
                                            SwiperPosition.Left) {
                                          chatController.matchesDislike(
                                              context,
                                              homeController
                                                      .swipeCards
                                                      .value[_swipeKey
                                                              .currentState!
                                                              .currentIndex +
                                                          1]
                                                      .uid ??
                                                  '');
                                        } else if (position ==
                                            SwiperPosition.Up) {
                                          superLike(homeController
                                                  .swipeCards[_swipeKey
                                                          .currentState!
                                                          .currentIndex +
                                                      1]
                                                  .uid ??
                                              '');
                                        }
                                      }
                                    } else {
                                      if (position == SwiperPosition.Right) {
                                        String url = homeController
                                            .swipeCards[index]['www'];

                                        url = url.contains('www.')
                                            ? url.replaceAll('www.', 'https://')
                                            : url;

                                        launchUrl(Uri.parse(url));
                                      }
                                    }
                                  },
                                  onRewind: (int index,
                                          SwiperPosition position) =>
                                      debugPrint("onRewind $index $position"),
                                ),
                              );
                            }),
                        Container(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                child: Image.asset(
                                  'assets/Group 4 copy.png',
                                  width: 50,
                                  fit: BoxFit.fill,
                                ),
                                onTap: () {
                                  _swipeKey.currentState?.rewind();
                                },
                              ),
                              InkWell(
                                child: Image.asset(
                                  'assets/Group 4.png',
                                  width: 50,
                                  fit: BoxFit.fill,
                                ),
                                onTap: () {
                                  _swipeKey.currentState?.swipeLeft();
                                },
                              ),
                              InkWell(
                                child: Image.asset(
                                  'assets/Group 5.png',
                                  width: 50,
                                  fit: BoxFit.fill,
                                ),
                                onTap: () {
                                  _swipeKey.currentState?.swipeRight();
                                },
                              ),
                              InkWell(
                                child: Image.asset(
                                  'assets/Group 164012.png',
                                  width: 50,
                                  fit: BoxFit.fill,
                                ),
                                onTap: () {
                                  _swipeKey.currentState?.swipeUp();
                                },
                              ),
                              GetBuilder(
                                  init: authController,
                                  builder: (_) {
                                    return InkWell(
                                      child: Image.asset(
                                          authController.user?.value
                                                          .isTopShelf !=
                                                      null &&
                                                  authController.user?.value
                                                          .isTopShelf ==
                                                      true
                                              ? 'assets/pak.png'
                                              : 'assets/pak.png',
                                          width: 50,
                                          fit: BoxFit.fill,
                                          color: authController
                                                      .user?.value.isTopShelf ==
                                                  true
                                              ? Colors.green
                                              : Colors.grey),
                                      onTap: authController
                                                      .user?.value.isTopShelf !=
                                                  null &&
                                              authController
                                                      .user?.value.isTopShelf ==
                                                  true
                                          ? () {
                                              topShelf();
                                            }
                                          : () {
                                              authController.alert1(
                                                  'please_enable_acc'.tr);
                                            },
                                    );
                                  }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
