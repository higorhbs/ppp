library bottom_navy_bar;

import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ppp/Screens/Profile/profile.dart';
import 'package:ppp/Screens/Splash.dart';
import 'package:ppp/Screens/blockUserByAdmin.dart';
import 'package:ppp/Screens/notifications.dart';
import 'package:ppp/models/user_model.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'Calling/incomingCall.dart';
import 'Chat/home_screen.dart';
import 'Home.dart';
import 'package:ppp/util/color.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

List likedByList = [];

class Tabbar extends StatefulWidget {
  final bool isPaymentSuccess;
  final String plan;
  Tabbar(this.plan, this.isPaymentSuccess);
  @override
  TabbarState createState() => TabbarState();
}

//_
class TabbarState extends State<Tabbar> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  CollectionReference docRef = Firestore.instance.collection('Users');
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User currentUser;
  List<User> matches = [];
  List<User> newmatches = [];

  List<User> users = [];

  /// Past purchases
  List<PurchaseDetails> purchases = [];
  InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;
  bool isPuchased = false;
  @override
  void initState() {
    super.initState();
    // Show payment success alert.
    if (widget.isPaymentSuccess != null && widget.isPaymentSuccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Alert(
          context: context,
          type: AlertType.success,
          title: "Confirmation".tr().toString(),
          desc: "You have successfully subscribed to our"
              .tr(args: ['${widget.plan}']).toString(),
          buttons: [
            DialogButton(
              child: Text(
                "Ok".tr().toString(),
                style: TextStyle(
                    fontFamily: 'Monteserrat',
                    color: Colors.white,
                    fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            )
          ],
        ).show();
      });
    }
    _getAccessItems();
    _getCurrentUser();
    _getMatches();

    ///  _getpastPurchases();
  }

  Map items = {};
  _getAccessItems() async {
    Firestore.instance.collection("Item_access").snapshots().listen((doc) {
      if (doc.documents.length > 0) {
        items = doc.documents[0].data;
        print(doc.documents[0].data);
      }

      if (mounted) setState(() {});
    });
  }

  Future<void> _getpastPurchases() async {
    print('in past purchases');
    QueryPurchaseDetailsResponse response = await _iap.queryPastPurchases();
    print('response   ${response.pastPurchases}');
    for (PurchaseDetails purchase in response.pastPurchases) {
      // if (Platform.isIOS) {
      await _iap.completePurchase(purchase);
      // }
    }
    setState(() {
      purchases = response.pastPurchases;
    });
    if (response.pastPurchases.length > 0) {
      purchases.forEach((purchase) async {
        print('veio no loop do for Mário');
        print('   ${purchase.productID}');
        await _verifyPuchase(purchase.productID);
      });
    }
  }

  /// check if user has pruchased
  PurchaseDetails _hasPurchased(String productId) {
    return purchases.firstWhere((purchase) => purchase.productID == productId,
        orElse: () => null);
  }

  ///verifying pourchase of user
  Future<void> _verifyPuchase(String id) async {
    PurchaseDetails purchase = _hasPurchased(id);

    if (purchase != null && purchase.status == PurchaseStatus.purchased) {
      print(purchase.productID);
      if (Platform.isIOS) {
        await _iap.completePurchase(purchase);
        print('Achats antérieurs........$purchase');
        isPuchased = true;
      }
      isPuchased = true;
    } else {
      isPuchased = false;
    }
  }

  int swipecount = 0;
  _getSwipedcount() {
    Firestore.instance
        .collection('/Users/${currentUser.id}/CheckedUser')
        .where(
          'timestamp',
          isGreaterThan: Timestamp.now().toDate().subtract(Duration(days: 1)),
        )
        .snapshots()
        .listen((event) {
      print(event.documents.length);
      setState(() {
        swipecount = event.documents.length;
      });
      return event.documents.length;
    });
  }

  configurePushNotification(User user) async {
    await _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(
            alert: true, sound: true, provisional: false, badge: true));

    _firebaseMessaging.getToken().then((token) {
      print(token);
      // Mario tirou, pois estava entrando em loop infinito quando
      // acessava em dois aparelhos ao mesmo tempo
      //   docRef.document(user.id).updateData({
      //     'pushToken': token,
      //   });
    });

    _firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> message) async {
        print('===============onLaunch$message');
        if (Platform.isIOS && message['type'] == 'Call') {
          Map callInfo = {};
          callInfo['channel_id'] = message['channel_id'];
          callInfo['senderName'] = message['senderName'];
          callInfo['senderPicture'] = message['senderPicture'];
          bool iscallling = await _checkcallState(message['channel_id']);
          print("=================$iscallling");
          if (iscallling) {
            await Navigator.push(context,
                MaterialPageRoute(builder: (context) => Incoming(message)));
          }
        } else if (Platform.isAndroid && message['data']['type'] == 'Call') {
          bool iscallling =
              await _checkcallState(message['data']['channel_id']);
          print("=================$iscallling");
          if (iscallling) {
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Incoming(message['data'])));
          } else {
            print("Timeout");
          }
        }
      },
      onMessage: (Map<String, dynamic> message) async {
        print("onmessage$message");
        if (Platform.isIOS && message['type'] == 'Call') {
          Map callInfo = {};
          callInfo['channel_id'] = message['channel_id'];
          callInfo['senderName'] = message['senderName'];
          callInfo['senderPicture'] = message['senderPicture'];
          await Navigator.push(context,
              MaterialPageRoute(builder: (context) => Incoming(callInfo)));
        } else if (Platform.isAndroid && message['data']['type'] == 'Call') {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Incoming(message['data'])));
        } else
          print("object");
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume$message');
        if (Platform.isIOS && message['type'] == 'Call') {
          Map callInfo = {};
          callInfo['channel_id'] = message['channel_id'];
          callInfo['senderName'] = message['senderName'];
          callInfo['senderPicture'] = message['senderPicture'];
          bool iscallling = await _checkcallState(message['channel_id']);
          print("=================$iscallling");
          if (iscallling) {
            await Navigator.push(context,
                MaterialPageRoute(builder: (context) => Incoming(message)));
          }
        } else if (Platform.isAndroid && message['data']['type'] == 'Call') {
          bool iscallling =
              await _checkcallState(message['data']['channel_id']);
          print("=================$iscallling");
          if (iscallling) {
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Incoming(message['data'])));
          } else {
            print("Timeout");
          }
        }
      },
    );
  }

  _checkcallState(channelId) async {
    bool iscalling = await Firestore.instance
        .collection("calls")
        .document(channelId)
        .get()
        .then((value) {
      return value.data["calling"] ?? false;
    });
    return iscalling;
  }

  _getMatches() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return Firestore.instance
        .collection('/Users/${user.uid}/Matches')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((ondata) {
      matches.clear();
      newmatches.clear();
      if (ondata.documents.length > 0) {
        ondata.documents.forEach((f) async {
          await docRef
              .document(f.data['Matches'])
              .get()
              .then((DocumentSnapshot doc) {
            if (doc.exists) {
              User tempuser = User.fromDocument(doc);
              tempuser.distanceBW = calculateDistance(
                      currentUser.coordinates['latitude'],
                      currentUser.coordinates['longitude'],
                      tempuser.coordinates['latitude'],
                      tempuser.coordinates['longitude'])
                  .round();

              matches.add(tempuser);
              newmatches.add(tempuser);
              if (mounted) setState(() {});
            }
          });
        });
      }
    });
  }

  _getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return docRef.document("${user.uid}").snapshots().listen((data) async {
      currentUser = User.fromDocument(data);
      if (mounted) setState(() {});
      users.clear();
      userRemoved.clear();
      getUserList();
      getLikedByList();
      configurePushNotification(currentUser);
      if (!isPuchased) {
        _getSwipedcount();
      }
      return currentUser;
    });
  }

  query() {
    if (currentUser.showGender == 'everyone') {
      return docRef
          .where(
            'age',
            isGreaterThanOrEqualTo: int.parse(currentUser.ageRange['min']),
          )
          .where('age',
              isLessThanOrEqualTo: int.parse(currentUser.ageRange['max']))
          .orderBy('age', descending: false);
    } else {
      return docRef
          .where('editInfo.userGender', isEqualTo: currentUser.showGender)
          .where(
            'age',
            isGreaterThanOrEqualTo: int.parse(currentUser.ageRange['min']),
          )
          .where('age',
              isLessThanOrEqualTo: int.parse(currentUser.ageRange['max']))
          //FOR FETCH USER WHO MATCH WITH USER SEXUAL ORIENTAION
          // .where('sexualOrientation.orientation',
          //     arrayContainsAny: currentUser.sexualOrientation)
          .orderBy('age', descending: false);
    }
  }

  Future getUserList() async {
    List checkedUser = [];
    Firestore.instance
        .collection('/Users/${currentUser.id}/CheckedUser')
        .getDocuments()
        .then((data) {
      checkedUser.addAll(data.documents.map((f) => f['DislikedUser']));
      checkedUser.addAll(data.documents.map((f) => f['LikedUser']));
    }).then((_) {
      query().getDocuments().then((data) async {
        if (data.documents.length < 1) {
          print("no more data");
          return;
        }
        users.clear();
        userRemoved.clear();
        for (var doc in data.documents) {
          User temp = User.fromDocument(doc);
          var distance = calculateDistance(
              currentUser.coordinates['latitude'],
              currentUser.coordinates['longitude'],
              temp.coordinates['latitude'],
              temp.coordinates['longitude']);
          temp.distanceBW = distance.round();
          if (checkedUser.any(
            (value) => value == temp.id,
          )) {
          } else {
            if (distance <= currentUser.maxDistance &&
                temp.id != currentUser.id &&
                !temp.isBlocked) {
              users.add(temp);
            }
          }
        }
        if (mounted) setState(() {});
      });
    });
  }

  getLikedByList() {
    docRef
        .document(currentUser.id)
        .collection("LikedBy")
        .snapshots()
        .listen((data) async {
      likedByList.addAll(data.documents.map((f) => f['LikedBy']));
    });
  }

  int _indiceAtual = 0;
  @override
  Widget build(BuildContext context) {
    List<Widget> _telas = [
      Center(child: CardPictures(currentUser, users, swipecount, items)),
      Center(child: HomeScreen(currentUser, matches, newmatches)),
      Center(child: Notifications(currentUser)),
      Center(child: Profile(currentUser, isPuchased, purchases, items)),
    ];
    return Scaffold(
      body: currentUser == null
          ? Center(child: Splash())
          : currentUser.isBlocked
              ? BlockUser()
              : DefaultTabController(
                  length: 4,
                  initialIndex: widget.isPaymentSuccess != null
                      ? widget.isPaymentSuccess
                          ? 0
                          : 1
                      : 1,
                  child: Scaffold(
                    body: _telas[_indiceAtual],
                    bottomNavigationBar: Container(
                      height:
                          80.0, // Ajuste a altura da barra de navegação conforme necessário
                      child: BottomNavigationBar(
                        type: BottomNavigationBarType.fixed,
                        unselectedItemColor: Colors.grey.shade800,
                        iconSize:
                            40, // Ajuste o tamanho dos ícones conforme necessário
                        currentIndex: _indiceAtual,
                        onTap: onTabTapped,
                        elevation:
                            10.0, // Ajuste a elevação da barra de navegação conforme necessário
                        items: [
                          BottomNavigationBarItem(
                            icon: Image.asset(
                              "asset/logo_transparente.png",
                              width:
                                  45, // Ajuste a largura conforme necessário (menos de 48)
                              height:
                                  45, // Ajuste a altura conforme necessário (menos de 48)
                            ),
                            label: "",
                          ),
                          BottomNavigationBarItem(
                            icon: Image.asset("asset/notifications.png"),
                            label: "",
                          ),
                          BottomNavigationBarItem(
                            icon: Image.asset("asset/mensagens.png"),
                            label: "",
                          ),
                          BottomNavigationBarItem(
                            icon: Image.asset("asset/person.png"),
                            label: "",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _indiceAtual = index;
    });
  }
}

double calculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}
