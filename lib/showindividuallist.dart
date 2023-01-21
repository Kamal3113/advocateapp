import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqladvocate/color.dart';
import 'package:sqladvocate/database.dart';
import 'package:sqladvocate/historydatabase.dart';

class Individualhistorylist extends StatefulWidget {
  final String setclientid;
  final Client getclientdata;
  Individualhistorylist({this.setclientid,this.getclientdata});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Individualhistorylist> {
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
                           
                            ]),
                      ),
                    ]),
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
                                    )),
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                 
                      SingleChildScrollView(
                          child:
                          
                           Container(
                            height: 570,
                              child: FutureBuilder(
                        future: dbclientManager.gethistorydata1(widget.setclientid),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                             getdata = snapshot.data;
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: getdata == null ? 0 : getdata.length,
                              itemBuilder: (BuildContext context, int index) {
                         Clienthistory setdata = getdata[index];
                         return filter == null || filter ==''?
                     // if(widget.setclientid==getdata[index].clientid.toString()){
                           GestureDetector(
                                  onTap: () {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //         ClientAddScreen( getdata[index],null,null,setdata.id,null,null)

                                    //             ));
                                  },
                                  child:
                                  Card(
color: Colors.grey[100],
                                  child: Column(
                                    children: <Widget>[
                                      ListTile(
                                    
                                        title: Text(
                                          setdata.clientphonenumber == null
                                              ? ""
                                              : setdata.clientphonenumber,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        subtitle: Text(
                                          setdata.clientcourt == null
                                              ? ""
                                              : setdata.clientcourt,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        leading:
                                            checkcolor(setdata.clientcourt),
                                        trailing: Text(
                                          setdata.appointdate == null
                                              ? setdata.lastappointdate
                                              : setdata.appointdate,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  )),
                                ):
                                setdata.clienttitle.toLowerCase().contains(filter)||
                                 setdata.clientphonenumber.toLowerCase().contains(filter)?
                                  GestureDetector(
                                  onTap: () {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //         ClientAddScreen( getdata[index],null,null,setdata.id,null,null)

                                    //             ));
                                  },
                                  child:
                                  Card(
color: Colors.grey[100],
                                  child: Column(
                                    children: <Widget>[
                                      ListTile(
                                    
                                        title: Text(
                                          setdata.clientphonenumber == null
                                              ? ""
                                              : setdata.clientphonenumber,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        subtitle: Text(
                                          setdata.clientcourt == null
                                              ? ""
                                              : setdata.clientcourt,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        leading:
                                            checkcolor(setdata.clientcourt),
                                        trailing: Text(
                                          setdata.appointdate == null
                                              ? setdata.lastappointdate
                                              : setdata.appointdate,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  )),
                                ):Container();
                      // }else{
                      //   return null;
                      // }
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
                )
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
