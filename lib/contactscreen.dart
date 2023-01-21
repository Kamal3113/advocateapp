import 'dart:async';
import 'dart:io' as io;

import 'package:contacts_service/contacts_service.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqladvocate/contactlist.dart';
import 'package:sqladvocate/clientdetail.dart';
import 'package:sqladvocate/database.dart';
import 'package:sqladvocate/detailpage.dart';
import 'package:sqladvocate/nodlete.dart';
import 'package:sqladvocate/testclien.dart';

class ContactScreen extends StatefulWidget {
  final Client getclientdata;
 DateTime datetime;
  ContactScreen({this.datetime,this.getclientdata});
  @override
  _State createState() => new _State();
}

class _State extends State<ContactScreen> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation colorAnimation;
  Animation rotateAnimation;
  TextEditingController searchController = new TextEditingController();
  DeviceCalendarPlugin _deviceCalendarPlugin;
  _State() {
    _deviceCalendarPlugin = DeviceCalendarPlugin();
  }
  List<ConatctList> _contactList;
  String filter;
  List<Calendar> _calendars;
  int curUserId;
  final formKey = new GlobalKey<FormState>();
  var dbHelper;
  bool isUpdating;
  Iterable<Contact> _contacts;
  static Database _db;
  static const String DB_NAME = 'contacts.db';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }
  void _retrieveCalendars() async {
    var calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
    setState(() {
      _calendars = calendarsResult?.data;
    });
    
  }
  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $NAME TEXT,$PHONE TEXT,$EMAIL TEXT,$MIDDLENAME TEXT)");
  }

  @override
  void initState() {
    super.initState();
     _retrieveCalendars();   
// employees= _query();
    allContact();
    _query();
//delete();
  
    _contactList = employeeslist;
    searchController.addListener(() {
      setState(() {
        filter = searchController.text;
      });
    });
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 200));
    rotateAnimation = Tween<double>(begin: 0.0, end: 360.0).animate(controller);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  static const String TABLE = 'contacts';
  static const String ID = 'id';
  static const String NAME = 'name';
  static const String PHONE = 'phone';
  static const String EMAIL = 'email';
  static const String MIDDLENAME = 'middlename';
  String phone;
  String id;
  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }

  bool delete1 = false;
  List<Contact> _contact = [];

  refreshContacts() async {
    var dbClient = await db;
// dbClient.delete("contacts");
// return;
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      List<Contact> contacts = (await ContactsService.getContacts()).toList();
      contacts.length;
      setState(() {
        _contact = contacts;
      });

      _contact.forEach((item) {
// db.execute("CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $NAME TEXT)");

        if (item.phones.length > 0) {
          try {
            var table =
                ("INSERT or REPLACE INTO $TABLE ( $ID , $NAME ,$PHONE ,$EMAIL ,$MIDDLENAME ) VALUES ( ${item.identifier},'${item.displayName}','${item.phones.first.value}','${item.birthday}','${item.middleName}')");
// db.execute(table);
            dbClient.transaction((txn) async {
              print(table);
              return await txn.rawInsert(table);
// return table;
            });
          } catch (e) {
            print(e);
          }
        }
      });

      var result = _query();
      result.then((resultat) {
        setState(() {
          employeeslist = resultat;
        });
      });
    } else {
      _handleInvalidPermissions(permissionStatus);
    }
  }

  void allContact() {
    refreshContacts();
  }

  List<ConatctList> employeeslist;

  Future<List<ConatctList>> _query() async {
    Database db = await this.db;
    List<Map> maps = await db.query(TABLE, orderBy: '$NAME ASC');
    List<ConatctList> employees = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        employees.add(ConatctList.fromMap(maps[i]));
      }
    }
    return employees;
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.contacts);
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.disabled) {
      Map<PermissionGroup, PermissionStatus> permissionStatus =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.contacts]);
      return permissionStatus[PermissionGroup.contacts] ??
          PermissionStatus.unknown;
    } else {
      return permission;
    }
  }
List data;
  int count = 0;
// Managing error when you don't have permissions
  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      throw new PlatformException(
          code: "PERMISSION_DENIED",
          message: "Access to location data denied",
          details: null);
    } else if (permissionStatus == PermissionStatus.disabled) {
      throw new PlatformException(
          code: "PERMISSION_DISABLED",
          message: "Location data is not available on device",
          details: null);
    }
  }

  Future<bool> syncDatabaseFull() async {
    await Future.delayed(Duration(seconds: 5), () {
      refreshContacts();
    });
 return Future.value(true);
  }

  bool delete11 = false;
  delete() async {
    var dbClient = await db;
    dbClient.delete('contacts');
    return refreshContacts();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.white,
        title: new Text(
          "Contacts List",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: <Widget>[
          AnimatedSync(
            animation: rotateAnimation,
            callback: () async {
              controller.forward();
              await syncDatabaseFull();
              controller.stop();
              controller.reset();
            },
          ),
// IconButton(
// icon: Icon(
// Icons.delete,
// ),
// onPressed: () => delete(),
// )
        ],
      ),
      body: new Container(
        padding: new EdgeInsets.all(32.0),
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              TextFormField(
                controller: searchController,
                decoration: InputDecoration(labelText: 'Search'),
              ),
              SizedBox(
                height: 2,
              ),
              Expanded(
                child: FutureBuilder(
                  future: _query(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return new Text('waiting');
                      case ConnectionState.waiting:
                        return Scaffold(
                          body: Center(
                            child: new CircularProgressIndicator(),
                          ),
                        );

                      default:
                        if (snapshot.hasData) {
// Start from here without cases=====>>
                          if (employeeslist != null) {
                            print(employeeslist.length);
                            return ListView.builder(
                                itemCount: employeeslist.length,
                                itemBuilder: (context, index) {
                                  ConatctList cat = employeeslist[index];
                                 // final data = {null, cat,widget.datetime,null,};
                                 
                                  return filter == null || filter == ''
                                      ? Container(
                                          child: ListTile(
                                          title: Text(cat.name),
                                          subtitle: Text(cat.phone),
                                          
                                          onTap: () {
                                          //   List data = [null,cat,widget.datetime,null];
                                          //  Navigator.of(context).pop(data);
                                           Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                //   return
                                                //  ClientAddScreen(
                                                //              widget.getclientdata, cat,widget.datetime,null,null,null);
                                                  ClientAddScreen2(null,cat,0,widget.datetime,_calendars[0],)
                                                
                                             ),
                                          );
 }
                                         ))
                                      : cat.name.toLowerCase().contains(filter)
                                          ? new Container(
                                              child: ListTile(
                                              title: Text(cat.name),
                                              subtitle: Text(cat.phone),
                                              onTap: () {
                                          //       List data = [null,cat,widget.datetime,null];
                                          //  Navigator.of(context).pop(data);
                          Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                   ClientAddScreen2(null,cat,0,widget.datetime,_calendars[0],)
                                                        // ClientAddScreen(
                                                        //     widget.getclientdata, cat,widget.datetime,null,null,null)
                                                            ),
                                              );
                                              }
                                           ))
                                          : new Container();
                                });
                          } else {
                            return Text('no data');
                          }
// end Here========>>>>
                        }
                    }
                  },
                ),
              ),
// Text(
// // 'Total Contacts : ${employeeslist.length.toString()}',
// style: TextStyle(fontWeight: FontWeight.bold),
// ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedSync extends AnimatedWidget {
  VoidCallback callback;
  AnimatedSync({Key key, Animation<double> animation, this.callback})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Transform.rotate(
      angle: animation.value,
      child: IconButton(
          icon: Icon(
            Icons.sync,
            color: Colors.black,
          ),
          onPressed: () => callback()),
    );
  }
}
