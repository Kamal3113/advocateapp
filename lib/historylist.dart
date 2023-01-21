import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqladvocate/color.dart';
import 'package:sqladvocate/database.dart';
import 'package:sqladvocate/historydatabase.dart';
import 'package:sqladvocate/showindividuallist.dart';

class Historylist extends StatefulWidget {
  final List clienthistorydata;

  Historylist({this.clienthistorydata});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Historylist> {
  var getdata;
  var getappointmentlist;
  String filter;
TextEditingController _searchcontroller = new TextEditingController();
  // final DBClienthistoryManager dbclientManager = new DBClienthistoryManager();
  final DBClientManager dbclientManager = new DBClientManager();
  @override
  void initState() {
    super.initState();

    _setlocalname();
     _searchcontroller.addListener(() {
      setState(() {
        filter = _searchcontroller.text;
      });
    });
  }

  String localusername;
  _setlocalname() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      localusername = preferences.getString("name");
    });
    print(localusername);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
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
                                'CASE HISTORY',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              // SizedBox(width: 90),
                              // Text(
                              //   localusername == null
                              //       ? 'loading'
                              //       : localusername,
                              //   style: TextStyle(
                              //       color: Colors.white, fontSize: 17),
                              // ),
                            ]),
                      ),
                    ]),
                // SingleChildScrollView(
                //   child:
                   Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                         Padding(padding: EdgeInsets.all(5),child:
                  TextFormField(
                                      controller: _searchcontroller,
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        filled: true,
                                          border: OutlineInputBorder(),
                                          hintText: 'Search by name or phone number',
                                          suffixIcon: IconButton(
                                            icon: Icon(Icons.search),
                                            onPressed: () {
                                           //   searchdoctor();
                                            },
                                          )),
                                    )
                                   ),
                      SingleChildScrollView(
                          child: Container(
                           height: 670,
                              child: 
                              FutureBuilder(
                        future: dbclientManager.getclientList(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var getdata = snapshot.data;
                            return ListView.builder(
                              
                              shrinkWrap: true,
                              itemCount: getdata == null ? 0 : getdata.length,
                              itemBuilder: (BuildContext context, int index) {
                                Client setdata = getdata[index];
 return filter == null || filter ==''?
                                 GestureDetector(
                                  onTap: () {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //         ClientAddScreen( getdata[index],null,null,setdata.id,null,null)

                                    //             ));
                                  },
                                  child:Card(
color: Colors.grey[100],
                                  child:
                                   Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      ListTile(
                                          title: Text(
                                            setdata.clientname == null
                                                ? ""
                                                : setdata.clientname,
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 18),
                                          ),
                                      
                                          leading:  checkcolor(setdata.clientcourt),
                                          // checkcolor( setdata.clientcourt),

                                          trailing: FlatButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Individualhistorylist(
                                                              setclientid:
                                                                 setdata.id.toString(),
                                                                 getclientdata:  getdata[index],
                                                            )));
                                              },
                                              child: Text('View details'))
                                          //  Text(
                                          //   setdata.appointdate ==
                                          //           null
                                          //       ?setdata.lastappointdate
                                          //       : setdata.appointdate,
                                          //   style: TextStyle(
                                          //       color: Colors.black),
                                          // ),
                                          ),
                                    ],
                                  )),
                                ):
                                setdata.clientphonenumber.toLowerCase().contains(filter)||
                               setdata.clientname.toLowerCase().contains(filter) ?
                                 GestureDetector(
                                  onTap: () {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //         ClientAddScreen( getdata[index],null,null,setdata.id,null,null)

                                    //             ));
                                  },
                                  child:Card(
color: Colors.grey[100],
                                  child:
                                   Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      ListTile(
                                          title: Text(
                                            setdata.clientname == null
                                                ? ""
                                                : setdata.clientname,
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 18),
                                          ),
                                      
                                          leading:  checkcolor(setdata.clientcourt),
                                          // checkcolor( setdata.clientcourt),

                                          trailing: FlatButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Individualhistorylist(
                                                              setclientid:
                                                                 setdata.id.toString(),
                                                                 getclientdata:  getdata[index],
                                                            )
                                                            ));
                                              },
                                              child: Text('View details'))
                                          //  Text(
                                          //   setdata.appointdate ==
                                          //           null
                                          //       ?setdata.lastappointdate
                                          //       : setdata.appointdate,
                                          //   style: TextStyle(
                                          //       color: Colors.black),
                                          // ),
                                          ),
                                    ],
                                  )),
                                ):Container();
                              },
                            );
                          }
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ))),
                    ],
                  ),
               // )
              ],
            )),
      ),
    );
  }

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
