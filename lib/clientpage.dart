// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sqladvocate/color.dart';
// import 'package:sqladvocate/contactlist.dart';
// import 'package:sqladvocate/database.dart';
// import 'package:sqladvocate/delete.dart';
// import 'package:sqladvocate/detailpage.dart';
// import 'package:sqladvocate/eventcalendar.dart';
// import 'package:sqladvocate/login.dart';

// class ClientPage extends StatefulWidget {
//   final List clientdata;
//   final int client_id;
//   final String name;

//   ClientPage({this.clientdata, this.client_id, this.name});
//   @override
//   _ClientPageState createState() => _ClientPageState();
// }

// class _ClientPageState extends State<ClientPage> {
//   @override
//   void initState() {
//     super.initState();
//     // _timer;
//   }

//   bool _locallogin;
//   bool _login;
//   void signout() async {
//     setState(() {});
//     SharedPreferences localStorage = await SharedPreferences.getInstance();
//     setState(() {
//       _login = false;
//     });
//     localStorage.setBool("checklogin", _login);
//     Navigator.of(context).pushAndRemoveUntil(
//         MaterialPageRoute(builder: (BuildContext context) => Loginpage()),
//         (Route<dynamic> route) => false);
//   }

//   Timer _timer;
//   ConatctList _conatctList;
//   final DBClientManager dbclientManager = new DBClientManager();
//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text('Client List'),
//         backgroundColor: topcenterlogin,
//         actions: <Widget>[
//           IconButton(
//             icon: Icon(
//               Icons.settings_power_outlined,
//               color: Colors.white,
//             ),
//             onPressed: () {
//               signout();
//             },
//           )
//         ],
//       ),
//       body: FutureBuilder(
//         future: dbclientManager.getclientList(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             var getdata = snapshot.data;
//             return ListView.builder(
//               shrinkWrap: true,
//               itemCount: getdata == null ? 0 : getdata.length,
//               itemBuilder: (BuildContext context, int index) {
//                 Client setdata = getdata[index];
             
//           // if (setdata.clientcourt == "Highcourt") {
//           //         Icon(
//           //           Icons.circle,
//           //           color: Colors.green,
//           //         );
//           //         if (setdata.clientcourt == "Supremecourt") {
//           //           Icon(
//           //             Icons.circle,
//           //             color: Colors.blue,
//           //           );
//           //         } else {
//           //           Icon(
//           //             Icons.circle,
//           //             color: Colors.yellow,
//           //           );
//           //         }
//           //       }
               
             
//                 return Card(
//                   child:
//                    Row(
//                     children: <Widget>[
//                       Padding(
//                         padding: const EdgeInsets.all(18.0),
//                         child: Container(
//                           width: width * 0.50,
//                           child: Column(
//                             children: <Widget>[
//                               Container(
//                                 // color: Colors.orange,
//                                 width: 150,
//                                 child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: <Widget>[
//                                       Text(
//                                         setdata.clientname,
//                                         style: TextStyle(
//                                           fontSize: 18.0,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         overflow: TextOverflow.ellipsis,
//                                       ),
                                   
//                                       SizedBox(height: 4.0),
//                                       Text(
//                                         setdata.clientaddress,
//                                         style: TextStyle(
//                                           fontSize: 12.0,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                         overflow: TextOverflow.ellipsis,
//                                       ),
//                                       SizedBox(height: 4.0),
//                                       Text(
//                                         DateFormat('yyyy-MM-dd').format(
//                                             DateTime.parse(
//                                                 setdata.appointdate)),
//                                         style: TextStyle(
//                                           fontSize: 12.0,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                         overflow: TextOverflow.ellipsis,
//                                       ),
//                                       //    SizedBox(height: 4.0),
//                                       // Text(
//                                       //   setdata.clientcourt,
//                                       //   style: TextStyle(
//                                       //     fontSize: 12.0,
//                                       //     fontWeight: FontWeight.w600,
//                                       //   ),
//                                       //   overflow: TextOverflow.ellipsis,
//                                       // ),
//                                     ]),
//                               ),
                        
//                             ],
//                           ),
//                         ),
//                       ),
//                       setdata.clientcourt == "Highcourt"
//                           ? Icon(
//                               Icons.circle,
//                               color: Colors.green,
//                             )
//                           : Icon(
//                               Icons.circle,
//                               color: Colors.red,
//                             ),
//                       // setdata.clientcourt == "Supremecourt"
//                       //     ? Icon(
//                       //         Icons.circle,
//                       //         color: Colors.blue,
//                       //       )
//                       //     : Icon(null),
//                       // setdata.clientcourt == "Dist.court"
//                       //     ? Icon(
//                       //         Icons.circle,
//                       //         color: Colors.yellow,
//                       //       )
//                       //     : Icon(null),
//                       SizedBox(
//                         width: 10,
//                       ),
//                       IconButton(
//                         onPressed: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => ClientAddScreen(
//                                       getdata[index], _conatctList, null)));
//                           // clientname.text = st.clientname;
//                           // clientaddress.text = st.clientaddress;
//                           // clientage.text = st.clientage;
//                           // client = st;
//                           // updateindex = index;
//                         },
//                         icon: Icon(
//                           Icons.edit,
//                           color: Colors.blue,
//                         ),
//                       ),
//                       IconButton(
//                         onPressed: () {
//                           dbclientManager.deleteClient(setdata.id);
//                           setState(() {
//                             _timer = Timer.periodic(new Duration(seconds: 1),
//                                 (time) {
//                               widget.clientdata.removeAt(index);
//                             });
//                           });
//                         },
//                         icon: Icon(
//                           Icons.delete,
//                           color: Colors.red,
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             );
//           }
//           return CircularProgressIndicator();
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: topcenterlogin,
//         onPressed: () {
//           Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => EventScreen()
//                   //  ClientAddScreen(null, _conatctList,null)
//                   ));
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
