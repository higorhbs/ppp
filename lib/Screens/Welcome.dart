import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ppp/Screens/UserDOB.dart';
import 'package:ppp/Screens/UserName.dart';
import 'package:ppp/util/color.dart';
import 'package:easy_localization/easy_localization.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Container(
                  height: MediaQuery.of(context).size.height * .8,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 150,
                        ),
                        Text(
                          "PPP",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Monteserrat',
                              fontSize: 35,
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.all(8),
                          title: Text(
                            "Welcome to ppp.\nPlease follow these House Rules."
                                .tr()
                                .toString(),
                            style: TextStyle(
                                fontFamily: 'Monteserrat',
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.all(8),
                          title: Text(
                            "Be yourself.".tr().toString(),
                            style: TextStyle(
                                fontFamily: 'Monteserrat',
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "Make sure your photos, age, and bio are true to who you are."
                                .tr()
                                .toString(),
                            style: TextStyle(
                              fontFamily: 'Monteserrat',
                              fontSize: 17,
                            ),
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.all(8),
                          title: Text(
                            "Play it cool.".tr().toString(),
                            style: TextStyle(
                                fontFamily: 'Monteserrat',
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "Respect other and treat them as you would like to be treated"
                                .tr()
                                .toString(),
                            style: TextStyle(
                              fontFamily: 'Monteserrat',
                              fontSize: 17,
                            ),
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.all(8),
                          title: Text(
                            "Stay safe.".tr().toString(),
                            style: TextStyle(
                                fontFamily: 'Monteserrat',
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "Don't be too quick to give out personal information."
                                .tr()
                                .toString(),
                            style: TextStyle(
                              fontFamily: 'Monteserrat',
                              fontSize: 17,
                            ),
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.all(8),
                          title: Text(
                            "Be proactive.".tr().toString(),
                            style: TextStyle(
                                fontFamily: 'Monteserrat',
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "Always report bad behavior.".tr().toString(),
                            style: TextStyle(
                              fontFamily: 'Monteserrat',
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 40, top: 50),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                    child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(25),
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                HSLColor.fromAHSL(1.0, 198, 0.42, 0.79)
                                    .toColor(),
                                HSLColor.fromAHSL(1.0, 262, 0.31, 0.71)
                                    .toColor(),
                                HSLColor.fromAHSL(1.0, 301, 0.64, 0.64)
                                    .toColor(),
                              ],
                            )),
                        height: MediaQuery.of(context).size.height * .065,
                        width: MediaQuery.of(context).size.width * .75,
                        child: Center(
                            child: Text(
                          "GOT IT".tr().toString(),
                          style: TextStyle(
                              fontFamily: 'Monteserrat',
                              fontSize: 15,
                              color: textColor,
                              fontWeight: FontWeight.bold),
                        ))),
                    onTap: () async {
                      await FirebaseAuth.instance.currentUser().then((_user) {
                        if (_user.displayName != null) {
                          if (_user.displayName.length > 0) {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => UserDOB(
                                        {'UserName': _user.displayName})));
                          } else {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => UserName()));
                          }
                        } else {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => UserName()));
                        }
                      });
                    },
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
