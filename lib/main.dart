import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

///import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ppp/Screens/Splash.dart';
import 'package:ppp/Screens/Tab.dart';
import 'package:ppp/Screens/auth/login.dart';
import 'package:ppp/eula.dart';

///import 'package:ppp/ads/ads.dart';
import 'package:ppp/util/color.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]).then((_) {
    InAppPurchaseConnection.enablePendingPurchases();
    //runApp(new MyApp());
    initializeDateFormatting('pt_BR', null).then((_) => runApp(EasyLocalization(
          supportedLocales: [
            Locale('en', 'US'),
            Locale('es', 'ES'),
            Locale('pt', 'BR')
          ],
          path: 'asset/translation',
          saveLocale: true,
          fallbackLocale: Locale('pt', 'BR'),
          child: new MyApp(),
        )));
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoading = true;
  bool isAuth = false;
  bool isRegistered = false;

  @override
  void initState() {
    super.initState();
    _checkAuth();

    /// FirebaseAdMob.instance
    ///     .initialize(appId: Platform.isAndroid ? androidAdAppId : iosAdAppId);
    /// _getLanguage();
  }

  Future _checkAuth() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.currentUser().then((FirebaseUser user) async {
      //  print("usuario atual");
      //   print(user.uid);
      if (user != null) {
        await Firestore.instance
            .collection('Users')
            .where('userId', isEqualTo: user.uid)
            .getDocuments()
            .then((QuerySnapshot snapshot) async {
          if (snapshot.documents.length > 0) {
            if (snapshot.documents[0].data['location'] != null) {
              setState(() {
                isRegistered = true;
                isLoading = false;
              });
            } else {
              setState(() {
                isAuth = true;
                isLoading = false;
              });
            }
            print("loggedin ${user.uid}");
          } else {
            setState(() {
              isLoading = false;
            });
          }
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  _getLanguage() async {
    var itemList = await Firestore.instance
        .collection('Language')
        .document('present_languages')
        .get();

    if (itemList.data['spanish'] == true &&
        itemList.data['english'] == false &&
        itemList.data['portuguese'] == false) {
      setState(() {
        EasyLocalization.of(context).locale = Locale('es', 'ES');
      });
    }
    if (itemList.data['english'] == true &&
        itemList.data['spanish'] == false &&
        itemList.data['portuguese'] == false) {
      setState(() {
        EasyLocalization.of(context).locale = Locale('en', 'US');
      });
    }

    if (itemList.data['portugues'] == true &&
        itemList.data['english'] == false &&
        itemList.data['spanish'] == false) {
      setState(() {
        EasyLocalization.of(context).locale = Locale('pt', 'BR');
      });
    }

    return EasyLocalization.of(context).locale;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
      ),
      home: isLoading
          ? Splash()
          : isRegistered
              ? Tabbar(null, null)
              : isAuth
                  ? Eula()
                  : Login(),
    );
  }
}
