
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sqflite/sqflite.dart';
// import 'dart:io' as io;
// import 'package:path/path.dart';
// import 'package:sqladvocate/clientlist.dart';
// import 'package:sqladvocate/clientpage.dart';

// class LoginHomePage extends StatefulWidget {
//   @override
//   LoginHomePageeState createState() => LoginHomePageeState();
// }

// class LoginHomePageeState extends State<LoginHomePage> {
// // final DBStudentManager dbStudentManager = new DBStudentManager();
//   final _nameController = TextEditingController();
//   final _courseController = TextEditingController();
//   final _formkey = new GlobalKey<FormState>();

//   int updateindex;
//   static Database _db;
//   static const String DB_NAME = 'contacts.db';
//   static const String TABLE = 'userlogin';
//   static const String ID = 'id';
//   static const String USERNAME = 'username';
//   static const String PASSWORD = 'password';
//   static const String EMAIL = 'email';
//   static const String TOKEN = 'token';


//   @override
//   void initState() {
//     super.initState();
//     // _query();
//   }

//   List<ClientList> _clients = [];
//   Future<List<ClientList>> _query() async {
//     Database db = await this.db;
//     db.delete(TABLE);
//     List<Map> maps = await db.query(TABLE, orderBy: '$USERNAME ASC');

//     if (maps.length > 0) {
//       for (int i = 0; i < maps.length; i++) {
//         _clients.add(ClientList.fromMap(maps[i]));
//       }
//     }
//     return _clients;
//   }

//   ClientList _clientList;
//   Future<Database> get db async {
//     if (_db != null) {
//       return _db;
//     }
//     _db = await initDb();
//     return _db;
//   }

//   initDb() async {
//     io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
//     String path = join(documentsDirectory.path, DB_NAME);
//     var db = await openDatabase(path, version: 1, onCreate: _onCreate);
//     return db;
//   }
//  List messagelist = [];
//   _onCreate(Database db, int version) async {
//     await db.execute(
//         "CREATE TABLE $TABLE (ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, $USERNAME TEXT,$PASSWORD TEXT,$EMAIL TEXT,$TOKEN TEXT)");
//   }

//   _chatlist() async {
//     var dbClient = await db;
// //dbClient.delete("message");

//     var test = await dbClient.rawQuery(
//         "Select * from $TABLE  where ($USERNAME ,$PASSWORD ,$EMAIL ,$TOKEN)");

//     print(test);
//     setState(() {
//       messagelist = test;
//     });


     
 
//   }
//   bool _login;
//   void login(BuildContext context) async {
//     for (int i = 0; i < _clients.length; i++) {
//       if (_clients[i].name == _nameController.text) {
//         if (_clients[i].phone == _courseController.text) {
//           print('done');
//           SharedPreferences localStorage =
//               await SharedPreferences.getInstance();
//           setState(() {
//             _login = true;
//           });
//           localStorage.setBool('checklogin', _login);
//           await Navigator.of(context).pushAndRemoveUntil(
//               MaterialPageRoute(
//                   builder: (BuildContext context) => ClientPage()),
//               (Route<dynamic> route) => false);
//         }
//       } else {
//         print('BYE');
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Flutter Sqflite Example"),
//       ),
//       body: ListView(
//         children: <Widget>[
//           Form(
//             key: _formkey,
//             child: Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: Column(
//                 children: <Widget>[
//                   TextFormField(
//                     decoration: InputDecoration(labelText: "UserName"),
//                     controller: _nameController,
//                     validator: (val) =>
//                         val.isNotEmpty ? null : "Name Should not be Empty",
//                   ),
//                   TextFormField(
//                     decoration: InputDecoration(labelText: "Password"),
//                     controller: _courseController,
//                     validator: (val) =>
//                         val.isNotEmpty ? null : "Password Should not be Empty",
//                   ),
//                   RaisedButton(
//                     textColor: Colors.white,
//                     color: Colors.lightBlue,
//                     child: Container(
//                         width: width * 0.9,
//                         child: Text(
//                           "Submit",
//                           textAlign: TextAlign.center,
//                         )),
//                     onPressed: () {
//                       if (_formkey.currentState.validate()) {
//                         login(context);
//                       }
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }


// }
