import 'package:flutter/material.dart';
import 'package:ppp/Screens/Chat/recent_chats.dart';
import 'package:ppp/models/user_model.dart';
import 'package:ppp/util/color.dart';
import 'Matches.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeScreen extends StatefulWidget {
  final User currentUser;
  final List<User> matches;
  final List<User> newmatches;
  HomeScreen(this.currentUser, this.matches, this.newmatches);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 500), () {
      if (widget.matches.length > 0 && widget.matches[0].lastmsg != null) {
        widget.matches.sort((a, b) {
          if (a.lastmsg != null && b.lastmsg != null) {
            var adate = a.lastmsg; //before -> var adate = a.expiry;
            var bdate = b.lastmsg; //before -> var bdate = b.expiry;
            return bdate?.compareTo(
                adate); //to get the order other way just switch `adate & bdate`
          }
          return 1;
        });
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text("PPPUNI".tr().toString(),
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Monteserrat',
              fontSize: 27.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            )),
        flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
              primaryColor,
              secondColor,
            ]))),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50), topRight: Radius.circular(50)),
            color: Colors.white),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50), topRight: Radius.circular(50)),
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Matches(widget.currentUser, widget.newmatches),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Recent messages'.tr().toString(),
                    style: TextStyle(
                      fontFamily: 'Monteserrat',
                      color: primaryColor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                RecentChats(widget.currentUser, widget.matches),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
