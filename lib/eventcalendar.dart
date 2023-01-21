import 'dart:async';
import 'dart:io';

import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqladvocate/color.dart';
import 'package:sqladvocate/contactlist.dart';
import 'package:sqladvocate/database.dart';
import 'package:sqladvocate/historydatabase.dart';
import 'package:sqladvocate/historylist.dart';
import 'package:sqladvocate/login.dart';
import 'package:sqladvocate/nodlete.dart';
import 'package:table_calendar/table_calendar.dart';

class EventScreen extends StatefulWidget {
  final List clientdata;
  //  final BaseAuth auth;
  //     final VoidCallback onSignedOut;
  EventScreen({this.clientdata});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<EventScreen> {
  CalendarController _controller;
  Map<DateTime, List<dynamic>> _events;
  Map<DateTime, List> dotappointments;
  List<Calendar> _calendars;
  Calendar _calendar;
  DeviceCalendarPlugin _deviceCalendarPlugin;
  _HomePageState() {
    _deviceCalendarPlugin = DeviceCalendarPlugin();
  }
  List getdata;
  var getappointmentlist;
  List<dynamic> _selectedEvents;
  Timer _timer;
  ConatctList _conatctList;
  final DBClientManager dbclientManager = new DBClientManager();
  // final DBClienthistoryManager dbclienthistoryManager =
  //     new DBClienthistoryManager();
  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    dotappointments = {};
    _selectedEvents = [];
    _retrieveCalendars();
    _setlocalname();
  }

  void _retrieveCalendars() async {
    var calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
    setState(() {
      _calendars = calendarsResult?.data;
    });
  }

  String localusername;
  String localpath;
  _setlocalname() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      localusername = preferences.getString("name");
      localpath = preferences.getString("filepath");
      // share();
    });
    print(localusername);
    print(localpath);
  }

  var selectdDate;
  // final DBClienthistoryManager dbhistoryclientManager =
  //     new DBClienthistoryManager();
  bool _login;
  dialogbox() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //title: Text('Not in stock'),
          content: const Text('Are you sure want to logout'),
          actions: [
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                // Navigator.of(context).pop();
                signout();
              },
            ),
          ],
        );
      },
    );
  }

  var gethistorydata;
  // Clienthistory gethisdata;
  Client gethisdata;
  void signout() async {
    setState(() {});
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    setState(() {
      _login = false;
    });
    localStorage.remove('userid');
    localStorage.setBool("checklogin", _login);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => Loginpage()),
        (Route<dynamic> route) => false);
  }
   _files() async {
    var root = await getExternalStorageDirectory();
    var files = await FileManager(root: root).walk().toList();

    for(var i = 0;i<files.length;i++) {
      print("${files[i].path} ");
    }
      return files;
  }
//  share() async {
// Directory dir = await getApplicationDocumentsDirectory();
// File testFile = new File("${localpath}/clienthistory.db");
//  final RenderBox box = context.findRenderObject() as RenderBox;

//   // localpath/"clienthistory.db");
// if (!await testFile.exists()) {
// await testFile.create(recursive: false);
// testFile.writeAsStringSync("test for share documents file");
// }
//   ShareExtend.share(testFile.path,'file',
//   sharePositionOrigin: box.localToGlobal(Offset.zero)& box.size
//   );
// }
  var _datebasehistory;
  _onShare(BuildContext context) async {
    Directory dir = await getApplicationDocumentsDirectory();
    File testFile = new File("${localpath}/clienthistory.db");
    final RenderBox box = context.findRenderObject() as RenderBox;
    _datebasehistory = await openDatabase(
      p.join(dir.path, "clienthistory.db"),
    );
    Share.share(localpath
        // _datebasehistory,
        );
  }

  bool okay = false;
  List acdate1 = [];
  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        // color: Color(0xFF1B2B33),
        child: new Container(
            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(40.0),
                  topRight: const Radius.circular(40.0),
                )),
            padding: EdgeInsets.only(
              top: 0,
            ),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 73,
                        width: 40,
                        decoration: new BoxDecoration(
                            color: topcenterlogin,
                            borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(40.0),
                              topRight: const Radius.circular(40.0),
                            )),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'APPOINTMENT',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              SizedBox(width: 60),
                              Text(
                                localusername == null
                                    ? 'loading'
                                    : localusername,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17),
                              ),
                              SizedBox(
                                width: 1,
                              ),
                              IconButton(
                                  icon: Icon(Icons.power_settings_new),
                                  onPressed: () {
                                    dialogbox();
                                  }),
                              SizedBox(
                                width: 1,
                              ),
                              IconButton(
                                  icon: Icon(Icons.history),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Historylist()));
                                  }),
                              IconButton(
                                  icon: Icon(Icons.drive_file_move),
                                  onPressed: () {
                                    _files();
                                  //  _onShare(context);
                                    // share();
                                  }),
                            ]),
                      ),
                    ]),
                FutureBuilder(
                  future: dbclientManager.getclientList(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      getdata = snapshot.data as List;
                      Map<DateTime, List<dynamic>> data = {};
                      try {
                        // dotappointments = Map.fromIterable(getdata,
                        // key: (e) => DateTime.parse(e.appointdate),
                        // value: (e) => ["empty"]);

                        Map<DateTime, List<dynamic>> data = {};
                        getdata.forEach((e) {
                          DateTime date = DateTime.parse(e.startdate);
                          if (data[date] == null) data[date] = [];
                          data[date].add(e.startdate);
                          dotappointments = data;

                          return dotappointments;
                        });
                      } catch (e) {}
                    }
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TableCalendar(
                           startDay: DateTime.now(),
                            events: dotappointments,
                            initialCalendarFormat: CalendarFormat.month,
                            calendarStyle: CalendarStyle(
                                canEventMarkersOverflow: true,
                                todayColor: Colors.orange,
                                selectedColor: Theme.of(context).primaryColor,
                                todayStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                    color: Colors.white)),
                            headerStyle: HeaderStyle(
                              centerHeaderTitle: true,
                              formatButtonDecoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              formatButtonTextStyle:
                                  TextStyle(color: Colors.white),
                              formatButtonShowsNext: false,
                            ),
                            startingDayOfWeek: StartingDayOfWeek.monday,
                            onDaySelected: (date, events, _) {
                          
if(events.length==0){

                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                              
                                                    ClientAddScreen2(
                                                                         null,
                                                                          _conatctList,

                                                                          null,
                                                                            _controller.selectedDay,
                                                                         _calendars[0]

                                                                        )
                                                
                                                      ));
}
else{
  setState(() {
                                _selectedEvents = getdata;
                              });
}

                            

                            },
                            builders: CalendarBuilders(
                              selectedDayBuilder: (context, date, events) =>
                                  Container(
                                      margin: const EdgeInsets.all(4.0),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      child: Text(
                                        date.day.toString(),
                                        style: TextStyle(color: Colors.white),
                                      )),
                              todayDayBuilder: (context, date, events) =>
                                  Container(
                                      margin: const EdgeInsets.all(4.0),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Colors.orange,
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      child: Text(
                                        date.day.toString(),
                                        style: TextStyle(color: Colors.white),
                                      )),
                            ),
                            calendarController: _controller,
                          ),
                            Padding(padding: EdgeInsets.only(top:5,left: 10,right: 10),
                        child:
  Divider(
                                                              height: 2,
                                                              color:
                                                                  Colors.black),),
                          // Text(
                          //     '----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'),
                          // ..._selectedEvents.map((event) => Card(
                          //  child:
                             SingleChildScrollView(
                              child: Container(
                                  height: 330,
                                  child: FutureBuilder(
                                    future: dbclientManager.getclientList(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        var getdata = snapshot.data;
                                        List acdate = [];
                                        var selectDate =
                                            DateFormat('yyyy-MM-dd').format(
                                                _controller.selectedDay);
                                        
                                   
                                        for (int i = 0;
                                            i < getdata.length;
                                            i++) {
                                          if (getdata[i].startdate ==
                                              selectDate) {
                                            acdate.add(getdata[i]);
                                            print(acdate);
                                          }
                                       
                                        }
                                        if (acdate.length != 0) {
                                          return ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: acdate == null
                                                ? 0
                                                : acdate.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              setdata = acdate[index];
                                            
                                              return GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              //                                          ClientAddScreen2(
                                                              //  DateTime.now(),_calendars[0],
                                                              // )
                                                              //     ClientAddScreen(getdata[index],null,null,setdata.id,null,gethistorydata[index])
                                                              ClientAddScreen2(
                                                                  acdate[
                                                                      index],
                                                                  _conatctList,
                                                                  setdata.id,
                                                                  null,
                                                                  _calendars[
                                                                      0])));
                                                },
                                                child: Column(
                                                  children: <Widget>[
                                                    ListTile(
                                                      title: Text(
                                                        setdata.clientname ==
                                                                null
                                                            ? ""
                                                            : setdata
                                                                .clientname,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      subtitle: Text(
                                                        setdata.clientcourt ==
                                                                null
                                                            ? ""
                                                            : setdata
                                                                .clientcourt,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      leading: checkcolor(
                                                          setdata.clientcourt),
                                                      trailing: Text(
                                                        setdata.startdate ==
                                                                null
                                                            ? ""
                                                            : setdata.startdate,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        } 
                                      
                                      

                                      }

                                      return Text('');
                                      //  Center(
                                      //   child: CircularProgressIndicator(),
                                      // );
                                    },
                                  ))),
                           


                          FutureBuilder(
                           //   future: dbclienthistoryManager.gethistorydata(),
                            future: dbclientManager.getclientList(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  gethistorydata = snapshot.data;
                                }
                                return Text('');
                              }),

                        ],
                      ),
                    );
                  },
                ),
              ],
            )),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
          ),
          backgroundColor: topcenterlogin,
          onPressed: () {
           Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ClientAddScreen2(
                        null,
                        _conatctList,
                        0,
                        DateTime.now(),
                        _calendars[0],
                      )
                 
                  )
                  );}
                  ),
    );
  }

  DateTime current = DateTime.now();
  Client setdata;
  checkcolor(String courtname) {
    if (courtname == 'Highcourt') {
      return Icon(Icons.circle, color: Colors.green);
    } else if (courtname == 'Supreme Court') {
      return Icon(
        Icons.circle,
        color: Colors.red,
      );
    } else if (courtname == 'Dist.court/Tribunals/Commissions') {
      return Icon(Icons.circle, color: Colors.blue);
    } else if (courtname == 'Appointments/Meetings/Time') {
      return Icon(Icons.circle, color: Colors.purple);
    }
  }
}
