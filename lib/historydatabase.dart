// import 'dart:io';

// import 'package:flutter/cupertino.dart';
// import 'dart:async';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sqflite/sqflite.dart';

// class DBClienthistoryManager {
//   Database _datebasehistory;

 
//   Future openhistoryDB() async {
//       Directory documentsDirectory = await 
//       getExternalStorageDirectory();
//     if (_datebasehistory == null) {
//       _datebasehistory = await openDatabase(
//           join( documentsDirectory.path, "clienthistory.db"),
//           version: 1, onCreate: (Database db, int version) async {
         
//         await db.execute(
//             "CREATE TABLE clienthistory (clienthistoryid INTEGER PRIMARY KEY AUTOINCREMENT, clienttitle TEXT,clientphonenumber TEXT,appointdate TEXT,clientcourt TEXT,lastappointdate TEXT,clientid INTEGER, FOREIGN KEY (clientid) REFERENCES client (id))");
//       });
//        SharedPreferences _localstorage = await SharedPreferences.getInstance();
//    _localstorage.setString('filepath',  documentsDirectory.path);
//     }
//   }

//   Future<int> insertClient(Clienthistory clienthistory) async {
//     await openhistoryDB();
//     return await _datebasehistory.insert('clienthistory', clienthistory.toMap());
//   }
//   //  for(int i=0;i<100;i++){
//   // await _datebasehistory.insert('clienthistory', clienthistory.toMap());
// String userid;
//  Future<List<Clienthistory>> gethistorydata() async {
//     SharedPreferences _localstorage = await SharedPreferences.getInstance();

//     userid=  _localstorage.getString('userid');
//     await openhistoryDB();
//     if(userid==null){
// return null;
//     }
//     final List<Map<String, dynamic>> maps = await _datebasehistory.query('clienthistory',
  
//      );
//   // _localstorage.setString('filepath',  _datebasehistory.path);
//     return List.generate(maps.length, (index) {
//       return Clienthistory(
//           clienthistoryid: maps[index]['clienthistoryid'],
//           clienttitle: maps[index]['clienttitle'],
//           clientphonenumber: maps[index]['clientphonenumber'],
//      appointdate: maps[index]['appointdate'],
//           clientcourt: maps[index]['clientcourt'],
//           lastappointdate: maps[index]['lastappointdate'],
//           clientid: maps[index]['clientid']
          
//           );
//     }
//    );
//   }
  
//   Future<List<Clienthistory>> gethistorydata1(String setid) async {
//     SharedPreferences _localstorage = await SharedPreferences.getInstance();

//     userid=  _localstorage.getString('userid');
//     await openhistoryDB();
//     if(userid==null){
// return null;
//     }
//     final List<Map<String, dynamic>> maps = await _datebasehistory.query('clienthistory',
//     where:'clientid=$setid',orderBy: 'clienthistoryid desc'
//      );

//     return List.generate(maps.length, (index) {
//       return Clienthistory(
//           clienthistoryid: maps[index]['clienthistoryid'],
//           clienttitle: maps[index]['clienttitle'],
//           clientphonenumber: maps[index]['clientphonenumber'],
//      appointdate: maps[index]['appointdate'],
//           clientcourt: maps[index]['clientcourt'],
//           lastappointdate: maps[index]['lastappointdate'],
//           clientid: maps[index]['clientid']
          
//           );
//     }
//    );
//   }

//   Future<int> updateClient(Clienthistory clienthistory) async {
//     await openhistoryDB();
//     return await _datebasehistory.update('clienthistory', clienthistory.toMap(),
//         where: 'id=?', whereArgs: [clienthistory.clienthistoryid]);
//   }

//   Future<void> deleteClient(int id) async {
//     await openhistoryDB();
//     await _datebasehistory.delete("clienthistory", where: "id = ? ", whereArgs: [id]);
//   }
// }

// class Clienthistory {
//   int clienthistoryid;
//   String clienttitle;
//   String clientphonenumber;
//   String appointdate;
//   String clientcourt;
//   String lastappointdate;
//   int clientid;
//   Clienthistory({ @required this.clienttitle, 
//   @required this.clientphonenumber,this.clienthistoryid,
//   this.appointdate,this.clientcourt,
//   this.lastappointdate,this.clientid});

//   Map<String, dynamic> toMap() {
//     return {
//       'clienttitle': clienttitle, 
//     'clientphonenumber': clientphonenumber,
//   'appointdate':appointdate,
//     'clientcourt':clientcourt,
//     'lastappointdate':lastappointdate,
//     'clientid':clientid};
//   }
// }
 