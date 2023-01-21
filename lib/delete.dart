// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Nicesnippets',
//       theme: ThemeData(
//         primarySwatch: Colors.red,
//        // visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: MyHomePage(title: 'Welcome to Nicesnippets'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   MyHomePage({Key key, this.title}) : super(key: key);
//   final String title;
//   State createState() => _State();
// }

// class Item {
//   const Item(this.name,this.icon);
//   final String name;
//   final Icon icon;
// }

// class _State extends State {
//   TextEditingController nameController = TextEditingController();

//   List users = [
//     const Item('Android',Icon(Icons.android,color:  const Color(0xFF167F67),)),
//     const Item('Flutter',Icon(Icons.flag,color:  const Color(0xFF167F67),)),
//     const Item('ReactNative',Icon(Icons.format_indent_decrease,color:  const Color(0xFF167F67),)),
//     const Item('iOS',Icon(Icons.mobile_screen_share,color:  const Color(0xFF167F67),)),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Welcome to Nicesnippets'),
//         ),
//         body: Padding(

//             padding: EdgeInsets.all(10),

//             child: ListView(
//               children: [
//                 Container(
//                     alignment: Alignment.center,
//                     padding: EdgeInsets.all(10),
//                     margin: const EdgeInsets.only(top: 50),
//                     child: Text(
//                       'Dropdown Box',
//                       style: TextStyle(
//                           color: Colors.red,
//                           fontWeight: FontWeight.w500,
//                           fontSize: 30),
//                     )),
//                 DropdownButton(
//                   items: users.map((user) {
//                     return DropdownMenuItem(
//                       value: user,
//                       child: Row(
//                         children: [
//                           user.icon,
//                           SizedBox(width: 10,),
//                           Text(
//                             user.name,
//                             style:  TextStyle(color: Colors.red),
//                           ),
//                         ],
//                       ),
//                     );
//                   }).toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       value;
//                     });
//                   },
//                 ),

//                 Container(
//                     height: 50,
//                     padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
//                     child: RaisedButton(
//                       textColor: Colors.white,
//                       color: Colors.red,
//                       child: Text('Button'),
//                       onPressed: () {
//                         print(nameController.text);
//                       },
//                     )),
//               ],
//             )));
//   }
// }