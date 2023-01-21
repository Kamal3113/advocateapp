import 'dart:async';

import 'package:device_calendar/device_calendar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqladvocate/firebaserootpage.dart';
import 'package:sqladvocate/rootpage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  DeviceCalendarPlugin _deviceCalendarPlugin;
  _SplashScreenState() {
    _deviceCalendarPlugin = DeviceCalendarPlugin();
  }
  String _homeScreenText = "Empty";
String notificationAlert = "alert";

FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
     _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        setState(() {
        //  _newNotification = true;
        });
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      //  _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
     //   _navigateToItemDetail(message);
      },
    );

    //Needed by iOS only
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });

    //Getting the token from FCM
    _firebaseMessaging.getToken().then((String token)async {
      assert(token != null);
      setState(() {
        _homeScreenText = token;
        //"Push Messaging token: \n\n $token";
      });
          SharedPreferences localStorage = await SharedPreferences.getInstance();
    
      localStorage.setString('apptoken',_homeScreenText);
      print(_homeScreenText);
    });
    Timer(Duration(seconds: 3), () {
      calenderdetails();
      return Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => Rootpage()),
          (Route<dynamic> route) => false);
    });
  }

  void calenderdetails() async {
    var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
    if (permissionsGranted.isSuccess && !permissionsGranted.data) {
      permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
      if (!permissionsGranted.isSuccess || !permissionsGranted.data) {
        return;
      }
    }
    var result = await _deviceCalendarPlugin.createCalendar(
      "test",

// calendarColor: _colorChoice.value,
      localAccountName: "localname",
    );

    if (result.isSuccess) {
      print("Mauj krdi");
    } else {
      print("oh no oh no");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
               color: Colors.orangeAccent,),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  color: Colors.orangeAccent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          height: 180,
                          width: 130,
                          decoration: BoxDecoration(
                              color: Colors.orangeAccent, shape: BoxShape.circle),
                          child: CircleAvatar(
                            backgroundColor: Colors.grey,
                            //  radius: 5,
                            child: ClipOval(
                              child: Image.asset("assest/vakeel.png",),
                              
                            ),
                          )
                          // Image.asset("assest/vakeel.png"),
                          ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      Text(
                        "Advocate Dairy",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Text(
                      "Version-1.0",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.white),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
