import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ppp/Screens/auth/otp.dart';
import 'package:ppp/models/user_model.dart';
import 'package:ppp/util/color.dart';
import 'package:easy_localization/easy_localization.dart';

class UpdateNumber extends StatelessWidget {
  final User currentUser;
  UpdateNumber(this.currentUser);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Phone number settings".tr().toString(),
          style: TextStyle(fontFamily: 'Monteserrat', color: Colors.white),
        ),
        flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
              primaryColor,
              secondColor,
            ]))),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50), topRight: Radius.circular(50)),
            color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text("Phone number".tr().toString(),
                  style: TextStyle(
                      fontFamily: 'Monteserrat',
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ),
            Card(
                child: ListTile(
              title: Text(
                  currentUser.phoneNumber != null
                      ? "${currentUser.phoneNumber}"
                      : "Verify Phone number".tr().toString(),
                  style: TextStyle(
                      fontFamily: 'Monteserrat',
                      fontSize: 15,
                      fontWeight: FontWeight.w400)),
              trailing: Icon(
                currentUser.phoneNumber != null ? Icons.done : null,
                color: primaryColor,
              ),
            )),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text("Verified phone number".tr().toString(),
                  style: TextStyle(
                      fontFamily: 'Monteserrat',
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: secondryColor)),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Center(
                child: InkWell(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text("Update my phone number".tr().toString(),
                          style: TextStyle(
                              fontFamily: 'Monteserrat',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: primaryColor)),
                    ),
                  ),
                  onTap: () => Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => OTP(true))),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
