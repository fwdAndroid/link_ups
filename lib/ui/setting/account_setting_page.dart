import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:link_up/get_controller/auth_controller.dart';
import 'package:link_up/helper/app_config.dart';
import 'package:link_up/helper/app_constant.dart';
import 'package:link_up/helper/shared_pref_service.dart';
import 'package:link_up/model/LanguageModel.dart';
import 'package:link_up/ui/setting/location_setting_page.dart';

class AccountSettingPage extends StatefulWidget {
  const AccountSettingPage({Key? key}) : super(key: key);

  @override
  _AccountSettingPageState createState() => _AccountSettingPageState();
}

class _AccountSettingPageState extends State<AccountSettingPage> {
  AuthController authController = Get.find(tag: AuthController().toString());

  String location = '';

  initDataLoading() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(authController.user!.value.uid)
        .collection('locations')
        .where('isActive', isEqualTo: true)
        .get()
        .then((value) {
      if (value.docs.length != 0) {
        value.docs.forEach((doc) {
          setState(() {
            location = doc.data()['street'] +
                ', ' +
                doc.data()['administrativeArea'] +
                ', ' +
                doc.data()['postalCode'];
          });
        });
      }
    });
  }

  @override
  void initState() {
    initDataLoading();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GetBuilder(
        init: authController,
        builder: (_) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.green.shade900,
              title: Text(
                'account_setting'.tr,
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
              width: width,
              height: height,
              padding: EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 120,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.pin_drop,
                                        size: 25,
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        "location".tr,
                                        style: TextStyle(
                                          fontSize: 17,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'my_location'.tr,
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      if (location != null && location != '')
                                        Text(
                                          location,
                                          style: TextStyle(fontSize: 12),
                                        ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                    icon: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LocationSettingPage()));
                                    })
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 18.0, top: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('distance'.tr,
                                          style: TextStyle(fontSize: 18)),
                                    ],
                                  ),
                                ),
                                RangeSlider(
                                  values:
                                      authController.distanceRangeValue.value,
                                  min: 1,
                                  max: 1000,
                                  divisions: 100,
                                  inactiveColor: Colors.grey,
                                  labels: RangeLabels(
                                    authController
                                        .distanceRangeValue.value.start
                                        .round()
                                        .toString(),
                                    authController.distanceRangeValue.value.end
                                        .round()
                                        .toString(),
                                  ),
                                  onChanged: (RangeValues values) {
                                    authController.updateDistanceValue(values);
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 18.0, top: 10),
                                  child: Text(
                                    "age".tr,
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ),
                                Container(
                                  child: RangeSlider(
                                    values: authController.ageRangeValues.value,
                                    min: 18,
                                    max: 100,
                                    divisions: 82,
                                    inactiveColor: Colors.grey,
                                    labels: RangeLabels(
                                      authController.ageRangeValues.value.start
                                          .round()
                                          .toString(),
                                      authController.ageRangeValues.value.end
                                          .round()
                                          .toString(),
                                    ),
                                    onChanged: (RangeValues values) {
                                      authController
                                          .updateAgeRangeValue(values);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 18.0, top: 10),
                                  child: Text(
                                    "like_me_with".tr,
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Radio(
                                        value: 'Female',
                                        groupValue: authController
                                                .user?.value.linkMeWith ??
                                            authController.linkmeWith.value,
                                        onChanged: (value) {
                                          authController.updateLinkMeWith(
                                              value.toString());
                                        },
                                      ),
                                      Text('female'.tr),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Radio(
                                        value: 'Male',
                                        groupValue: authController
                                                .user?.value.linkMeWith ??
                                            authController.linkmeWith.value,
                                        onChanged: (value) {
                                          print(value);
                                          authController.updateLinkMeWith(
                                              value.toString());
                                        },
                                      ),
                                      Text('male'.tr),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Radio(
                                        value: 'Both',
                                        groupValue: authController
                                                .user?.value.linkMeWith ??
                                            authController.linkmeWith.value,
                                        onChanged: (value) {
                                          authController.updateLinkMeWith(
                                              value.toString());
                                        },
                                      ),
                                      Text('both'.tr),
                                      SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(width: double.infinity),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 18.0, top: 10),
                                  child: Text(
                                    "which_carribbean_or_latin_linkwith".tr,
                                    style: TextStyle(fontSize: 17),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                Row(
                                  children: [
                                    CountryCodePicker(
                                      initialSelection: authController
                                              .user
                                              ?.value
                                              .whichLatinCountryYouLinkedWith ??
                                          "BS",
                                      onChanged: (e) {
                                        authController.updateNationality(
                                            e.name!, e.code!, e.dialCode!);
                                      },
                                      countryList: Utils.carribAndLatinCountry,
                                      hideMainText: false,
                                      textStyle: TextStyle(color: Colors.black),
                                      showOnlyCountryWhenClosed: true,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 18.0, top: 10),
                                  child: Text(
                                    "which_carrib_people_meet_from".tr,
                                    style: TextStyle(
                                      fontSize: 17,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                Container(
                                  width: 160,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Radio(
                                        value: 'all',
                                        groupValue: authController
                                            .meetFromPreference.value,
                                        onChanged: (value) {
                                          authController.updateMeetFromValues(
                                              '', 'all', '');
                                          authController
                                              .updateMeetFromPreference("all");
                                        },
                                      ),
                                      Text('all'.tr),
                                      Radio(
                                        value: 'other',
                                        groupValue: authController
                                            .meetFromPreference.value,
                                        onChanged: (value) {
                                          authController
                                              .updateMeetFromPreference(
                                                  value.toString());
                                        },
                                      ),
                                      Text('other'.tr),
                                    ],
                                  ),
                                ),
                                if (authController.meetFromPreference.value !=
                                    "all")
                                  Row(
                                    children: [
                                      CountryCodePicker(
                                        initialSelection: authController.user
                                                ?.value.linkMeWithCountryCode ??
                                            authController
                                                .countryMeetFromCode.value,
                                        onChanged: (e) {
                                          authController.updateMeetFromValues(
                                              e.name!, e.code!, e.dialCode!);
                                        },
                                        countryList:
                                            Utils.carribAndLatinCountry,
                                        hideMainText: false,
                                        textStyle:
                                            TextStyle(color: Colors.black),
                                        showOnlyCountryWhenClosed: true,
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Card(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 200,
                                    child: Row(
                                      children: [
                                        SizedBox(width: 5),
                                        Text(
                                          "preferred_language".tr,
                                          style: TextStyle(
                                            fontSize: 17,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    width: 130,
                                    child: DropdownButton<LanguageModel>(
                                      isExpanded: true,
                                      icon: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 35,
                                            height: 23,
                                            child: Image.asset(
                                              authController
                                                  .languageImage.value,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(authController.language.value)
                                        ],
                                      ),
                                      items: LanguageModel.languageList()
                                          .map((LanguageModel value) {
                                        return new DropdownMenuItem<
                                            LanguageModel>(
                                          value: value,
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 35,
                                                height: 23,
                                                child: Image.asset(
                                                  value.flag,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(value.language)
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (LanguageModel? val) {
                                        SharedPref.instance.shared.setString(
                                            'locale', val!.languageCode);
                                        Locale _l = AppConstant.getLocale(
                                            val.languageCode);
                                        Get.updateLocale(_l);
                                        if (val != null) {
                                          authController
                                              .updateLanguageFlag(val.flag);
                                          authController
                                              .updatelanguage(val.language);
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                  child: Row(
                                children: [
                                  Text(
                                    "hide_my_age".tr,
                                    style: TextStyle(
                                      fontSize: 17,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              )),
                              Container(
                                height: 40,
                                width: 75,
                                padding: EdgeInsets.only(left: 10.0, top: 10.0),
                                child: Switch(
                                  value: authController.dontShowMyAge.value,
                                  activeColor: Colors.blue,
                                  onChanged: (value) {
                                    authController.updateShowAgeStatus(value);
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                  child: Row(
                                children: [
                                  Icon(
                                    Icons.charging_station,
                                    size: 25,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                  SizedBox(width: 5),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: Text(
                                      "make_status_ghost".tr,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 17,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ],
                              )),
                              Container(
                                height: 40,
                                width: 75,
                                padding: EdgeInsets.only(left: 10.0, top: 10.0),
                                child: Switch(
                                  value: authController.isGhoststatus.value,
                                  activeColor: Colors.blue,
                                  onChanged: (value) {
                                    authController.updateIsGhostStatus(value);
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                        child: Row(
                                      children: [
                                        Icon(
                                          Icons.wheelchair_pickup_sharp,
                                          size: 25,
                                          color: Colors.black.withOpacity(0.5),
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          "live_streaming".tr,
                                          style: TextStyle(
                                            fontSize: 17,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    )),
                                    Container(
                                      height: 40,
                                      padding: EdgeInsets.only(
                                          left: 10.0, top: 10.0),
                                      child: CupertinoSwitch(
                                        value: authController.user!.value
                                                .subscription.isNotEmpty
                                            ? authController
                                                .user!.value.subscription
                                                .where((element) => DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            element['expiry'])
                                                    .isAfter(DateTime.now()))
                                                .toList()
                                                .isNotEmpty
                                            : false,
                                        activeColor: Colors.red,
                                        onChanged: (value) {
                                          // authController.updateMembershipModel(
                                          //     'islivestream', value);
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    )
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 5, top: 5, right: 50),
                                  child: Text('turning_this_on_msg'.tr),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                        child: Row(
                                      children: [
                                        Icon(
                                          Icons.wheelchair_pickup_sharp,
                                          size: 25,
                                          color: Colors.black.withOpacity(0.5),
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          "top_shelf".tr,
                                          style: TextStyle(
                                            fontSize: 17,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    )),
                                    Container(
                                      height: 40,
                                      padding: EdgeInsets.only(
                                          left: 10.0, top: 10.0),
                                      child: CupertinoSwitch(
                                        value: authController.user!.value
                                                .subscription.isNotEmpty
                                            ? authController
                                                .user!.value.subscription
                                                .where((element) => DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            element['expiry'])
                                                    .isAfter(DateTime.now()))
                                                .toList()
                                                .isNotEmpty
                                            : false,
                                        activeColor: Colors.red,
                                        onChanged: (value) {
                                          // authController.updateMembershipModel(
                                          //     'topshelf', value);
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    )
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 5, top: 5, right: 50),
                                  child: Text('turning_this_msg_shelf'.tr),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                        child: Row(
                                      children: [
                                        Icon(
                                          Icons.restaurant,
                                          size: 25,
                                          color: Colors.black.withOpacity(0.5),
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          "restaurants".tr,
                                          style: TextStyle(
                                            fontSize: 17,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    )),
                                    Container(
                                      height: 40,
                                      padding: EdgeInsets.only(
                                          left: 10.0, top: 10.0),
                                      child: CupertinoSwitch(
                                        value: authController.user!.value
                                                .subscription.isNotEmpty
                                            ? authController
                                                .user!.value.subscription
                                                .where((element) => DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            element['expiry'])
                                                    .isAfter(DateTime.now()))
                                                .toList()
                                                .isNotEmpty
                                            : false,
                                        activeColor: Colors.red,
                                        onChanged: (value) {
                                          // authController.updateMembershipModel(
                                          //     'restaurant', value);
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    )
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 5, top: 5, right: 50),
                                  child: Text('turning_this_msg_restaurant'.tr),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                        child: Row(
                                      children: [
                                        Icon(
                                          Icons.room_preferences,
                                          size: 25,
                                          color: Colors.black.withOpacity(0.5),
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          "clubs_and_fates".tr,
                                          style: TextStyle(
                                            fontSize: 17,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    )),
                                    Container(
                                      height: 40,
                                      padding: EdgeInsets.only(
                                          left: 10.0, top: 10.0),
                                      child: CupertinoSwitch(
                                        value: authController.user!.value
                                                .subscription.isNotEmpty
                                            ? authController
                                                .user!.value.subscription
                                                .where((element) => DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            element['expiry'])
                                                    .isAfter(DateTime.now()))
                                                .toList()
                                                .isNotEmpty
                                            : false,
                                        activeColor: Colors.red,
                                        onChanged: (value) {
                                          // authController.updateMembershipModel(
                                          //     'clubs', value);
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    )
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 5, top: 5, right: 50),
                                  child: Text('turning_this_clubs_msg'.tr),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    GestureDetector(
                      child: Container(
                        width: width * 0.5,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.green[900],
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.shade900.withOpacity(0.5),
                              spreadRadius: 7,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "update".tr,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      onTap: () {
                        authController.addSetting(context);
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
