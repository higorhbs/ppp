import 'dart:io';
import 'package:apple_sign_in/apple_sign_in.dart' as i;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ppp/Screens/Tab.dart';
//import 'package:ppp/Screens/Welcome.dart';
import 'package:ppp/Screens/Home.dart';
import 'package:ppp/Screens/auth/otp.dart';
import 'package:ppp/eula.dart';
import 'package:ppp/models/custom_web_view.dart';
import 'package:ppp/util/color.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class Login extends StatelessWidget {
  static const your_client_id = '00000000000000';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static const your_redirect_url =
      'https://h*****firebaseapp.com/__/auth/handler';

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              colors: [
                HSLColor.fromAHSL(1.0, 301, 0.64, 0.64).toColor(),
                HSLColor.fromAHSL(1.0, 262, 0.31, 0.71).toColor(),
                HSLColor.fromAHSL(1.0, 198, 0.42, 0.79).toColor(),
              ],
            ),
            borderRadius: BorderRadius.only(),
          ),
          child: ListView(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  ClipPath(
                    child: Container(
                      width: double.infinity,
                    ),
                  ),
                  ClipPath(
                    child: ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                          colors: [
                            Colors.white,
                            Colors.white,
                            Colors.white,
                          ],
                        ).createShader(bounds);
                      },
                      blendMode: BlendMode.srcATop, // Logo nova
                      child: Container(
                        width: double.infinity,
                        height: 300,
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 75,
                            ),
                            Image.asset(
                              "asset/logo-transp.png",
                              fit: BoxFit.contain,
                              width: 120,
                              height: 120,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "PPPUNI",
                              style: TextStyle(
                                fontFamily: 'Monteserrat',
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height *
                            0.01), // Ajuste o valor de top conforme necessário
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                      child: Center(
                        child: Text(
                          "Ao tocar em Criar Conta ou Entrar, você concorda com nossos Termos. Saiba como processamos seus dados em nossa Política de Privacidade e Política de Cookies."
                              .tr()
                              .toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Monteserrat',
                            color: Colors.white,
                            fontSize: 12.43,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 5), // Ajuste o valor de top conforme necessário
                  ),
                  Center(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(
                            color: Colors.white10, // Cor da borda
                            width: 1.34359, // Largura da borda
                          ),
                        ),
                      ),
                      onPressed: () {
                        bool updateNumber = false;
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => OTP(updateNumber),
                          ),
                        );
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.065,
                        width: MediaQuery.of(context).size.width * 0.55,
                        child: Center(
                          child: Text(
                            "ENTRE COM O TELEFONE".tr().toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Monteserrat',
                              fontSize: 14.78,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),

              SizedBox(height: 90), // Ajuste o valor conforme necessário
              GestureDetector(
                onTap: () {
                  // Lógica para lidar com "Problemas com Login"
                },
                child: Text(
                  "Problemas com o login?".tr().toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Monteserrat',
                    fontSize: 12.43,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      onWillPop: () {
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Exit'.tr().toString()),
              content: Text('Do you want to exit the app?'.tr().toString()),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('No'.tr().toString()),
                ),
                TextButton(
                  onPressed: () => SystemChannels.platform
                      .invokeMethod('SystemNavigator.pop'),
                  child: Text('Yes'.tr().toString()),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<FirebaseUser> handleFacebookLogin(context) async {
    FirebaseUser user;
    String result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CustomWebView(
                selectedUrl:
                    'https://www.facebook.com/dialog/oauth?client_id=1414456248939698&redirect_uri=https://ppps-73695.firebaseapp.com/__/auth/handler&response_type=token&scope=email,public_profile,',
              ),
          maintainState: true),
    );
    if (result != null) {
      try {
        final facebookAuthCred =
            FacebookAuthProvider.getCredential(accessToken: result);
        user =
            (await FirebaseAuth.instance.signInWithCredential(facebookAuthCred))
                .user;

        print('user $user');
      } catch (e) {
        print('Error $e');
      }
    }
    return user;
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future navigationCheck(FirebaseUser currentUser, context) async {
    await Firestore.instance
        .collection('Users')
        .where('userId', isEqualTo: currentUser.uid)
        .getDocuments()
        .then((QuerySnapshot snapshot) async {
      if (snapshot.documents.length > 0) {
        if (snapshot.documents[0].data['location'] != null) {
          Navigator.push(context,
              CupertinoPageRoute(builder: (context) => Tabbar(null, null)));
        } else {
          Navigator.push(
              context, CupertinoPageRoute(builder: (context) => Eula()));
        }
      } else {
        await _setDataUser(currentUser);
        Navigator.push(
            context, CupertinoPageRoute(builder: (context) => Eula()));
      }
    });
  }

  Future<FirebaseUser> handleAppleLogin() async {
    FirebaseUser user;

    if (await i.AppleSignIn.isAvailable()) {
      try {
        final i.AuthorizationResult result =
            await i.AppleSignIn.performRequests([
          i.AppleIdRequest(requestedScopes: [i.Scope.email, i.Scope.fullName])
        ]).catchError((onError) {
          print("inside $onError");
        });

        switch (result.status) {
          case i.AuthorizationStatus.authorized:
            try {
              print("successfull sign in");
              final i.AppleIdCredential appleIdCredential = result.credential;

              OAuthProvider oAuthProvider =
                  new OAuthProvider(providerId: "apple.com");
              final AuthCredential credential = oAuthProvider.getCredential(
                idToken: String.fromCharCodes(appleIdCredential.identityToken),
                accessToken:
                    String.fromCharCodes(appleIdCredential.authorizationCode),
              );

              user = (await _auth.signInWithCredential(credential)).user;
              print("signed in as " + user.toString());
            } catch (error) {
              print("Error $error");
            }
            break;
          case i.AuthorizationStatus.error:
            // do something

            break;

          case i.AuthorizationStatus.cancelled:
            print('User cancelled');
            break;
        }
      } catch (error) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('$error.'),
          duration: Duration(seconds: 8),
        ));
        print("error with apple sign in");
      }
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Apple SignIn is not available for your device'),
        duration: Duration(seconds: 8),
      ));
    }

    return user;
  }
}

class WaveClipper1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * 0.6, size.height - 29 - 50);
    var firstControlPoint = Offset(size.width * .25, size.height - 60 - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 60);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class WaveClipper3 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * 0.6, size.height - 15 - 50);
    var firstControlPoint = Offset(size.width * .25, size.height - 60 - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 40);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 30);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class WaveClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * .7, size.height - 40);
    var firstControlPoint = Offset(size.width * .25, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 45);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

Future _setDataUser(FirebaseUser user) async {
  await Firestore.instance.collection("Users").document(user.uid).setData(
    {
      'userId': user.uid,
      'UserName': user.displayName ?? '',
      'Pictures': FieldValue.arrayUnion([
        user.photoUrl != null
            ? user.photoUrl + '?width=9999'
            : 'https://i.imgur.com/JFTjCMh.png'
      ]),
      'phoneNumber': user.phoneNumber,
      'timestamp': FieldValue.serverTimestamp()
    },
    merge: true,
  );
}
