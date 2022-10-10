import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:link_up/element/full_screen_image.dart';
import 'package:link_up/element/swipe_gallery.dart';
import 'package:link_up/get_controller/ChatController.dart';
import 'package:link_up/get_controller/auth_controller.dart';
import 'package:link_up/model/user_model.dart';

class UserDetailPage extends StatefulWidget {
  final UserModel endUser;
  const UserDetailPage({required this.endUser, Key? key}) : super(key: key);
  @override
  _UserDetailPageState createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  AuthController authController = Get.find(tag: AuthController().toString());
  ChatController chatController = Get.find(tag: ChatController().toString());

  @override
  void initState() {
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
            body: SafeArea(
              child: Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                  Positioned(
                      top: 0,
                      child: Container(
                          height: height,
                          width: width,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: height * 0.6,
                                  width: width,
                                  color: Colors.grey,
                                  child: Image.network(widget.endUser.avatar,
                                      fit: BoxFit.fill,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
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
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      (widget.endUser.firstName) +
                                          ' ' +
                                          (widget.endUser.lastName),
                                      style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      widget.endUser.age.toString(),
                                      style: TextStyle(
                                        fontSize: 24,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        Icon(Icons.home_outlined),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          '${'lives_in'.tr} ' +
                                              widget.endUser.country,
                                          style: TextStyle(fontSize: 16),
                                        )
                                      ],
                                    )),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    widget.endUser.aboutMe,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'photos'.tr,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        widget.endUser.morePhotos.isEmpty
                                            ? GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          FullScreenImage(
                                                        imageURL: widget
                                                            .endUser.avatar,
                                                        tag: '',
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  width: 100,
                                                  height: 100,
                                                  decoration: BoxDecoration(
                                                    color: Colors.green[900],
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                          widget.endUser.avatar,
                                                        ),
                                                        fit: BoxFit.fill),
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                height: 100,
                                                child: ListView.builder(
                                                  itemCount: widget.endUser
                                                      .morePhotos.length,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        SwipeGallery(
                                                                          image: widget
                                                                              .endUser
                                                                              .morePhotos,
                                                                          index:
                                                                              index,
                                                                        ))
                                                            // MaterialPageRoute(builder: (context) => FullScreenGallery(galleryItem: personalData['morePhotos'], index: index,))
                                                            );
                                                      },
                                                      child: Container(
                                                        width: 100,
                                                        margin: EdgeInsets.only(
                                                            right: 10),
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Colors.green[900],
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          image: DecorationImage(
                                                              image: NetworkImage(
                                                                widget.endUser
                                                                        .morePhotos[
                                                                    index],
                                                              ),
                                                              fit: BoxFit.fill),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              )
                                      ],
                                    )),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'my_interest'.tr,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'some_interest'.tr,
                                          style: TextStyle(fontSize: 16),
                                        )
                                      ],
                                    )),
                                SizedBox(
                                  height: 20,
                                ),
                                widget.endUser.university != ''
                                    ? Container(
                                        padding: EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'university'.tr,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              widget.endUser.university,
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ))
                                    : Container(),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'job'.tr,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          widget.endUser.job,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    )),
                                SizedBox(
                                  height: 100,
                                ),
                              ],
                            ),
                          ))),
                  Positioned(
                      top: 10,
                      left: 10,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 7,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Icon(Icons.arrow_back),
                        ),
                      )),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.only(top: 5, bottom: 10),
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            child: Image.asset(
                              'assets/icon/Icons_Nah.png',
                              width: 50,
                              fit: BoxFit.fill,
                            ),
                            onTap: () async {
                              await chatController.matchesDislike(
                                  context, widget.endUser.uid!);
                              Navigator.of(context).pop();
                            },
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          InkWell(
                            child: Image.asset(
                              'assets/icon/Icons_Yes_Sir.png',
                              width: 50,
                              fit: BoxFit.fill,
                            ),
                            onTap: () async {
                              await chatController.matchesLike(context,
                                  widget.endUser.uid!, widget.endUser.avatar);
                            },
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          InkWell(
                            child: Image.asset(
                              'assets/icon/Icons_Love_It.png',
                              width: 50,
                              fit: BoxFit.fill,
                            ),
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
