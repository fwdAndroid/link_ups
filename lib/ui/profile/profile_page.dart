import 'dart:async';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:link_up/get_controller/auth_controller.dart';
import 'package:link_up/ui/home_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthController authController = Get.find(tag: AuthController().toString());

  imagePickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: double.minPositive,
            padding: EdgeInsets.all(25),
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          child: Icon(
                            Icons.camera_alt,
                            size: 50,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            authController.getImage('camera');
                          },
                        ),
                        Text(
                          'take_photo'.tr,
                          style: TextStyle(color: Colors.black),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          child: Icon(
                            Icons.folder,
                            size: 50,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            authController.getImage('gallery');
                          },
                        ),
                        Text(
                          'browse_image'.tr,
                          style: TextStyle(color: Colors.black),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    authController.getUser(FirebaseAuth.instance.currentUser!.uid, context);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GetBuilder(
        init: authController,
        builder: (_) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.topRight,
                    decoration: BoxDecoration(),
                    child: Stack(
                      alignment: AlignmentDirectional.topCenter,
                      children: [
                        Image.asset("assets/Group 163959.png"),
                        Container(
                          padding:
                              EdgeInsets.only(left: 10, top: 50, right: 10),
                          child: Column(
                            children: <Widget>[
                              Stack(
                                clipBehavior: Clip.none,
                                fit: StackFit.passthrough,
                                children: <Widget>[
                                  Container(
                                    width: width * 0.3,
                                    height: width * 0.3,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: authController.morePhotosURLs.length > 1
                                              ? (NetworkImage(authController
                                                  .morePhotosURLs.first))
                                              : (authController.imageFile != null
                                                      ? FileImage(authController
                                                          .imageFile!)
                                                      : (authController.user?.value
                                                                      .avatar !=
                                                                  null &&
                                                              authController
                                                                      .user
                                                                      ?.value
                                                                      .avatar !=
                                                                  ''
                                                          ? NetworkImage(
                                                              authController.user!
                                                                  .value.avatar)
                                                          : (AssetImage('assets/image/sample_avatar.png'))))
                                                  as ImageProvider),
                                    ),
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: authController.imageFile == null
                                          ? GestureDetector(
                                              child: Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                ),
                                                child: Icon(
                                                  Icons.edit,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ),
                                              onTap: () {
                                                imagePickerDialog(context);
                                              },
                                            )
                                          : GestureDetector(
                                              child: Container(
                                                child: Icon(
                                                  Icons.cancel_rounded,
                                                  color: Colors.red,
                                                  size: 30,
                                                ),
                                              ),
                                              onTap: () {
                                                authController
                                                    .updateImageFile(null);
                                              },
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (authController.user!.value.email != '')
                                    Text(
                                      authController.user!.value.email,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                ],
                              ),
                              SizedBox(
                                height: 14,
                              ),
                              TextFormField(
                                controller: authController.firstnameController,
                                decoration: InputDecoration(
                                  hintText: "enter_first_name".tr,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: authController.lastnameController,
                                decoration: InputDecoration(
                                  hintText: "enter_last_name".tr,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  child: Text(
                                    "Country".tr,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Color(0xff2E2E2E),
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ),
                              Container(
                                  width: 250,
                                  child: GestureDetector(
                                    onTap: () {
                                      showCountryPicker(
                                        context: context,
                                        exclude: <String>['KN', 'MF'],
                                        showPhoneCode: true,
                                        onSelect: (Country country) {
                                          authController
                                              .updateOriginCountry(country);
                                        },
                                      );
                                    },
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            authController.countryName.value
                                                        .length <=
                                                    30
                                                ? authController
                                                    .countryName.value
                                                : authController
                                                    .countryName.value
                                                    .substring(0, 29),
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Icon(Icons.arrow_drop_down),
                                        ]),
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller:
                                    authController.phoneNumberController,
                                decoration: InputDecoration(
                                  hintText: "Enter Phone Number".tr,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                ),
                                keyboardType: TextInputType.number,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 60,
                                padding: EdgeInsets.symmetric(horizontal: 17),
                                child: Center(
                                  child: DropdownButtonFormField<String>(
                                    value: authController.gender.value,
                                    items: authController.genders.map((gender) {
                                      return new DropdownMenuItem(
                                        value: gender,
                                        child: Text(
                                          gender.toString(),
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      );
                                    }).toList(),
                                    hint: Text("select gender"),
                                    decoration: InputDecoration(
                                        border: InputBorder.none),
                                    onChanged: (value) {
                                      setState(() {
                                        authController.updateGender(value!);
                                      });
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  child: Text(
                                    "Date of Birth".tr,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Color(0xff2E2E2E),
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  authController.selectDate(context);
                                },
                                child: TextFormField(
                                  controller: authController.dobController,
                                  enabled: false,
                                  decoration: InputDecoration(
                                    hintText: "select_dob".tr,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  child: Text(
                                    "About Me".tr,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Color(0xff2E2E2E),
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: authController.aboutMeController,
                                maxLines: 4,
                                decoration: InputDecoration(
                                  hintText: 'about_me'.tr,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  child: Text(
                                    "Job Title".tr,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Color(0xff2E2E2E),
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: authController.jobController,
                                decoration: InputDecoration(
                                  hintText: "job_title".tr,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  child: Text(
                                    "University".tr,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Color(0xff2E2E2E),
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: authController.universityController,
                                decoration: InputDecoration(
                                  labelText: "university".tr,
                                  hintText: "university".tr,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Container(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      Text(
                                        "more_photos".tr,
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black.withOpacity(0.5),
                                        ),
                                      ),
                                    ],
                                  )),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                width: width * 0.9,
                                height: 100,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount:
                                        authController.morePhotosURLs.length +
                                            1,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: EdgeInsets.only(left: 10),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey, width: 1),
                                            color: Colors.white12,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15))),
                                        width: 100,
                                        height: 100,
                                        child: (authController
                                                        .morePhotosURLs.length >
                                                    0 &&
                                                index <
                                                    authController
                                                        .morePhotosURLs.length)
                                            ? Stack(
                                                children: [
                                                  ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  15)),
                                                      child: SizedBox(
                                                        width: 100,
                                                        height: 100,
                                                        child: Image.network(
                                                            authController
                                                                    .morePhotosURLs[
                                                                index],
                                                            fit: BoxFit.cover,
                                                            loadingBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    Widget
                                                                        child,
                                                                    ImageChunkEvent?
                                                                        loadingProgress) {
                                                          if (loadingProgress ==
                                                              null)
                                                            return child;
                                                          return Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                              value: loadingProgress
                                                                          .expectedTotalBytes !=
                                                                      null
                                                                  ? loadingProgress
                                                                          .cumulativeBytesLoaded /
                                                                      loadingProgress
                                                                          .expectedTotalBytes!
                                                                  : null,
                                                            ),
                                                          );
                                                        }),
                                                      )),
                                                  Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: GestureDetector(
                                                        child: Container(
                                                          child: Icon(
                                                            Icons
                                                                .cancel_rounded,
                                                            color:
                                                                Colors.red[900],
                                                            size: 25,
                                                          ),
                                                        ),
                                                        onTap: () {
                                                          authController
                                                              .morePhotoDelete(
                                                                  index);
                                                        },
                                                      ))
                                                ],
                                              )
                                            : GestureDetector(
                                                child: Container(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.add,
                                                        size: 40,
                                                        color: Colors.black,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                onTap: () {
                                                  imagePickerDialog(context);
                                                },
                                              ),
                                      );
                                    }),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                      child: Row(
                                    children: [
                                      Icon(
                                        Icons.favorite,
                                        size: 25,
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        "${'interest'.tr}",
                                        style: TextStyle(
                                            fontSize: 17,
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )),
                                ],
                              ),
                              Container(
                                height: height * 0.4,
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: ListView(
                                  children: authController.demoInterestList.keys
                                      .map((String key) {
                                    return new CheckboxListTile(
                                      title: new Text(key),
                                      value:
                                          authController.demoInterestList[key],
                                      activeColor: Colors.pink,
                                      checkColor: Colors.white,
                                      onChanged: (bool? value) {
                                        authController.updateInterestList(
                                            value, key);
                                      },
                                    );
                                  }).toList(),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                child: Container(
                                  width: width * 1,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Color(0xff38ABD8),
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
                                onTap: () async {
                                  authController.updateProfile(
                                      context: context);
                                  new Timer(const Duration(seconds: 2), () {
                                    Navigator.pop(context);
                                  });
                                },
                              ),
                              SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 35,
                          left: 15,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(),
                                  ));
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 7,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Icon(Icons.arrow_back),
                            ),
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
}
