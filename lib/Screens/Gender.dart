import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ppp/Screens/SexualOrientation.dart';
import 'package:ppp/Screens/UserName.dart';
import 'package:ppp/util/color.dart';
import 'package:ppp/util/snackbar.dart';
import 'package:easy_localization/easy_localization.dart';

import 'ShowGender.dart';

class Gender extends StatefulWidget {
  final Map<String, dynamic> userData;
  Gender(this.userData);

  @override
  _GenderState createState() => _GenderState();
}

class _GenderState extends State<Gender> {
  bool man = false;
  bool woman = false;
  bool other = false;
  bool select = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      floatingActionButton: AnimatedOpacity(
        opacity: 1.0,
        duration: Duration(milliseconds: 50),
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: FloatingActionButton(
            elevation: 10,
            child: IconButton(
              color: secondryColor,
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            backgroundColor: Colors.white38,
            onPressed: () {
              dispose();
              Navigator.pop(context);
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: Stack(
        children: <Widget>[
          Padding(
            child: Text(
              "I am a".tr().toString(),
              style: TextStyle(fontFamily: 'Monteserrat', fontSize: 40),
            ),
            padding: EdgeInsets.only(left: 50, top: 120),
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                OutlineButton(
                  highlightedBorderColor: primaryColor,
                  child: Container(
                    height: MediaQuery.of(context).size.height * .065,
                    width: MediaQuery.of(context).size.width * .75,
                    child: Center(
                        child: Text("MAN".tr().toString(),
                            style: TextStyle(
                                fontFamily: 'Monteserrat',
                                fontSize: 20,
                                color: man ? primaryColor : secondryColor,
                                fontWeight: FontWeight.bold))),
                  ),
                  borderSide: BorderSide(
                      width: 1,
                      style: BorderStyle.solid,
                      color: man ? primaryColor : secondryColor),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  onPressed: () {
                    setState(() {
                      woman = false;
                      man = true;
                      other = false;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: OutlineButton(
                    child: Container(
                      height: MediaQuery.of(context).size.height * .065,
                      width: MediaQuery.of(context).size.width * .75,
                      child: Center(
                          child: Text("WOMAN".tr().toString(),
                              style: TextStyle(
                                  fontFamily: 'Monteserrat',
                                  fontSize: 20,
                                  color: woman ? primaryColor : secondryColor,
                                  fontWeight: FontWeight.bold))),
                    ),
                    borderSide: BorderSide(
                      color: woman ? primaryColor : secondryColor,
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    onPressed: () {
                      setState(() {
                        woman = true;
                        man = false;
                        other = false;
                      });
                      // Navigator.push(
                      //     context, CupertinoPageRoute(builder: (context) => OTP()));
                    },
                  ),
                ),
                OutlineButton(
                  focusColor: primaryColor,
                  highlightedBorderColor: primaryColor,
                  child: Container(
                    height: MediaQuery.of(context).size.height * .065,
                    width: MediaQuery.of(context).size.width * .75,
                    child: Center(
                        child: Text("OTHER".tr().toString(),
                            style: TextStyle(
                                fontFamily: 'Monteserrat',
                                fontSize: 20,
                                color: other ? primaryColor : secondryColor,
                                fontWeight: FontWeight.bold))),
                  ),
                  borderSide: BorderSide(
                      width: 1,
                      style: BorderStyle.solid,
                      color: other ? primaryColor : secondryColor),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  onPressed: () {
                    setState(() {
                      woman = false;
                      man = false;
                      other = true;
                    });
                    // Navigator.push(
                    //     context, CupertinoPageRoute(builder: (context) => OTP()));
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 100.0, left: 10),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ListTile(
                leading: Checkbox(
                  activeColor: primaryColor,
                  value: select,
                  onChanged: (bool newValue) {
                    setState(() {
                      select = newValue;
                    });
                  },
                ),
                title: Text("Show my gender on my profile".tr().toString()),
              ),
            ),
          ),
          man || woman || other
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(25),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  HSLColor.fromAHSL(1.0, 301, 0.64, 0.64)
                                      .toColor(),
                                  HSLColor.fromAHSL(1.0, 262, 0.31, 0.71)
                                      .toColor(),
                                  HSLColor.fromAHSL(1.0, 198, 0.42, 0.79)
                                      .toColor(),
                                ],
                              )),
                          height: MediaQuery.of(context).size.height * .065,
                          width: MediaQuery.of(context).size.width * .75,
                          child: Center(
                              child: Text(
                            "CONTINUE".tr().toString(),
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Monteserrat',
                                color: textColor,
                                fontWeight: FontWeight.bold),
                          ))),
                      onTap: () {
                        var userGender;
                        if (man) {
                          userGender = {
                            'userGender': "man",
                            'showOnProfile': select
                          };
                        } else if (woman) {
                          userGender = {
                            'userGender': "woman",
                            'showOnProfile': select
                          };
                        } else {
                          userGender = {
                            'userGender': "other",
                            'showOnProfile': select
                          };
                        }
                        widget.userData.addAll(userGender);
                        // print(userData['userGender']['showOnProfile']);
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) =>
                                    ShowGender(widget.userData)));

                        ///SexualOrientation(widget.userData)));
                        ///ads.disable(ad1);
                      },
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              HSLColor.fromAHSL(1.0, 301, 0.64, 0.64).toColor(),
                              HSLColor.fromAHSL(1.0, 262, 0.31, 0.71).toColor(),
                              HSLColor.fromAHSL(1.0, 198, 0.42, 0.79).toColor(),
                            ],
                          ),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        height: MediaQuery.of(context).size.height * .065,
                        width: MediaQuery.of(context).size.width * .75,
                        child: Center(
                          child: Text(
                            "CONTINUE".tr().toString(),
                            style: TextStyle(
                              fontFamily: 'Monteserrat',
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        CustomSnackbar.snackbar(
                          "Please select one".tr().toString(),
                          _scaffoldKey,
                        );
                      },
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
