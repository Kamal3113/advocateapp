
// import 'package:flutter/material.dart';
// import 'package:sqladvocate/auth.dart';
// import 'package:sqladvocate/eventcalendar.dart';
// import 'package:sqladvocate/login.dart';



// class RootPage1 extends StatefulWidget {
//   RootPage1({this.auth});
//   final BaseAuth auth;
//   @override
//   State<StatefulWidget> createState() => new _RootPageState();
// }

// enum AuthStatus { notsignIn, signIn }

// class _RootPageState extends State<RootPage1> {
//   AuthStatus authStatus = AuthStatus.notsignIn;

//   @override
//   void initState() {
//     super.initState();
//     widget.auth.currentUser().then((userId) {
//       setState(() {
//         authStatus = userId == null ? AuthStatus.notsignIn : AuthStatus.signIn;
//       });
//     });
//   }

//   void _signedIn() {
//     setState(() {
//       authStatus = AuthStatus.signIn;
//     });
//   }

//   void _signOut() {
//     setState(() {
//       authStatus = AuthStatus.notsignIn;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     switch (authStatus) {
//       case AuthStatus.notsignIn:
//         return new Loginpage(
//           auth: widget.auth,
//           onSignedIn: _signedIn,
//         );
//       case AuthStatus.signIn:
//         return new
//             // Scaffold(
//             //   appBar: AppBar(title: new Text('hello'),),
//             // );
//             EventScreen(
//           auth: widget.auth,
//           onSignedOut: _signOut,
//         );
//     }
//   }
// }
