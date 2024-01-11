import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:ppp/Screens/Information.dart';
import 'package:ppp/Screens/Payment/paymentDetails.dart';
import 'package:ppp/Screens/Profile/EditProfile.dart';
import 'package:ppp/Screens/Profile/settings.dart';
import 'package:ppp/models/user_model.dart';
import 'package:ppp/util/color.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:ppp/Screens/auth/login.dart';

///import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../Payment/subscriptions.dart';
import 'package:easy_localization/easy_localization.dart';

final List adds = [
  {
    'icon': Icons.whatshot,
    'color': Colors.indigo,
    'title': "Get matches faster".tr().toString(),
    'subtitle': "Boost your profile once a month".tr().toString(),
  },
  {
    'icon': Icons.favorite,
    'color': Colors.lightBlueAccent,
    'title': "more likes".tr().toString(),
    'subtitle': "Get free rewindes".tr().toString(),
  },
  {
    'icon': Icons.star_half,
    'color': Colors.amber,
    'title': "Increase your chances".tr().toString(),
    'subtitle': "Get unlimited free likes".tr().toString(),
  },
  {
    'icon': Icons.location_on,
    'color': Colors.purple,
    'title': "Swipe around the world".tr().toString(),
    'subtitle': "Passport to anywhere with ppp".tr().toString(),
  },
  {
    'icon': Icons.vpn_key,
    'color': Colors.orange,
    'title': "Control your profile".tr().toString(),
    'subtitle': "highly secured".tr().toString(),
  }
];

class Profile extends StatefulWidget {
  final User currentUser;
  final bool isPuchased;
  final Map items;
  final List<PurchaseDetails> purchases;
  Profile(this.currentUser, this.isPuchased, this.purchases, this.items);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final EditProfileState _editProfileState = EditProfileState();
  //BannerAd _ad;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50), topRight: Radius.circular(50)),
            color: Colors.white),
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
              Widget>[
            SizedBox(
              height: 10,
            ),
            Container(
              child: Stack(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "asset/logo-transp.png", // Substitua pelo caminho real para o seu arquivo de imagem do logo
                        height: 115, // Ajuste a altura conforme necessário
                        width: 50, // Ajuste a largura conforme necessário
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
                                  fontFamily: 'Monteserrat',
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Hero(
              tag: "abc",
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: secondryColor,
                  child: Align(
                    alignment: Alignment.center,
                    child: Material(
                      color: Colors.white,
                      child: Stack(
                        children: <Widget>[
                          InkWell(
                            onTap: () => showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return Info(widget.currentUser,
                                      widget.currentUser, null);
                                }),
                            child: Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  80,
                                ),
                                child:
/*                                    
CachedNetworkImage(
  height: 150,
  imageUrl: widget.currentUser.imageUrl[0],
  imageBuilder: (context, imageProvider) => Container(
    decoration: BoxDecoration(
      image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
          colorFilter:
              ColorFilter.mode(Colors.transparent, BlendMode.colorBurn)),
    ),
  ),
  placeholder: (context, url) => CircularProgressIndicator(),
 // errorWidget: (context, url, error) => CircularProgressIndicator(),
),
*/

                                    CachedNetworkImage(
                                  height: 150,
                                  width: 150,
                                  fit: BoxFit.fill,
                                  imageUrl:
                                      widget.currentUser.imageUrl.length > 0
                                          ? widget.currentUser.imageUrl[0] ?? ''
                                          : '',
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              color: primaryColor,
                              child: IconButton(
                                  alignment: Alignment.center,
                                  icon: Icon(
                                    Icons.photo_camera,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    _editProfileState.source(
                                        context, widget.currentUser, true);
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Text(
              widget.currentUser.name != null && widget.currentUser.age != null
                  ? "${widget.currentUser.name}, ${widget.currentUser.age}"
                  : "",
              style: TextStyle(
                fontFamily: 'Monteserrat',
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 30,
              ),
            ),
            Text(
              widget.currentUser.editInfo['university'] != null
                  ? "${widget.currentUser.editInfo['university']}"
                  : "",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Monteserrat',
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                  fontSize: 20),
            ),

/*            
            Padding(
              padding: const EdgeInsets.only(top: 200),
              child: InkWell(
                child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(25),
                        gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              primaryColor,
                              secondColor,
                              secondColor,
                              primaryColor,
                            ])),
                    height: MediaQuery.of(context).size.height * .065,
                    width: MediaQuery.of(context).size.width * .75,
                    child: Center(
                        child: Text(
                      widget.isPuchased && widget.purchases != null
                          ? "Check Payment Details".tr().toString()
                          : "Subscribe Plan".tr().toString(),
                      style: TextStyle(
                          fontSize: 15,
                          color: textColor,
                          fontWeight: FontWeight.bold),
                    ))),
                onTap: () async {
                  if (widget.isPuchased && widget.purchases != null) {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) =>
                              PaymentDetails(widget.purchases)),
                    );
                  } else {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => Subscription(
                              widget.currentUser, null, widget.items)),
                    );
                  }
                  // showCupertinoDialog(
                  //     context: context,
                  //     builder: (context) {
                  //       return Dialog(
                  //         insetAnimationDuration: Duration(seconds: 3),
                  //         elevation: 25,
                  //         insetPadding: EdgeInsets.all(20),
                  //         shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(20)),
                  //         insetAnimationCurve: Curves.bounceInOut,
                  //         backgroundColor: Colors.white,
                  //         child: Subscription(),
                  //       );
                  //    });
                },
              ),
            ),
 */
            Padding(
              padding: EdgeInsets.only(top: 16.0), // Ajuste conforme necessário
              child: FloatingActionButton(
                splashColor: secondryColor,
                heroTag: UniqueKey(),
                backgroundColor: Colors.purple.shade900,
                child: Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 22,
                ),
                onPressed: () {
                  _configurandoModalBottomSheet(context);
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }

  void _configurandoModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: new Icon(
                      Icons.settings,
                    ),
                    title: new Text(
                      "Settings".tr().toString(),
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    onTap: () => {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  maintainState: true,
                                  builder: (context) => Settings(
                                      widget.currentUser,
                                      widget.isPuchased,
                                      widget.items)))
                        }),
                ListTile(
                  leading: new Icon(
                    Icons.camera_alt,
                  ),
                  title: new Text(
                    "Add media".tr().toString(),
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onTap: () => {
                    _editProfileState.source(context, widget.currentUser, false)
                  },
                ),
                ListTile(
                  leading: new Icon(
                    Icons.edit,
                  ),
                  title: new Text(
                    "Edit Info".tr().toString(),
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onTap: () => {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) =>
                                EditProfile(widget.currentUser)))
                  },
                ),
                ListTile(
                  leading: new Icon(
                    Icons.close,
                  ),
                  title: new Text(
                    "Logout".tr().toString(),
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Logout'.tr().toString()),
                          content: Text('Do you want to logout your account?'
                              .tr()
                              .toString()),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text('No'.tr().toString()),
                            ),
                            FlatButton(
                              onPressed: () async {
                                await _auth.signOut().whenComplete(() {
                                  _firebaseMessaging.deleteInstanceID();
                                  Navigator.pushReplacement(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) => Login()),
                                  );
                                });
                              },
                              child: Text('Yes'.tr().toString()),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        });
  }
}

class CurvePainter extends CustomPainter {
  void paint(Canvas canvas, Size size) {
    var paint = Paint();

    paint.color = secondryColor.withOpacity(.4);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1.5;

    var startPoint = Offset(0, -size.height / 2);
    var controlPoint1 = Offset(size.width / 4, size.height / 3);
    var controlPoint2 = Offset(3 * size.width / 4, size.height / 3);
    var endPoint = Offset(size.width, -size.height / 2);

    var path = Path();
    path.moveTo(startPoint.dx, startPoint.dy);
    path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx,
        controlPoint2.dy, endPoint.dx, endPoint.dy);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
