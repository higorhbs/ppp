import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ppp/Screens/ShowGender.dart';
import 'package:ppp/util/color.dart';
import 'package:ppp/util/snackbar.dart';
import 'package:easy_localization/easy_localization.dart';

class SexualOrientation extends StatefulWidget {
  final Map<String, dynamic> userData;
  SexualOrientation(this.userData);

  @override
  _SexualOrientationState createState() => _SexualOrientationState();
}

class _SexualOrientationState extends State<SexualOrientation> {
  List<Map<String, dynamic>> orientationlist = [
    {'name': 'Straight'.tr().toString(), 'ontap': false},
    {'name': 'Gay'.tr().toString(), 'ontap': false},
    {'name': 'Asexual'.tr().toString(), 'ontap': false},
    {'name': 'Lesbian'.tr().toString(), 'ontap': false},
    {'name': 'Bisexual'.tr().toString(), 'ontap': false},
    {'name': 'Demisexual'.tr().toString(), 'ontap': false},
  ];
  List selected = [];
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                child: Text(
                  "My sexual\norientation is".tr().toString(),
                  style: TextStyle(fontFamily: 'Monteserrat', fontSize: 40),
                ),
                padding: EdgeInsets.only(left: 50, top: 80),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 70, vertical: 50),
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: orientationlist.length,
                  itemBuilder: (BuildContext context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: OutlineButton(
                        highlightedBorderColor: primaryColor,
                        child: Container(
                          height: MediaQuery.of(context).size.height * .055,
                          width: MediaQuery.of(context).size.width * .65,
                          child: Center(
                              child: Text("${orientationlist[index]["name"]}",
                                  style: TextStyle(
                                      fontFamily: 'Monteserrat',
                                      fontSize: 20,
                                      color: orientationlist[index]["ontap"]
                                          ? primaryColor
                                          : secondryColor,
                                      fontWeight: FontWeight.bold))),
                        ),
                        borderSide: BorderSide(
                            width: 1,
                            style: BorderStyle.solid,
                            color: orientationlist[index]["ontap"]
                                ? primaryColor
                                : secondryColor),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        onPressed: () {
                          setState(() {
                            if (selected.length < 3) {
                              orientationlist[index]["ontap"] =
                                  !orientationlist[index]["ontap"];
                              if (orientationlist[index]["ontap"]) {
                                selected.add(orientationlist[index]["name"]);
                                print(orientationlist[index]["name"]);
                                print(selected);
                              } else {
                                selected.remove(orientationlist[index]["name"]);
                                print(selected);
                              }
                            } else {
                              if (orientationlist[index]["ontap"]) {
                                orientationlist[index]["ontap"] =
                                    !orientationlist[index]["ontap"];
                                selected.remove(orientationlist[index]["name"]);
                              } else {
                                CustomSnackbar.snackbar(
                                    "select upto 3".tr().toString(),
                                    _scaffoldKey);
                              }
                            }
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
              Column(
                children: <Widget>[
                  ListTile(
                    leading: Checkbox(
                      activeColor: primaryColor,
                      value: select,
                      onChanged: (bool newValue) {
                        setState(() {
                          select = newValue;
                        });
                      },
                    ),
                    title: Text(
                        "Show my orientation on my profile".tr().toString()),
                  ),
                  selected.length > 0
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
                                        begin: Alignment.topRight,
                                        end: Alignment.bottomLeft,
                                        colors: [
                                          HSLColor.fromAHSL(
                                                  1.0, 198, 0.42, 0.79)
                                              .toColor(),
                                          HSLColor.fromAHSL(
                                                  1.0, 262, 0.31, 0.71)
                                              .toColor(),
                                          HSLColor.fromAHSL(
                                                  1.0, 301, 0.64, 0.64)
                                              .toColor(),
                                        ],
                                      )),
                                  height:
                                      MediaQuery.of(context).size.height * .065,
                                  width:
                                      MediaQuery.of(context).size.width * .75,
                                  child: Center(
                                      child: Text(
                                    "CONTINUE".tr().toString(),
                                    style: TextStyle(
                                        fontFamily: 'Monteserrat',
                                        fontSize: 15,
                                        color: textColor,
                                        fontWeight: FontWeight.bold),
                                  ))),
                              onTap: () {
                                widget.userData.addAll({
                                  "sexualOrientation": {
                                    'orientation': selected,
                                    'showOnProfile': select
                                  },
                                });
                                print(widget.userData);
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) =>
                                            ShowGender(widget.userData)));
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
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  height:
                                      MediaQuery.of(context).size.height * .065,
                                  width:
                                      MediaQuery.of(context).size.width * .75,
                                  child: Center(
                                      child: Text(
                                    "CONTINUE".tr().toString(),
                                    style: TextStyle(
                                        fontFamily: 'Monteserrat',
                                        fontSize: 15,
                                        color: secondryColor,
                                        fontWeight: FontWeight.bold),
                                  ))),
                              onTap: () {
                                CustomSnackbar.snackbar(
                                    "Please select one".tr().toString(),
                                    _scaffoldKey);
                              },
                            ),
                          ),
                        )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
