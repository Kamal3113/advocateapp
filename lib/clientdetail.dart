// import 'dart:async';
// import 'dart:ui';
// import 'package:firebase_core/firebase_core.dart';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'package:sqladvocate/color.dart';
// import 'package:sqladvocate/contactlist.dart';
// import 'package:sqladvocate/contactscreen.dart';
// import 'package:sqladvocate/database.dart';
// import 'package:sqladvocate/datetime.dart';
// import 'package:sqladvocate/datetime1.dart';
// import 'package:sqladvocate/eventcalendar.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:sqladvocate/historydatabase.dart';

// class ClientAddScreen extends StatefulWidget {
//   final Client getclientdata;
//   final Clienthistory gethistorydata;
//   final ConatctList contact;
//   final int appoint_id;
//   DateTime dateTime;
//   DateTime dateTime1;
//   ClientAddScreen(this.getclientdata, this.contact, this.dateTime,
//       this.appoint_id, this.dateTime1,this.gethistorydata);
//   @override
//   _ClientAddScreenState createState() => _ClientAddScreenState();
// }

// class Item {
//   const Item(this.name, this.icon);
//   final String name;
//   final Icon icon;
// }

// class _ClientAddScreenState extends State<ClientAddScreen> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
//   String dropdownValue = 'Highcourt';
//   String name;
//   List users = [
//     const Item(
//         'Highcourt',
//         Icon(
//           Icons.add_circle,
//           color: Colors.green,
//         )),
//     const Item(
//         'Supreme Court',
//         Icon(
//           Icons.add_circle,
//           color: Colors.red,
//         )),
//     const Item(
//         'Dist.court/Tribunals/Commissions',
//         Icon(
//           Icons.add_circle,
//           color: Colors.blue,
//         )),
//     const Item(
//         'Appointments/Meetings/Time',
//         Icon(
//           Icons.add_circle,
//           color: Colors.yellow,
//         )),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     getText();
//     getlocaldata();
//     //  settimenotification();
//     if (widget.dateTime == null) {
//       widget.dateTime = DateTime.parse(widget.getclientdata.appointdate);
//       // DateTime.now();
//     }

//     if (widget.dateTime1 == null) {
//       widget.dateTime1 =
//           //DateTime.parse(widget.getclientdata.appointdate)
//           DateTime.now();
//     }
//     flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
//     var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
//     var iOS = new IOSInitializationSettings();
//     var initSetttings = new InitializationSettings(android: android, iOS: iOS);
//     flutterLocalNotificationsPlugin.initialize(initSetttings,
//         onSelectNotification: onSelectNotification);
//   }

//   Future onSelectNotification(String payload) {
//     debugPrint("payload : $payload");
//     showDialog(
//       context: context,
//       builder: (_) => new AlertDialog(
//         title: new Text('Notification'),
//         content: new Text('$payload'),
//       ),
//     );
//   }

//   final _dayFormatter = DateFormat('d');
//   final _monthFormatter = DateFormat('MMM');
//   final dates = <Widget>[];
//   final DBClientManager dbclientManager = new DBClientManager();
//  final DBClienthistoryManager dbclienthistoryManager = new DBClienthistoryManager();
//   settimenotification() {
//     for (int i = 0; i < widget.getclientdata.appointdate.length; i++) {
//       final date = todaydate.add(Duration(days: i));
//       dates.add(Column(
//         children: [
//           Text(_dayFormatter.format(date)),
//           Text(_monthFormatter.format(date)),
//         ],
//       ));
//       print(_dayFormatter.format(date));
//     }
//   }

//   var scheduledNotificationDateTime =
//       new DateTime.now().add(new Duration(seconds: 5));
//   showNotification() async {
//     var android = new AndroidNotificationDetails(
//         'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
//         priority: Priority.high, importance: Importance.max);
//     var iOS = new IOSNotificationDetails();
//     var platform = new NotificationDetails(android: android, iOS: iOS);
//     await flutterLocalNotificationsPlugin.schedule(
//         0,
//         clientname.text,
//         DateFormat('yyyy-MM-dd').format(widget.dateTime),
//         scheduledNotificationDateTime,
//         platform,
//         payload: 'Nitish Kumar Singh is part time Youtuber');
//   }

//   void updateInformation(DateTime settime) {
//     if (settime != null) {
//       setState(() => widget.dateTime = settime);
//     }
//   }

//   void updateInformation1(DateTime newsettime) {
//     if (newsettime != null) {
//       setState(() => widget.dateTime1 = newsettime);
//     }
//   }

//   void moveToSecondPage() async {
//     DateTime selected_datetime = await Navigator.push(
//       context,
//       CupertinoPageRoute(
//           fullscreenDialog: true,
//           builder: (context) =>
//               Dateselect(appointment_datetime: widget.dateTime)),
//     );
//     updateInformation(selected_datetime);
//   }

//   bool changenewdate = false;
//   void moveTofirstPage1() async {
//     DateTime selected_datetime1 = await Navigator.push(
//         context,
//         CupertinoPageRoute(
//             fullscreenDialog: true,
//             builder: (context) =>
//                 Dateselect1(appointment_datetime1: widget.dateTime)));
//     updateInformation1(selected_datetime1);
//   }

//   String userId;
//   String username;
//   String usertoken;
//   String userlocalemail;
//   getlocaldata() async {
//     SharedPreferences _localstorage = await SharedPreferences.getInstance();

//     userId = _localstorage.getString('userid');
//     username = _localstorage.getString('name');
//     usertoken = _localstorage.getString('apptoken');
//     userlocalemail = _localstorage.getString('email');
//     print(userId);
//     print(username);
//     print(usertoken);
//     print(userlocalemail);
//   }

//   void getText() async {
//     setState(() {
//       clientphonenumber = new TextEditingController(
//           text: widget.contact == null
//               ? widget.getclientdata.clientphonenumber
//               : widget.contact.phone);
//       clientname = new TextEditingController(
//           text: widget.getclientdata == null
//               ? ''
//               : widget.getclientdata.clientname);
//       clientaddress = new TextEditingController(
//           text: widget.getclientdata == null
//               ? ''
//               : widget.getclientdata.clientaddress);
//       clientage = new TextEditingController(
//           text: widget.getclientdata == null
//               ? ''
//               : widget.getclientdata.clientage);
//       clientappointdate = new TextEditingController(
//           text: widget.getclientdata == null
//               ? ''
//               : widget.getclientdata.appointdate);
//     });
//   }

//   final _formkey = new GlobalKey<FormState>();
//   Client client;
//   int updateindex;

//   List<Client> clientlist;
//   TextEditingController clientname = new TextEditingController();
//   TextEditingController clientphonenumber = new TextEditingController();
//   TextEditingController clientaddress = new TextEditingController();
//   TextEditingController clientage = new TextEditingController();
//   TextEditingController clientappointdate = new TextEditingController();

//   String _validateTitle(String value) {
//     if (value.isEmpty) {
//       return 'Name is required.';
//     }
//     return null;
//   }

//   Timer _timer;
//   DateTime selectedDate = DateTime.now();
//   String courtname;
//   String _selectedDate = '';
//   dialogbox() {
//     return showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(32.0))),
//             title: Column(
//               children: <Widget>[
//                 Container(
//                   child: Text('CONFIRMATION'),
//                 ),
//                 Divider(color: Colors.black),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Container(
//                     width: 200.0,
//                     height: 100.0,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(67),
//                     ),
//                     child: Text(
//                       'Are you sure to delete this appointment',
//                       style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 15,
//                           fontWeight: FontWeight.w600),
//                       textAlign: TextAlign.center,
//                     )),
//               ],
//             ),
//             content: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: <Widget>[
//                 RaisedButton(
//                     color: Colors.grey,
//                     child: Text(
//                       'YES',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                     onPressed: () async {
//                       dbclientManager.deleteClient(widget.appoint_id);
//                       Navigator.of(context).pushAndRemoveUntil(
//                           MaterialPageRoute(
//                               builder: (BuildContext context) => EventScreen()),
//                           (Route<dynamic> route) => false);
//                     }),
//                 RaisedButton(
//                     color: topcenterlogin,
//                     child: Text(
//                       'NO',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                     onPressed: () {
//                       Navigator.pop(context);
//                     })
//               ],
//             ),
//           );
//         });
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime d = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(1900),
//       lastDate: DateTime(2040),
//     );
//     if (d != null)
//       setState(() {
//         _selectedDate = new DateFormat.yMMMMd("en_US").format(d);
//       });
//   }

//   checkcolor(String courtname) {
   
//         if (courtname == 'Highcourt') {
//       return TextStyle(color: Colors.green);
//     } else if (courtname == 'Supreme Court') {
//       return TextStyle(color: Colors.red);
//     } else if (courtname == 'Dist.court/Tribunals/Commissions') {
//       return TextStyle(color: Colors.blue);
//     } else if (courtname == 'Appointments/Meetings/Time') {
//       return TextStyle(color: Colors.yellow);
//     }
  
//     }
  
// checksimplecolor() {
//     if (dropdownValue == 'Highcourt') {
//       return TextStyle(color: Colors.green);
//     } else if (dropdownValue == 'Supreme Court') {
//       return TextStyle(color: Colors.red);
//     } else if (dropdownValue == 'Dist.court/Tribunals/Commissions') {
//       return TextStyle(color: Colors.blue);
//     } else if (dropdownValue == 'Appointments/Meetings/Time') {
//       return TextStyle(color: Colors.yellow);
//     }
//   }
//   nextdate(String nextdate) {
//     if (nextdate == DateFormat('yyyy-MM-dd').format(todaydate)) {
//       return Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: <Widget>[
//           Padding(
//               padding: EdgeInsets.only(top: 10, right: 10),
//               child: InkWell(
//                 child: Container(
//                   height: 40,
//                   width: 130,
//                   decoration: BoxDecoration(
//                       border: Border.all(width: 2, color: Colors.grey)),
//                   child: Padding(
//                       padding: EdgeInsets.only(top: 10),
//                       child: Text(
//                         DateFormat('yyyy-MM-dd').format(widget.dateTime1),
//                         textAlign: TextAlign.center,
//                         style: widget.getclientdata == null
//                             ? checksimplecolor()
//                             : checkcolor(widget.getclientdata.clientcourt),
//                         //  TextStyle(
//                         //     color: Color(
//                         //         0xFF000000))
//                       )),
//                 ),
//                 //  onTap: () {
//                 //     moveToSecondPage();
//                 //   },
//               )),
//           IconButton(
//             icon: Icon(Icons.calendar_today),
//             tooltip: 'Tap to open date picker',
//             onPressed: () {
//               moveTofirstPage1();
//               setState(() {
//                 changenewdate = true;
//               });
//             },
//           ),
//         ],
//       );
//     } else {
//       return Text('');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     return Scaffold(
//         bottomNavigationBar: RaisedButton(
//             child: Text(
//               'SAVE',
//               style: TextStyle(fontSize: 19, color: Colors.white),
//             ),
//             color: topcenterlogin,
//             onPressed: () {
//               submitStudent(context);
//               setdatafirestore();
//               //     showNotification();
//             }),
//         // appBar:AppBar(title: Text('Client Details'),) ,
//         body: SingleChildScrollView(
//           child: Stack(
//             children: <Widget>[
//               Container(
//                 height: MediaQuery.of(context).size.height / 1.0,
//                 color: Colors.white,
//                 child: Stack(
//                   children: <Widget>[
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: <Widget>[
//                         Padding(
//                           padding: EdgeInsets.only(top: 0, left: 0),
//                           child: Image(
//                             height: 250.0,
//                             width: 450.0,
//                             image: AssetImage('assest/advt.jpeg'),
//                             fit: BoxFit.contain,
//                           ),
//                         ),
//                       ],
//                     ),
//                     // Padding(
//                     //   padding: EdgeInsets.only(top: 0, left: 0),
//                     //   child: Image(
//                     //     height: 250.0,
//                     //     width: 400.0,
//                     //     image: AssetImage('assets/Logo_new.png'),
//                     //     fit: BoxFit.contain,
//                     //   ),
//                     // ),
//                     Padding(
//                       padding: EdgeInsets.only(top: 140, bottom: 10),
//                       child: new Container(
//                           decoration: new BoxDecoration(
//                               boxShadow: [
//                                 new BoxShadow(
//                                   color: Colors.black,
//                                   blurRadius: 20.0,
//                                 ),
//                               ],
//                               color: Colors.white,
//                               borderRadius: new BorderRadius.only(
//                                 topLeft: const Radius.circular(40.0),
//                                 topRight: const Radius.circular(40.0),
//                                 bottomLeft: const Radius.circular(1.0),
//                                 bottomRight: const Radius.circular(1.0),
//                               )),
//                           padding:
//                               EdgeInsets.only(top: 30, left: 40, right: 40),
//                           child: new Column(
//                             // crossAxisAlignment: CrossAxisAlignment.stretch,
//                             // mainAxisAlignment: MainAxisAlignment.start,
//                             children: <Widget>[
//                               Row(
//                                 children: [
//                                   Container(
//                                     padding:
//                                         EdgeInsets.only(left: 80, bottom: 20),
//                                     child: Text(
//                                       'Case details',
//                                       style: TextStyle(
//                                           fontSize: 25, color: Colors.black),
//                                     ),
//                                   ),
//                                   Padding(
//                                       padding:
//                                           EdgeInsets.only(bottom: 20, left: 35),
//                                       child: widget.appoint_id == null
//                                           ? Container()
//                                           : IconButton(
//                                               icon: Icon(
//                                                 Icons.delete,
//                                                 color: topcenterlogin,
//                                               ),
//                                               onPressed: () {
//                                                 dialogbox();
//                                                 //                     Navigator.of(context).pushAndRemoveUntil(
//                                                 // MaterialPageRoute(
//                                                 //     builder: (BuildContext context) =>
//                                                 //        EventScreen()),
//                                                 // (Route<dynamic> route) => false);
//                                               }))
//                                 ],
//                               ),
//                               Form(
//                                 key: _formKey,
//                                 child: Column(
//                                   children: <Widget>[
//                                     TextFormField(
//                                       controller: clientphonenumber,
//                                       keyboardType: TextInputType.number,
//                                       style: widget.getclientdata == null
//                                           ? checksimplecolor()
//                                           : checkcolor(
//                                               widget.getclientdata.clientcourt),
//                                       maxLength: 15,
//                                       decoration: new InputDecoration(
//             //                              focusedBorder: OutlineInputBorder(
//             //     borderSide: BorderSide(color: Colors.black, width: 1.0),
//             // ),
//                                           suffixIcon: IconButton(
//                                             icon: Icon(
//                                               Icons.call,
//                                               color: Colors.grey[600],
//                                             ),
//                                             onPressed: () =>
//                                                 Navigator.pushReplacement(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                         builder: (context) =>
//                                                             ContactScreen(
//                                                               getclientdata: widget
//                                                                   .getclientdata,
//                                                               datetime: widget
//                                                                   .dateTime,
//                                                             ))),
//                                           ),
//                                           filled: true,
                                         
//                                           labelText: 'Phone Number',
//                                           border: new OutlineInputBorder(
//                                             borderRadius:
//                                                 new BorderRadius.vertical(),
//                                           )),
//                                       validator: (value) {
//                                         if (value.length == 0) {
//                                           return "Please enter phonenumber";
//                                         } else if (value.length <= 9) {
//                                           return "Please enter valid phonenumber";
//                                         } else {
//                                           return null;
//                                         }
//                                       },
//                                       onSaved: (value) => name = value,
//                                     ),
//                                     SizedBox(
//                                       height: 10.0,
//                                     ),
//                                     TextFormField(
//                                       //  key: Key('titleField'),
//                                       controller: clientname,
//                                       style: widget.getclientdata == null
//                                           ?checksimplecolor()
//                                           : checkcolor(
//                                               widget.getclientdata.clientcourt),
//                                       keyboardType: TextInputType.emailAddress,
//                                       decoration: new InputDecoration(
//             //                                    focusedBorder: OutlineInputBorder(
//             //     borderSide: BorderSide(color: Colors.black, width: 1.0),
//             // ),
//                                           filled: true,
//                                           labelText: 'Title',
//                                           border: new OutlineInputBorder(
//                                             borderRadius:
//                                                 new BorderRadius.vertical(),
//                                           )),
//                                       validator: (value) {
//                                         if (value.length == 0) {
//                                           return "Please enter title";
//                                         } else {
//                                           return null;
//                                         }
//                                       },
//                                       onSaved: (value) => name = value,
//                                     ),
//                                     SizedBox(
//                                       height: 10.0,
//                                     ),
//                                     TextFormField(
//                                       controller: clientage,
//                                       style: widget.getclientdata == null
//                                           ? checksimplecolor()
//                                           : checkcolor(
//                                               widget.getclientdata.clientcourt),
//                                       keyboardType: TextInputType.emailAddress,
//                                       maxLines: 5,
//                                       maxLength: 350,
//                                       decoration: new InputDecoration(
//                                           filled: true,
//             //                                      focusedBorder: OutlineInputBorder(
//             //     borderSide: BorderSide(color: Colors.black, width: 1.0),
//             // ),
// //                                             suffixIcon: IconButton(
// //                                                 icon:
// //                                                     Icon(Icons.calendar_today,color: Colors.grey[600],),
// //                                                 onPressed:(){
// //                                              Navigator.push(
// //                                                 context,
// //                                                 MaterialPageRoute(
// //                                                     builder: (context) =>
// //                                                         Dateselect(

// //                                                         )));
// //                                                 }  ),
//                                           labelText: 'Proceeding',
//                                           border: new OutlineInputBorder(
                                            
//                                             borderRadius:
//                                                 new BorderRadius.vertical(),
//                                           )),
//                                       validator: (value) {
//                                         if (value.length == 0) {
//                                           return "Please enter Proceeding";
//                                         } else {
//                                           return null;
//                                         }
//                                       },
//                                       onSaved: (value) => name = value,
//                                     ),
//                                     // widget.getclientdata.appointdate==DateFormat('yyyy-MM-dd').format(todaydate)?
//                                     // Text(widget.getclientdata.appointdate):Text(''),
//                                     _dateFormatchange(widget.dateTime),
//                                     // Row(
//                                     //   mainAxisAlignment:
//                                     //       MainAxisAlignment.spaceAround,
//                                     //   children: <Widget>[
//                                     //     Padding(
//                                     //         padding: EdgeInsets.only(
//                                     //             top: 10, right: 10),
//                                     //         child: InkWell(
//                                     //           child: Container(
//                                     //             height: 40,
//                                     //             width: 130,
//                                     //             decoration: BoxDecoration(
//                                     //                 border: Border.all(
//                                     //                     width: 2,
//                                     //                     color: Colors.grey)),
//                                     //             child: Padding(
//                                     //                 padding: EdgeInsets.only(
//                                     //                     top: 10),
//                                     //                 child: Text(
//                                     //                   DateFormat('yyyy-MM-dd')
//                                     //                       .format(
//                                     //                           widget.dateTime),
//                                     //                   textAlign:
//                                     //                       TextAlign.center,
//                                     //                   style:
//                                     //                       widget.getclientdata ==
//                                     //                               null
//                                     //                           ? TextStyle(
//                                     //                               color: Colors
//                                     //                                   .black)
//                                     //                           : checkcolor(widget
//                                     //                               .getclientdata
//                                     //                               .clientcourt),
//                                     //                   //  TextStyle(
//                                     //                   //     color: Color(
//                                     //                   //         0xFF000000))
//                                     //                 )),
//                                     //           ),
//                                     //           //  onTap: () {
//                                     //           //     moveToSecondPage();
//                                     //           //   },
//                                     //         )),
//                                     //     IconButton(
//                                     //       icon: Icon(Icons.calendar_today),
//                                     //       tooltip: 'Tap to open date picker',
//                                     //       onPressed: () {
//                                     //         moveToSecondPage();
//                                     //       },
//                                     //     ),
//                                     //   ],
//                                     // ),
//                                     SizedBox(
//                                       height: 1,
//                                     ),
//                                     widget.getclientdata == null
//                                         ? Container()
//                                         : nextdate(
//                                             widget.getclientdata.appointdate),
//                                     DropdownButton(
//                                       value: widget.getclientdata == null
//                                           ? dropdownValue
//                                           : widget.getclientdata.clientcourt,
//                                       items: users.map((user) {
//                                         return DropdownMenuItem(
//                                           value: user.name,
//                                           // widget.getclientdata==null? user.name: widget.getclientdata.clientcourt,
//                                           child: Row(
//                                             children: [
//                                               user.icon,
//                                               SizedBox(width: 10),
//                                               Text(user.name,
//                                                   style: checkcolor(user.name)
//                                                   //  TextStyle(
//                                                   //     color: Colors.red),
//                                                   ),
//                                             ],
//                                           ),
//                                         );
//                                       }).toList(),
//                                       onChanged: (value) {
//                                         setState(() {
//                                         dropdownValue = value;
//                                           if (widget.getclientdata != null) {
//                                             widget.getclientdata.clientcourt =
//                                                 dropdownValue;
//                                           }
                                         
//                                         });
                                     
//                                       },
//                                     ),
//                                     _getdateText()
                                   
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           )),
//                     ),

//                     Padding(
//                         padding: EdgeInsets.only(top: 25, left: 30),
//                         child: Container(
//                             height: 60,
//                             width: 120,
//                             child: RaisedButton(
//                                 child: Text('dfvs'), onPressed: null)
//                             // Stack(
//                             //   children: <Widget>[
//                             //     widget.appoint_id==null?Container(height: 50,width:40
//                             //     ,child:  RaisedButton(onPressed: null)):''
//                             //   ],
//                             // )
//                             )),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ));
//   }
//  _getdateText(){
// if(widget.getclientdata==null){
// return Text('');
// }
// else{
//   return  widget.getclientdata.lastappointdate==null?Text(''):Text('Previous date :'+ widget.getclientdata.lastappointdate);
// }
//  }
//   _dateFormatchange(DateTime datefr) {
//     if(widget.getclientdata==null){
//        return Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: <Widget>[
//           Padding(
//               padding: EdgeInsets.only(top: 10, right: 10),
//               child: InkWell(
//                 child: Container(
//                   height: 40,
//                   width: 130,
//                   decoration: BoxDecoration(
//                       border: Border.all(width: 2, color: Colors.grey)),
//                   child: Padding(
//                       padding: EdgeInsets.only(top: 10),
//                       child: Text(
//                         DateFormat('yyyy-MM-dd').format(datefr),
//                         textAlign: TextAlign.center,
//                         style: widget.getclientdata == null
//                             ?  checksimplecolor()
//                             : checkcolor(widget.getclientdata.clientcourt),
//                         //  TextStyle(
//                         //     color: Color(
//                         //         0xFF000000))
//                       )),
//                 ),
//                 //  onTap: () {
//                 //     moveToSecondPage();
//                 //   },
//               )),
//           IconButton(
//             icon: Icon(Icons.calendar_today),
//             tooltip: 'Tap to open date picker',
//             onPressed: () {
//               moveToSecondPage();
//             },
//           ),
//         ],
//       );
//     }
//   else {if (DateFormat("yyyy-MM-dd").format(todaydate) !=
//         widget.getclientdata.appointdate) {
//       return 
//                   Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: <Widget>[
//           Padding(
//               padding: EdgeInsets.only(top: 10, right: 10),
//               child: InkWell(
//                 child: Container(
//                   height: 40,
//                   width: 130,
//                   decoration: BoxDecoration(
//                       border: Border.all(width: 2, color: Colors.grey)),
//                   child: Padding(
//                       padding: EdgeInsets.only(top: 10),
//                       child: Text(
//                         DateFormat('yyyy-MM-dd').format(datefr),
//                         textAlign: TextAlign.center,
//                         style: widget.getclientdata == null
//                             ? checkcolor(dropdownValue)
//                             : checkcolor(widget.getclientdata.clientcourt),
//                         //  TextStyle(
//                         //     color: Color(
//                         //         0xFF000000))
//                       )),
//                 ),
//                 //  onTap: () {
//                 //     moveToSecondPage();
//                 //   },
//               )),
//           IconButton(
//             icon: Icon(Icons.calendar_today),
//             tooltip: 'Tap to open date picker',
//             onPressed: () {
//               moveToSecondPage();
//             },
//           ),
//         ],
      
      
//       );

//     } else {
//       setState(() {
//         lastdate = DateFormat("yyyy-MM-dd").format(datefr);
//       });
//       return Text('Current date :' +DateFormat("yyyy-MM-dd").format(datefr));
//     }} 
//   }
// String lastdate;
//   var todaydate = new DateTime.now();
//   var _time;
//   var _date;
//   _showTimePicker() async {
//     var picker =
//         await showTimePicker(context: context, initialTime: TimeOfDay.now());
//     setState(() {
//       _time = picker.toString();
//     });
//   }

//   _showDataPicker() async {
//     Locale myLocale = Localizations.localeOf(context);
//     var picker = await showDatePicker(
//         context: context,
//         initialDate: DateTime.now(),
//         firstDate: DateTime(2016),
//         lastDate: DateTime(2040),
//         locale: myLocale);
//     setState(() {
//       _date = picker.toString();
//     });
//   }


//   void submitStudent(BuildContext context) {
//     _formKey.currentState.validate();
//     if (clientname.text.length == 0 ||
//         clientage.text.length == 0 ||
//         //   clientaddress.text.length == 0 ||
//         clientphonenumber.text.length == 0 ||
//         clientphonenumber.text.length <= 9) {
//       return null;
//     }
//     if (widget.getclientdata == null) {
//       Client st = new Client(
//         clientname: clientname.text,
//         //  clientaddress: clientaddress.text,
//         clientphonenumber: clientphonenumber.text,
//         clientage: clientage.text,
//         appointdate: DateFormat("yyyy-MM-dd").format(widget.dateTime),
//         clientcourt: dropdownValue,
//          // lastappointdate: ''
//       );
//      dbclientManager.insertClient(st).then((value) => {
//             clientname.clear(),
//             //       clientaddress.clear(),
//             clientphonenumber.clear(),
//             clientage.clear(),
            
//             print("Student Data Add to database $value"),
//           });

//             Clienthistory ht = new Clienthistory(
//         clienttitle: clientname.text,
//         clientphonenumber: clientphonenumber.text,
//         appointdate: DateFormat("yyyy-MM-dd").format(widget.dateTime),
//         clientcourt: dropdownValue,
//        // clientid: widget.getclientdata.id
//         //lastappointdate: ''
//       );
//              dbclienthistoryManager.insertClient(ht).then((value){
// clientname.clear();
            
//             clientphonenumber.clear();
           
//             print("history Data Add to database $value");
//       });
//       Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(builder: (BuildContext context) => EventScreen()),
//           (Route<dynamic> route) => false);
//       // Navigator.push(
//       //     context,
//       //     MaterialPageRoute(
//       //         builder: (context) =>EventScreen()
//       //         //  ClientPage(
//       //         //       clientdata: clientlist,
//       //         //     )
//       //             ));
//     } else {
//       var newdate;
//       if (changenewdate == true) {
//         newdate = DateFormat("yyyy-MM-dd").format(widget.dateTime1);
//       } else {
//         newdate = DateFormat("yyyy-MM-dd").format(widget.dateTime);
//       }
//       widget.getclientdata.clientname = clientname.text;
//       //    widget.getclientdata.clientaddress = clientaddress.text;
//       widget.getclientdata.clientphonenumber = clientphonenumber.text;
//       widget.getclientdata.clientage = clientage.text;
//       widget.getclientdata.appointdate =
//           DateFormat("yyyy-MM-dd").format(DateTime.parse(newdate));
//       // DateFormat("yyyy-MM-dd").format(widget.dateTime);
//       widget.getclientdata.clientcourt = widget.getclientdata.clientcourt;
//       widget.getclientdata.lastappointdate=lastdate;
//           Clienthistory ht = new Clienthistory(
//         clienttitle: clientname.text,
//         clientphonenumber: clientphonenumber.text,
//         appointdate: DateFormat("yyyy-MM-dd").format(widget.dateTime),
//         clientcourt: widget.getclientdata.clientcourt,
//        clientid: widget.getclientdata.id
//       );
//       dbclienthistoryManager.insertClient(ht).then((value){
//              clientname.clear();
//              clientphonenumber.clear();
           
//             print("history Data Add to database $value");
//       });
// //        widget.gethistorydata.clientphonenumber = clientphonenumber.text;
// //       widget.gethistorydata.clienttitle = clientname.text;
// //       widget.gethistorydata.appointdate =  DateFormat("yyyy-MM-dd").format(DateTime.parse(newdate));
// //  widget.gethistorydata.clientcourt = dropdownValue;
// //       widget.gethistorydata.lastappointdate=lastdate;
// //       dbclienthistoryManager.updateClient(widget.gethistorydata).then((value){
// //  setState(() {
// //           clientlist[updateindex].clientname = clientname.text;
        
// //           clientlist[updateindex].clientphonenumber = clientphonenumber.text;
         
// //           clientlist[updateindex].appointdate =
// //               DateFormat("yyyy-MM-dd").format(widget.dateTime);
// //           clientlist[updateindex].clientcourt = 'dogg';
// //            clientlist[updateindex].lastappointdate = lastdate;
// //         });
// //       });
//       dbclientManager.updateClient(widget.getclientdata).then((value) {
//         setState(() {
//           clientlist[updateindex].clientname = clientname.text;
//           //  clientlist[updateindex].clientaddress = clientaddress.text;
//           clientlist[updateindex].clientphonenumber = clientphonenumber.text;
//           clientlist[updateindex].clientage = clientage.text;
//           clientlist[updateindex].appointdate =
//               DateFormat("yyyy-MM-dd").format(widget.dateTime);
//           clientlist[updateindex].clientcourt = widget.getclientdata.clientcourt;
//            clientlist[updateindex].lastappointdate = lastdate;
//         });
//         clientname.clear();
//         //   clientaddress.clear();
//         clientphonenumber.clear();
//         clientage.clear();
//         client = null;
//       });
//       Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(builder: (BuildContext context) => EventScreen()),
//           (Route<dynamic> route) => false);
//       // Navigator.push(
//       //     context,
//       //     MaterialPageRoute(
//       //         builder: (context) =>
//       //         EventScreen()
//       //         // ClientPage(
//       //         //       clientdata: clientlist,
//       //         //     )
//       //             ));
//     }
//   }
 
// setdatafirestore()async{
//     Firestore.instance.collection("users").document(userlocalemail).setData({
  
//   "username": clientname.text,
//   "phnno": clientphonenumber.text ,
//   "token":FieldValue.arrayUnion([usertoken]),
//   "datetime":  DateFormat("yyyy-MM-dd").format(widget.dateTime),
//     }).then((onValue){
      
//        Firestore.instance.collection("users").document(userlocalemail).updateData({
  
//   "username": clientname.text,
//   "phnno": clientphonenumber.text ,
//   "token":FieldValue.arrayUnion([usertoken]),
//   "datetime":  DateFormat("yyyy-MM-dd").format(widget.dateTime),
//     });
//     });
 
   
  
//   }
// }
  