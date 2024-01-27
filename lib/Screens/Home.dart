import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:ppp/Screens/Information.dart';
import 'package:ppp/Screens/Payment/subscriptions.dart';
import 'package:ppp/Screens/Tab.dart';

///import 'package:ppp/ads/ads.dart';
import 'package:ppp/models/user_model.dart';
import 'package:ppp/util/color.dart';
import 'package:swipe_stack/swipe_stack.dart';
import 'package:easy_localization/easy_localization.dart';

List userRemoved = [];
int countswipe = 1;
int index = 0;

class CardPictures extends StatefulWidget {
  final List<User> users;
  final User currentUser;
  final int swipedcount;
  final Map items;
  CardPictures(this.currentUser, this.users, this.swipedcount, this.items);

  @override
  _CardPicturesState createState() => _CardPicturesState();
}

class _CardPicturesState extends State<CardPictures>
    with AutomaticKeepAliveClientMixin<CardPictures> {
  // TabbarState state = TabbarState();
  bool onEnd = false;

  ///Ads _ads = new Ads();

  GlobalKey<SwipeStackState> swipeKey = GlobalKey<SwipeStackState>();
  @override
  bool get wantKeepAlive => true;
  Widget build(BuildContext context) {
    super.build(context);
    int freeSwipe = widget.items['free_swipes'] != null
        ? int.parse(widget.items['free_swipes'])
        : 10;
    bool exceedSwipes = widget.swipedcount >= freeSwipe;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(0.0), // here the desired height
          child: AppBar(backgroundColor: Colors.transparent)),
      body: Container(
        child: ClipRRect(
          child: Stack(
            children: [
              AbsorbPointer(
                absorbing: exceedSwipes,
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height * .99,
                      width: MediaQuery.of(context).size.width * 99,
                      child:
                          //onEnd ||
                          widget.users.length == 0
                              ? Align(
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        "asset/novo.png",
                                        height:
                                            150, // Ajuste a altura conforme necessário
                                        width:
                                            150, // Ajuste a largura conforme necessário
                                      ),
                                    ],
                                  ),
                                )
                              : SwipeStack(
                                  key: swipeKey,
                                  padding: EdgeInsets.symmetric(horizontal: 0),
                                  children: widget.users.map((index) {
                                    // User user;
                                    return SwiperItem(builder:
                                        (SwiperPosition position,
                                            double progress) {
                                      return Material(
                                          elevation: 30,
                                          child: Container(
                                            child: Stack(
                                              children: <Widget>[
                                                ClipRRect(
                                                  child: Swiper(
                                                    customLayoutOption:
                                                        CustomLayoutOption(
                                                      startIndex: 0,
                                                    ),
                                                    key: UniqueKey(),
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index2) {
                                                      return Container(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.99,
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        child: Padding(
                                                          padding: EdgeInsets.only(
                                                              top:
                                                                  65), // Ajuste o valor da margem superior conforme necessário
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl:
                                                                index.imageUrl[
                                                                        index2] ??
                                                                    "",
                                                            fit: BoxFit.cover,
                                                            useOldImageOnUrlChange:
                                                                true,
                                                            placeholder: (context,
                                                                    url) =>
                                                                CupertinoActivityIndicator(
                                                              radius: 20,
                                                            ),
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Icon(Icons
                                                                        .error),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    itemCount:
                                                        index.imageUrl.length,
                                                    pagination:
                                                        new SwiperPagination(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      builder:
                                                          DotSwiperPaginationBuilder(
                                                        activeSize: 1,
                                                        color: secondryColor,
                                                        activeColor:
                                                            primaryColor,
                                                      ),
                                                    ),
                                                    control: new SwiperControl(
                                                      color: primaryColor,
                                                      disableColor:
                                                          secondryColor,
                                                    ),
                                                    loop: false,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      110.0),
                                                  child: position.toString() ==
                                                          "SwiperPosition.Left"
                                                      ? Align(
                                                          alignment: Alignment
                                                              .topRight,
                                                          child:
                                                              Transform.rotate(
                                                            angle: pi / 12,
                                                            child: Container(
                                                              height: 40,
                                                              width: 120,
                                                              decoration: BoxDecoration(
                                                                  shape: BoxShape
                                                                      .rectangle,
                                                                  border: Border.all(
                                                                      width: 2,
                                                                      color: Colors
                                                                          .red)),
                                                              child: Center(
                                                                child: Text(
                                                                    "NOPE"
                                                                        .tr()
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Monteserrat',
                                                                        color: Colors
                                                                            .red,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            32)),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : position.toString() ==
                                                              "SwiperPosition.Right"
                                                          ? Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: Transform
                                                                  .rotate(
                                                                angle: -pi / 8,
                                                                child:
                                                                    Container(
                                                                  height: 40,
                                                                  width: 120,
                                                                  decoration: BoxDecoration(
                                                                      shape: BoxShape
                                                                          .rectangle,
                                                                      border: Border.all(
                                                                          width:
                                                                              2,
                                                                          color:
                                                                              Colors.lightBlueAccent)),
                                                                  child: Center(
                                                                    child: Text(
                                                                        "LIKE"
                                                                            .tr()
                                                                            .toString(),
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'Monteserrat',
                                                                            color:
                                                                                Colors.lightBlueAccent,
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 32)),
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          : Container(),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 80),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.bottomLeft,
                                                    child: ListTile(
                                                      onTap: () {
                                                        showDialog(
                                                          barrierDismissible:
                                                              false,
                                                          context: context,
                                                          builder: (context) {
                                                            return Info(
                                                                index,
                                                                widget
                                                                    .currentUser,
                                                                swipeKey);
                                                          },
                                                        );
                                                      },
                                                      title: Text(
                                                        "${index.name}, ${index.editInfo['showMyAge'] != null ? !index.editInfo['showMyAge'] ? index.age : "" : index.age}",
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Monteserrat',
                                                          color: Colors.white,
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      subtitle: Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .location_on, // Use the location icon
                                                            color: Colors.white,
                                                            size: 18,
                                                          ),
                                                          SizedBox(
                                                              width:
                                                                  5), // Add some spacing between the icon and text
                                                          Text(
                                                            "${index.distanceBW}km de distância",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ));
                                    });
                                  }).toList(growable: true),
                                  threshold: 30,
                                  maxAngle: 100,
                                  //animationDuration: Duration(milliseconds: 400),
                                  visibleCount: 5,
                                  historyCount: 1,
                                  stackFrom: StackFrom.Right,
                                  translationInterval: 5,
                                  scaleInterval: 0.08,
                                  onSwipe: (int index,
                                      SwiperPosition position) async {
                                    _adsCheck(countswipe);
                                    print(position);
                                    print(widget.users[index].name);
                                    CollectionReference docRef =
                                        Firestore.instance.collection("Users");
                                    if (position == SwiperPosition.Left) {
                                      await docRef
                                          .document(widget.currentUser.id)
                                          .collection("CheckedUser")
                                          .document(widget.users[index].id)
                                          .setData(
                                        {
                                          'DislikedUser':
                                              widget.users[index].id,
                                          'timestamp': DateTime.now(),
                                        },
                                      );

                                      if (index < widget.users.length) {
                                        userRemoved.clear();
                                        setState(() {
                                          userRemoved.add(widget.users[index]);
                                          widget.users.removeAt(index);
                                        });
                                      }
                                    } else if (position ==
                                        SwiperPosition.Right) {
                                      if (likedByList
                                          .contains(widget.users[index].id)) {
                                        showDialog(
                                            context: context,
                                            builder: (ctx) {
                                              Future.delayed(
                                                  Duration(milliseconds: 1700),
                                                  () {
                                                Navigator.pop(ctx);
                                              });
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 0),
                                                child: Align(
                                                  alignment:
                                                      Alignment.topCenter,
                                                  child: Card(
                                                    child: Container(
                                                      height: 200,
                                                      width: 600,
                                                      child: Center(
                                                        child: Text(
                                                          "It's a match\n With ",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color:
                                                                  primaryColor,
                                                              fontSize: 30,
                                                              fontFamily:
                                                                  'Montserrat',
                                                              decoration:
                                                                  TextDecoration
                                                                      .none),
                                                        ).tr(args: [
                                                          '${widget.users[index].name}'
                                                        ]),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            });
                                        await docRef
                                            .document(widget.currentUser.id)
                                            .collection("Matches")
                                            .document(widget.users[index].id)
                                            .setData(
                                          {
                                            'Matches': widget.users[index].id,
                                            'isRead': false,
                                            'userName':
                                                widget.users[index].name,
                                            'pictureUrl':
                                                widget.users[index].imageUrl[0],
                                            'timestamp':
                                                FieldValue.serverTimestamp()
                                          },
                                        );
                                        await docRef
                                            .document(widget.users[index].id)
                                            .collection("Matches")
                                            .document(widget.currentUser.id)
                                            .setData(
                                          {
                                            'Matches': widget.currentUser.id,
                                            'userName': widget.currentUser.name,
                                            'pictureUrl':
                                                widget.currentUser.imageUrl[0],
                                            'isRead': false,
                                            'timestamp':
                                                FieldValue.serverTimestamp()
                                          },
                                        );
                                      }

                                      await docRef
                                          .document(widget.currentUser.id)
                                          .collection("CheckedUser")
                                          .document(widget.users[index].id)
                                          .setData(
                                        {
                                          'LikedUser': widget.users[index].id,
                                          'timestamp':
                                              FieldValue.serverTimestamp(),
                                        },
                                      );
                                      await docRef
                                          .document(widget.users[index].id)
                                          .collection("LikedBy")
                                          .document(widget.currentUser.id)
                                          .setData(
                                        {
                                          'LikedBy': widget.currentUser.id,
                                          'timestamp':
                                              FieldValue.serverTimestamp()
                                        },
                                      );
                                      if (index < widget.users.length) {
                                        userRemoved.clear();
                                        setState(() {
                                          userRemoved.add(widget.users[index]);
                                          widget.users.removeAt(index);
                                        });
                                      }
                                    } else
                                      debugPrint("onSwipe $index $position");
                                  },
                                  onRewind:
                                      (int index, SwiperPosition position) {
                                    swipeKey.currentContext
                                        .dependOnInheritedWidgetOfExactType();
                                    widget.users.insert(index, userRemoved[0]);
                                    setState(() {
                                      userRemoved.clear();
                                    });
                                    debugPrint("onRewind $index $position");
                                    print(widget.users[index].id);
                                  },
                                ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(30),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            FloatingActionButton(
                              heroTag: UniqueKey(),
                              backgroundColor: Color.fromRGBO(0, 0, 0, 0),
                              child: new Image.asset("asset/x.png"),
                              onPressed: () {
                                if (widget.users.length > 0) {
                                  print("object");
                                  swipeKey.currentState.swipeLeft();
                                }
                              },
                            ),
                            FloatingActionButton(
                                heroTag: UniqueKey(),
                                backgroundColor: Color.fromRGBO(0, 0, 0, 0),
                                child: new Image.asset("asset/interrog.png"),
                                onPressed: () async {
                                  if (widget.users.length > 0) {
                                    _penso(index);
                                  }
                                }),
                            FloatingActionButton(
                              heroTag: UniqueKey(),
                              backgroundColor: Color.fromRGBO(0, 0, 0,
                                  0), // Ajuste o último valor para controlar a opacidade
                              child: Image.asset("asset/pegoo.png"),
                              onPressed: () {
                                if (widget.users.length > 0) {
                                  swipeKey.currentState.swipeRight();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 15, // Ajuste a posição superior conforme necessário
                width: MediaQuery.of(context)
                    .size
                    .width, // Use a largura total da tela
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "asset/logo-transp.png", // Substitua pelo caminho real para o seu arquivo de imagem do logo
                        height: 40, // Ajuste a altura conforme necessário
                        width: 40, // Ajuste a largura conforme necessário
                      ),
                      SizedBox(width: 7), // Espaço entre a imagem e o texto
                      ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            colors: [
                              HSLColor.fromAHSL(1.0, 301, 0.64, 0.64).toColor(),
                              HSLColor.fromAHSL(1.0, 262, 0.31, 0.71).toColor(),
                              HSLColor.fromAHSL(1.0, 198, 0.42, 0.79).toColor(),
                            ], // Cores do gradiente roxo
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ).createShader(bounds);
                        },
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "PPP",
                                style: TextStyle(
                                  fontSize: 27,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Monteserrat',
                                ),
                              ),
                              TextSpan(
                                text: "UNI",
                                style: TextStyle(
                                  fontSize: 27,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat',
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              exceedSwipes
                  ? Align(
                      alignment: Alignment.center,
                      child: InkWell(
                          child: Container(
                            color: Colors.white.withOpacity(.3),
                            child: Dialog(
                              insetAnimationCurve: Curves.bounceInOut,
                              insetAnimationDuration: Duration(seconds: 2),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              backgroundColor: Colors.white,
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * .55,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      size: 50,
                                      color: primaryColor,
                                    ),
                                    Text(
                                      "you have already used the maximum number of free available swipes for 24 hrs."
                                          .tr()
                                          .toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: 'Monteserrat',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                          fontSize: 20),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.lock_outline,
                                        size: 120,
                                        color: primaryColor,
                                      ),
                                    ),
                                    Text(
                                      "For swipe more users just subscribe our premium plans."
                                          .tr()
                                          .toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: 'Monteserrat',
                                          color: primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Subscription(null, null, widget.items)))),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  void _adsCheck(count) {
    print(count);
    if (count % 5 == 0) {
      ///_ads.myInterstitial()
      /// ..load()
      ///..show();
      countswipe++;
    } else {
      countswipe++;
    }
  }

  void _penso(index) async {
    CollectionReference docRef = Firestore.instance.collection("Users");
    await docRef
        .document(widget.currentUser.id)
        .collection("Penso")
        .document(widget.users[index].id)
        .setData(
      {
        'UserPensado': widget.users[index].id,
        'timestamp': DateTime.now(),
      },
    );
    if (index < widget.users.length) {
      userRemoved.clear();
      setState(() {
        userRemoved.add(widget.users[index]);
        widget.users.removeAt(index);
      });
    }
  }
}
