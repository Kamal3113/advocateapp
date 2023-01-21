import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class DBClientManager {
  Database _datebase;
  getdata() async{

  }
 static const String DB_NAME = 'client.db';
  // Future openDB() async {
  //   if (_datebase == null) {
  //     _datebase = await openDatabase(
  //         join(await getDatabasesPath(), "client.db"),
  //         version: 1, onCreate: (Database db, int version) async {
         
  //       await db.execute(
  //           "CREATE TABLE client(id INTEGER PRIMARY KEY AUTOINCREMENT,clientname TEXT,clientaddress TEXT,clientphonenumber TEXT,clientage TEXT, appointdate TEXT,startdate TEXT,starttime TEXT,enddate TEXT,endtime TEXT,  clientcourt TEXT,lastappointdate TEXT,userid TEXT)");
  //     });
  //   }
  // } 
   Future<Database> get db async {
    if (_datebase != null) {
      return _datebase;
    }
    _datebase = await openDB();
    return _datebase;
  }
  Future openDB() async {
    Directory documentsDirectory = await getExternalStorageDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    _datebase = await openDatabase(path, version: 1, onCreate: _onCreate);
    return _datebase;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
         "CREATE TABLE client(id INTEGER PRIMARY KEY AUTOINCREMENT,clientname TEXT,clientaddress TEXT,clientphonenumber TEXT,clientage TEXT, appointdate TEXT,startdate TEXT,starttime TEXT,enddate TEXT,endtime TEXT,  clientcourt TEXT,lastappointdate TEXT,userid TEXT)");
  await db.execute(
            "CREATE TABLE clienthistory (clienthistoryid INTEGER PRIMARY KEY AUTOINCREMENT, clienttitle TEXT,clientphonenumber TEXT,appointdate TEXT,clientcourt TEXT,lastappointdate TEXT,clientid INTEGER, FOREIGN KEY (clientid) REFERENCES client (id))");
  }
 

  Future<int> insertClient(Client client) async {
    await openDB();
    return await _datebase.insert('client', client.toMap());
  }
 
String userid;

  Future<List<Client>> getclientList() async {
    SharedPreferences _localstorage = await SharedPreferences.getInstance();

    userid=  _localstorage.getString('userid');
    await openDB();
    if(userid==null){
return null;
    }
    final List<Map<String, dynamic>> maps = await _datebase.query('client',
    where: 'userid=$userid'
     );

    return List.generate(maps.length, (index) {
      return Client(
          id: maps[index]['id'],
          clientname: maps[index]['clientname'],
          clientaddress: maps[index]['clientaddress'],
          clientphonenumber: maps[index]['clientphonenumber'],
          clientage: maps[index]['clientage'],
          startdate: maps[index]['startdate'],
          starttime:  maps[index]['starttime'],
          enddate: maps[index]['enddate'] ,
          endtime:  maps[index]['endtime'] ,
          clientcourt: maps[index]['clientcourt'],
          lastappointdate: maps[index]['lastappointdate'],
          userid: maps[index]['userid'],
          );
    }
   );
  }
  
//  Future<List<Client>> getclientList1() async {
//     SharedPreferences _localstorage = await SharedPreferences.getInstance();

//     userid=  _localstorage.getString('userid');
//     await openDB();
//     if(userid==null){
// return null;
//     }
//     final List<Map<String, dynamic>> maps = await _datebase.query('client',
//     where: 'userid=$userid'
//      );

//     return List.generate(maps.length, (index) {
//       return Client(
//           id: maps[index]['id'],
//           clientname: maps[index]['clientname'],
//           clientaddress: maps[index]['clientaddress'],
//           clientphonenumber: maps[index]['clientphonenumber'],
//           clientage: maps[index]['clientage'],
//           startdate: maps[index]['startdate'],
//           starttime:  maps[index]['starttime'],
//           enddate: maps[index]['enddate'] ,
//           endtime:  maps[index]['endtime'] ,
//           clientcourt: maps[index]['clientcourt'],
//           lastappointdate: maps[index]['lastappointdate'],
//           userid: maps[index]['userid'],
//           );
//     }
//    );
//   }

  Future<int> updateClient(Client client) async {
    await openDB();
    return await _datebase.update('client', client.toMap(),
        where: 'id=?', whereArgs: [client.id]);
  }

  Future<void> deleteClient(int id) async {
    await openDB();
    await _datebase.delete("client", where: "id = ? ", whereArgs: [id]);
  }
    Future<int> insertClient1(Clienthistory clienthistory) async {
    await openDB();
    return await _datebase.insert('clienthistory', clienthistory.toMap());
  }
  //  for(int i=0;i<100;i++){
  // await _datebasehistory.insert('clienthistory', clienthistory.toMap());
String userid1;
 Future<List<Clienthistory>> gethistorydata() async {
    SharedPreferences _localstorage = await SharedPreferences.getInstance();

    userid=  _localstorage.getString('userid');
    await openDB();
    if(userid==null){
return null;
    }
    final List<Map<String, dynamic>> maps = await _datebase.query('clienthistory',
  
     );
  // _localstorage.setString('filepath',  _datebasehistory.path);
    return List.generate(maps.length, (index) {
      return Clienthistory(
          clienthistoryid: maps[index]['clienthistoryid'],
          clienttitle: maps[index]['clienttitle'],
          clientphonenumber: maps[index]['clientphonenumber'],
     appointdate: maps[index]['appointdate'],
          clientcourt: maps[index]['clientcourt'],
          lastappointdate: maps[index]['lastappointdate'],
          clientid: maps[index]['clientid']
          
          );
    }
   );
  }
  
  Future<List<Clienthistory>> gethistorydata1(String setid) async {
    SharedPreferences _localstorage = await SharedPreferences.getInstance();

    userid=  _localstorage.getString('userid');
    await openDB();
    if(userid==null){
return null;
    }
    final List<Map<String, dynamic>> maps = await _datebase.query('clienthistory',
    where:'clientid=$setid',orderBy: 'clienthistoryid desc'
     );

    return List.generate(maps.length, (index) {
      return Clienthistory(
          clienthistoryid: maps[index]['clienthistoryid'],
          clienttitle: maps[index]['clienttitle'],
          clientphonenumber: maps[index]['clientphonenumber'],
     appointdate: maps[index]['appointdate'],
          clientcourt: maps[index]['clientcourt'],
          lastappointdate: maps[index]['lastappointdate'],
          clientid: maps[index]['clientid']
          
          );
    }
   );
  }

  Future<int> updateClient1(Clienthistory clienthistory) async {
    await openDB();
    return await _datebase.update('clienthistory', clienthistory.toMap(),
        where: 'id=?', whereArgs: [clienthistory.clienthistoryid]);
  }

  Future<void> deleteClient1(int id) async {
    await openDB();
    await _datebase.delete("clienthistory", where: "id = ? ", whereArgs: [id]);
  }
}

class Client {
  int id;
  String clientname;
  String clientphonenumber;
  String clientaddress;
  String clientage;
  String startdate;
  String starttime;
  String enddate;
  String endtime;
  String clientcourt;
  String lastappointdate;
  String userid;
  Client({ @required this.clientname, @required this.clientphonenumber,this.clientaddress,this.clientage,this.id,this.startdate,this.starttime,this.enddate,this.endtime,this.clientcourt,this.lastappointdate,this.userid});
  Map<String, dynamic> toMap() {
    return {'clientname': clientname, 'clientphonenumber': clientphonenumber,
    'clientaddress':clientaddress,'clientage':clientage,
    'startdate':startdate,'starttime':starttime,'enddate':enddate,'endtime':endtime,
    'clientcourt':clientcourt,'lastappointdate':lastappointdate,'userid':userid
    };
  }
}
 class Clienthistory {
  int clienthistoryid;
  String clienttitle;
  String clientphonenumber;
  String appointdate;
  String clientcourt;
  String lastappointdate;
  int clientid;
  Clienthistory({ @required this.clienttitle, 
  @required this.clientphonenumber,this.clienthistoryid,
  this.appointdate,this.clientcourt,
  this.lastappointdate,this.clientid});

  Map<String, dynamic> toMap() {
    return {
      'clienttitle': clienttitle, 
    'clientphonenumber': clientphonenumber,
  'appointdate':appointdate,
    'clientcourt':clientcourt,
    'lastappointdate':lastappointdate,
    'clientid':clientid};
  }
}