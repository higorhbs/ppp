import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ppp/Screens/Tab.dart';
import 'package:ppp/Screens/auth/otp_verification.dart';
import 'package:ppp/util/color.dart';
import 'package:ppp/util/snackbar.dart';
import 'login.dart';
import 'package:easy_localization/easy_localization.dart';

class OTP extends StatefulWidget {
  final bool updateNumber;
  OTP(this.updateNumber);

  @override
  _OTPState createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool cont = false;
  String _smsVerificationCode;
  String countryCode = '+55';
  TextEditingController phoneNumController = new TextEditingController();
  Login _login = new Login();

  @override
  void dispose() {
    super.dispose();
    cont = false;
  }

  /// method to verify phone number and handle phone auth
  Future _verifyPhoneNumber(String phoneNumber) async {
    phoneNumber = countryCode + phoneNumber.toString();
    print(phoneNumber);
    final FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 30),
        verificationCompleted: (authCredential) =>
            _verificationComplete(authCredential, context),
        verificationFailed: (authException) =>
            _verificationFailed(authException, context),
        codeAutoRetrievalTimeout: (verificationId) =>
            _codeAutoRetrievalTimeout(verificationId),
        // called when the SMS code is sent
        codeSent: (verificationId, [code]) =>
            _smsCodeSent(verificationId, [code]));
  }

  Future updatePhoneNumber() async {
    print("here");
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    await Firestore.instance
        .collection("Users")
        .document(user.uid)
        .setData({'phoneNumber': user.phoneNumber}, merge: true).then((_) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) {
            Future.delayed(Duration(seconds: 2), () async {
              Navigator.pop(context);
            });
            return Center(
                child: Container(
                    width: 180.0,
                    height: 200.0,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: <Widget>[
                        Image.asset(
                          "asset/auth/verified.jpg",
                          height: 100,
                        ),
                        Text(
                          "Phone Number\nChanged\nSuccessfully".tr().toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Monteserrat',
                              decoration: TextDecoration.none,
                              color: Colors.black,
                              fontSize: 20),
                        )
                      ],
                    )));
          });
    });
  }

  /// will get an AuthCredential object that will help with logging into Firebase.
  _verificationComplete(
      AuthCredential authCredential, BuildContext context) async {
    if (widget.updateNumber) {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      user
          .updatePhoneNumberCredential(authCredential)
          .then((_) => updatePhoneNumber())
          .catchError((e) {
        CustomSnackbar.snackbar("$e", _scaffoldKey);
      });
    } else {
      FirebaseAuth.instance
          .signInWithCredential(authCredential)
          .then((authResult) async {
        print(authResult.user.uid);
        //snackbar("Success!!! UUID is: " + authResult.user.uid);
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (_) {
              Future.delayed(Duration(seconds: 2), () async {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Tabbar(null, null)));
                await _login.navigationCheck(authResult.user, context);
              });
              return Center(
                  child: Container(
                      width: 150.0,
                      height: 160.0,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            "asset/auth/verified.jpg",
                            height: 60,
                            color: primaryColor,
                            colorBlendMode: BlendMode.color,
                          ),
                          Text(
                            "Verified\n Successfully".tr().toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Monteserrat',
                                decoration: TextDecoration.none,
                                color: Colors.black,
                                fontSize: 20),
                          )
                        ],
                      )));
            });
        await Firestore.instance
            .collection('Users')
            .where('userId', isEqualTo: authResult.user.uid)
            .getDocuments()
            .then((QuerySnapshot snapshot) async {
          if (snapshot.documents.length <= 0) {
            await setDataUser(authResult.user);
          }
        });
      });
    }
  }

  _smsCodeSent(String verificationId, List<int> code) async {
    // set the verification code so that we can use it to log the user in
    _smsVerificationCode = verificationId;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          Future.delayed(Duration(seconds: 2), () {
            Navigator.pop(context);
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => Verification(
                        countryCode + phoneNumController.text,
                        _smsVerificationCode,
                        widget.updateNumber)));
          });
          return Center(

              // Aligns the container to center
              child: Container(
                  // A simplified version of dialog.
                  width: 100.0,
                  height: 120.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        "asset/auth/verified.jpg",
                        height: 60,
                        color: primaryColor,
                        colorBlendMode: BlendMode.color,
                      ),
                      Text(
                        "OTP\nSent".tr().toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Monteserrat',
                            decoration: TextDecoration.none,
                            color: Colors.black,
                            fontSize: 20),
                      )
                    ],
                  )));
        });
  }

  _verificationFailed(AuthException authException, BuildContext context) {
    CustomSnackbar.snackbar(
        "Exception!! message:" + authException.message.toString(),
        _scaffoldKey);
  }

  _codeAutoRetrievalTimeout(String verificationId) {
    // set the verification code so that we can use it to log the user in
    _smsVerificationCode = verificationId;
    print("timeout $_smsVerificationCode");
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Icon(
              //   Icons.mobile_screen_share,
              //   size: 50,
              // ),
              ListTile(
                contentPadding: EdgeInsets.only(
                    top: 50), // Ajuste o valor conforme necessário
                title: Padding(
                  padding: EdgeInsets.only(
                      left: 65), // Ajuste o valor conforme necessário
                  child: Text(
                    "Verifique seu número".tr().toString(),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: 'Monteserrat',
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF444142), // Defina a cor corretamente
                    ),
                  ),
                ),
              ),

              Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                  child: ListTile(
                      leading: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 1.0,
                              color: Color(0xFF444142),
                            ),
                          ),
                        ),
                        child: CountryCodePicker(
                          onChanged: (value) {
                            countryCode = value.dialCode;
                          },
                          // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                          initialSelection: 'BR',
                          favorite: ['+55', 'BR'],
                          // optional. Shows only country name and flag
                          showCountryOnly: false,
                          // optional. Shows only country name and flag when popup is closed.
                          showOnlyCountryWhenClosed: false,
                          // optional. aligns the flag and the Text left
                          alignLeft: false,
                        ),
                      ),
                      title: Container(
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          style: TextStyle(fontSize: 20),
                          cursorColor: Color(0xFF444142),
                          controller: phoneNumController,
                          onChanged: (value) {
                            setState(() {
                              // if (value.length == 10) {
                              cont = true;
                              //  phoneNumController.text = value;
                              //  } else {
                              //    cont = false;
                              //  }
                            });
                          },
                          decoration: InputDecoration(
                            hintText: "".tr().toString(),
                            hintStyle: TextStyle(fontSize: 18),
                            focusColor: Color(0xFF444142),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF444142),
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      Color(0xFF444142)), // Corrija esta linha
                            ),
                          ),
                        ),
                      ))),
              ListTile(
                subtitle: Text(
                  "Por favor, insira seu número de celular \n para receber um código de verificação. \nPodem ser aplicadas taxas de mensagem\n e dados."
                      .tr()
                      .toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Monteserrat',
                      fontSize: 10,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40),
              ),
              cont
                  ? InkWell(
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
                          height: MediaQuery.of(context).size.height * .055,
                          width: MediaQuery.of(context).size.width * .75,
                          child: Center(
                              child: Text(
                            "CONTINUE".tr().toString(),
                            style: TextStyle(
                                fontFamily: 'Monteserrat',
                                fontSize: 15,
                                color: textColor,
                                fontWeight: FontWeight.bold),
                          ))),
                      onTap: () async {
                        showDialog(
                          builder: (context) {
                            Future.delayed(Duration(seconds: 1), () {
                              Navigator.of(context).pop(false);
                            });
                            return Center(
                                child: CupertinoActivityIndicator(
                              radius: 20,
                            ));
                          },
                          barrierDismissible: false,
                          context: context,
                        );

                        await _verifyPhoneNumber(phoneNumController.text);
                      },
                    )
                  : Container(
                      decoration: BoxDecoration(
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
                            fontWeight: FontWeight.bold),
                      ))),
            ],
          ),
        ),
      ),
    );
  }
}

Future setDataUser(FirebaseUser user) async {
  await Firestore.instance.collection("Users").document(user.uid).setData({
    'userId': user.uid,
    'phoneNumber': user.phoneNumber,
    'timestamp': FieldValue.serverTimestamp(),
    'Pictures': FieldValue.arrayUnion(["https://i.imgur.com/JFTjCMh.png"])

    // 'name': user.displayName,
    // 'pictureUrl': user.photoUrl,
  }, merge: true);
}
