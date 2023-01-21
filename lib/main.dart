
import 'package:flutter/material.dart';

import 'package:sqladvocate/clientpage.dart';
import 'package:sqladvocate/clientdetail.dart';
import 'package:sqladvocate/contactscreen.dart';
import 'package:sqladvocate/eventcalendar.dart';
import 'package:sqladvocate/login.dart';
import 'package:sqladvocate/loginhomepage.dart';
import 'package:sqladvocate/rootpage.dart';
import 'package:sqladvocate/splashscreen.dart';


void main() async {
 WidgetsFlutterBinding.ensureInitialized();
 
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
         // visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home:SplashScreen(),
        routes: {
          '/home': (context)=> EventScreen(),
          '/contact':(context)=> ContactScreen()
        },
        );
  }
}
