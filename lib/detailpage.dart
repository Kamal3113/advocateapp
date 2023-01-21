// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:sqladvocate/clientpage.dart';
// import 'package:sqladvocate/contactlist.dart';
// import 'package:sqladvocate/contactscreen.dart';
// import 'package:sqladvocate/database.dart';

// class ClientAddScreen extends StatefulWidget {
//   final Client getclientdata;
//   final ConatctList contact;
//   final String dateTime;
//   ClientAddScreen(this.getclientdata, this.contact,this.dateTime);
//   @override
//   _ClientAddScreenState createState() => _ClientAddScreenState();
// }

// class _ClientAddScreenState extends State<ClientAddScreen> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
// String dropdownValue = 'Highcourt';
//   @override
//   void initState() {
//     super.initState();
//     getText();
//  //   dbclientManager.deleteClient(25);
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
//     });
//   }

//   final DBClientManager dbclientManager = new DBClientManager();

//   final _formkey = new GlobalKey<FormState>();
//   Client client;
//   int updateindex;

//   List<Client> clientlist;
//   TextEditingController clientname = new TextEditingController();
//   TextEditingController clientphonenumber = new TextEditingController();
//   TextEditingController clientaddress = new TextEditingController();
//   TextEditingController clientage = new TextEditingController();

//   String _validateTitle(String value) {
//     if (value.isEmpty) {
//       return 'Name is required.';
//     }
//     return null;
//   }

//   DateTime selectedDate = DateTime.now();

//   String _selectedDate = '';

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

//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       body: 
//       SingleChildScrollView(
//         child: Stack(
//           children: <Widget>[
//             Container(
//               height: MediaQuery.of(context).size.height / 1.0,
//               color: Colors.black,
//               child: Column(
//                 children: <Widget>[
//                   Padding(
//                     padding: EdgeInsets.only(top: 15, bottom: 20),
//                     child: new Container(
//                       height: 710,
//                         decoration: new BoxDecoration(
//                             boxShadow: [
//                               new BoxShadow(
//                                 color: Colors.black,
//                                 blurRadius: 20.0,
//                               ),
//                             ],
//                             color: Colors.white,
//                             borderRadius: new BorderRadius.only(
//                               topLeft: const Radius.circular(40.0),
//                               topRight: const Radius.circular(40.0),
//                               bottomLeft: const Radius.circular(40.0),
//                               bottomRight: const Radius.circular(40.0),
//                             )),
//                         padding: EdgeInsets.only(top: 50, left: 40, right: 40),
//                         child: new Column(
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: <Widget>[
//                             Container(
//                               child: Center(
//                                 child: Text(
//                                   "ADD CLIENT",
//                                   style: TextStyle(
//                                       fontSize: 25,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                               height: 30.0,
//                             ),
//                             Form(
//                                 key: _formKey,
//                                 child: Column(
//                                   children: <Widget>[
//                                     TextFormField(
//                                       key: Key('titleField'),
//                                       controller: clientname,
//                                       decoration: new InputDecoration(
//                                           filled: true,
//                                           labelText: 'CLIENT NAME',
//                                           border: new OutlineInputBorder(
//                                             borderRadius:
//                                                 new BorderRadius.vertical(),
//                                           )),
//                                       validator: _validateTitle,
//                                       onSaved: (String value) {},
//                                     ),

//                                     SizedBox(
//                                       height: 20.0,
//                                     ),

//                                     TextFormField(
//                                       controller: clientphonenumber,
//                                       decoration: new InputDecoration(
//                                           suffix: IconButton(
//                                             icon: Icon(Icons.phone),
//                                             onPressed: () => Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                     builder: (context) =>
//                                                         ContactScreen(
// datetime: widget.dateTime,

//                                                         ))),
//                                           ),
//                                           labelText: 'PHONE',
//                                           border: new OutlineInputBorder(
//                                             borderRadius:
//                                                 new BorderRadius.vertical(),
//                                           )),
//                                       onSaved: (val) => {},
//                                     ),

//                                     SizedBox(
//                                       height: 20.0,
//                                     ),
//                                     new TextFormField(
//                                       controller: clientaddress,
//                                       keyboardType: TextInputType.emailAddress,
//                                       decoration: new InputDecoration(
//                                         filled: true,
//                                         labelText: 'ADDRESS',
//                                         border: new OutlineInputBorder(
//                                             borderRadius:
//                                                 new BorderRadius.vertical()),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 20.0,
//                                     ),
//                                     new TextFormField(
//                                       controller: clientage,
//                                       keyboardType: TextInputType.emailAddress,
//                                       decoration: new InputDecoration(
//                                         filled: true,
//                                         labelText: 'AGE',
//                                         border: new OutlineInputBorder(
//                                             borderRadius:
//                                                 new BorderRadius.vertical()),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 20.0,
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.all(1.0),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceAround,
//                                         children: <Widget>[
//                                           InkWell(
//                                             child: Container(
//                                               height: 30,
//                                               width: 100,
//                             decoration: BoxDecoration(border: Border.all(width: 2,color: Colors.grey)),
//                                               child:
//                                             Text(widget.dateTime,
//                                                 textAlign: TextAlign.center,
//                                                 style: TextStyle(
//                                                     color: Color(0xFF000000))),
                                           
//                                           ),
//                                            onTap: () {
//                                               _selectDate(context);
//                                             },),
//                                           IconButton(
//                                             icon: Icon(Icons.calendar_today),
//                                             tooltip: 'Tap to open date picker',
//                                             onPressed: () {
//                                               _selectDate(context);
//                                             },
//                                           ),
//                                            DropdownButton<String>(
//                     value: dropdownValue,
//                     icon: const Icon(Icons.arrow_drop_down),
//                     iconSize: 24,
//                     elevation: 16,
//                     style: const TextStyle(color: Colors.black),
//                     underline: Container(
//                       height: 2,
//                       color: Colors.black,
//                     ),
//                     onChanged: (String newValue) {
//                       setState(() {
//                         dropdownValue = newValue;
//                       });
//                     },
//                     items: <String>['Highcourt', 'Supremecourt', 'Dist.court']
//                         .map<DropdownMenuItem<String>>((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(value),
//                       );
//                     }).toList(),
//                   ),
             
        
//                                         ],
//                                       ),
                                      
//                                     ),
//     //                                        Row(
//     //              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     //   children: <Widget>[
//     //     RaisedButton(
//     //       child: Text(_date == null ? 'Select date': DateFormat("yyyy-MM-dd").format(DateTime.parse(_date))),
//     //       onPressed: () => _showDataPicker(),
//     //     ),
      
//     //     RaisedButton(
//     //                  child: Text(_time == null ? 'select time' : _time),
//     //       onPressed: () => _showTimePicker(),
//     //     ),

//     //   ],
//     // ),
//     SizedBox(height: 60,),
//                                     RaisedButton(
//                                       child: Text("Add Client"),
//                                       onPressed: () {
//                                         submitStudent(context);
//                                       },
//                                     ),
                                  
//                                   ],
//                                 )),
//                             Row(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceEvenly,
//                                 children: <Widget>[
//                                   SizedBox(
//                                     height: 0,
//                                   ),
//                                 ])
//                           ],
//                         )),
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//  var _time;
//   var _date;
//   _showTimePicker() async {
//     var picker =
//         await showTimePicker(context: context, initialTime: TimeOfDay.now());
//     setState(() {
//       _time = picker.toString();
//     });
  
// }
// _showDataPicker() async {
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
//     if (widget.getclientdata == null) {
//       Client st = new Client(
//           clientname: clientname.text,
//           clientaddress: clientaddress.text,
//           clientphonenumber: clientphonenumber.text,
//           clientage: clientage.text,
//           appointdate: widget.dateTime,
//           clientcourt: dropdownValue
//           );
//       dbclientManager.insertClient(st).then((value) => {
//             clientname.clear(),
//             clientaddress.clear(),
//             clientphonenumber.clear(),
//             clientage.clear(),
//             print("Student Data Add to database $value"),
//           });
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => ClientPage(
//                     clientdata: clientlist,
//                   )));
//     } else {
//       widget.getclientdata.clientname = clientname.text;
//       widget.getclientdata.clientaddress = clientaddress.text;
//       widget.getclientdata.clientphonenumber = clientphonenumber.text;
//       widget.getclientdata.clientage = clientage.text;

//       dbclientManager.updateClient(widget.getclientdata).then((value) {
//         setState(() {
//           clientlist[updateindex].clientname = clientname.text;
//           clientlist[updateindex].clientaddress = clientaddress.text;
//           clientlist[updateindex].clientphonenumber = clientphonenumber.text;
//           clientlist[updateindex].clientage = clientage.text;
//         });
//         clientname.clear();
//         clientaddress.clear();
//         clientphonenumber.clear();
//         clientage.clear();
//         client = null;
//       });
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => ClientPage(
//                     clientdata: clientlist,
//                   )));
//     }
//   }
// }
