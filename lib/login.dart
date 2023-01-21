import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:sqladvocate/auth.dart';
import 'package:sqladvocate/clientlist.dart';
import 'package:sqladvocate/clientpage.dart';
import 'package:sqladvocate/color.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqladvocate/eventcalendar.dart';
import 'package:sqladvocate/forgot.dart';
import 'package:sqladvocate/splashscreen.dart';
import 'package:sqladvocate/rootpage.dart';

class Loginpage extends StatefulWidget {
  final String token_appid;
  // final BaseAuth auth;
  // final VoidCallback onSignedIn;
  Loginpage({this.token_appid});
  @override
  _LoginpageState createState() => _LoginpageState();
}
enum FormType { login, register }
class _LoginpageState extends State<Loginpage> {
  String _password;
  String _email;
  String _name;
  String _phnnumber;
  TextEditingController useremail = new TextEditingController();
  TextEditingController userpassword = new TextEditingController();
  TextEditingController username = new TextEditingController();
  TextEditingController userphone = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  int updateindex;
  static Database _db;
  static const String DB_NAME = 'login.db';
  static const String TABLE = 'userclient';
  static const String ID = 'id';
  static const String USERNAME = 'username';
  static const String PASSWORD = 'password';
  static const String EMAIL = 'email';
  static const String TOKEN = 'token';
  static const String PHONE = 'phone';

  @override
  void initState() {
    super.initState();
    _query(context);
  }
var file1;
   getPdfAndUpload() async {

    var file =await FilePicker.getFilePath();

    if(file != null) {

      setState(() {

          file1 = file ; 
     
      });
     SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString('databackup',file1);
      // openDatabase(file1);
//       ByteData data = await rootBundle.load("assest/client.db");
// List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
// await File('client.db').writeAsBytes(bytes);
print(file1);
    }
  }
//   part() async {
//   FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);

// if(result != null) {
//    List<File> files = result.paths.map((path) => File(path)).toList();
// } else {
//    // User canceled the picker
// }
//   }

   FormType _formtype = FormType.login;
//  final formkey = new GlobalKey<FormState>();
  bool validateandsave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
//  void validateandsubmit() async {
//     if (validateandsave()) {
//       try {
//         if (_formtype == FormType.login) {
//           String userId =
//               await widget.auth.signInWithEmailAndPassword(_email, _password);
//           // FirebaseUser user = (await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password)) as FirebaseUser;
//           print('sign in : $userId');
//         } else {
//           String userId = await widget.auth
//               .createUserWithEmailAndPassword(_email, _password);
//           // FirebaseUser user= (await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password)) as FirebaseUser;
//           print('Registered user $userId');
//         }
//         widget.onSignedIn();
//       } catch (e) {
//         print('Error: $e');
//       }
//     }
//   }
    void movetoRegister() {
    _formKey.currentState.reset();
    setState(() {
      _formtype = FormType.register;
    });
  }

  void movetoLogin() {
    _formKey.currentState.reset();
    setState(() {
      _formtype = FormType.login;
    });
  }
  List<ClientList> _clients = [];
  Future<List<ClientList>> _query( context) async {
    Database db = await this.db;
 //db.delete(TABLE);
    List<Map> maps = await db.query(TABLE);

    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        _clients.add(ClientList.fromMap(maps[i]));
    }      
   
 
        return _clients;
    }

   
  }

  ClientList _clientList;
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getExternalStorageDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, $USERNAME TEXT,$PASSWORD TEXT,$EMAIL TEXT,$PHONE TEXT)");
  }
    bool checkacc ;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              
              Container(
                height: MediaQuery.of(context).size.height / 1.0,
                color: Colors.black,
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 5, bottom: 10),
                      child: new Container(
                          decoration: new BoxDecoration(
                              boxShadow: [
                                new BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 20.0,
                                ),
                              ],
                              color: topcenterlogin,
                              // gradient: LinearGradient(
                              //     begin: Alignment.topCenter,
                              //     end: Alignment.bottomCenter,
                              //     colors: [topcenterlogin, bottomcenterlogin]
                              //     ),
                              borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(40.0),
                                topRight: const Radius.circular(40.0),
                                bottomLeft: const Radius.circular(40.0),
                                bottomRight: const Radius.circular(40.0),
                              )),
                          padding: EdgeInsets.only(
                              top: 100, left: 40, right: 40, bottom: 10),
                          child: Stack(
                            children: <Widget>[
                              new Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Padding(padding: EdgeInsets.only(
                              top: 1, left: 240),
                              child:   IconButton(
                                  icon: Icon(Icons.backup_rounded,color: Colors.white,),
                                  onPressed: () {
                                    getPdfAndUpload();
                                  }),),
                                 
                                  Container(
                                      height: 160,
                                      width: 30,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.grey,
                                        //  radius: 5,
                                        child: ClipOval(
                                          child:
                                              Image.asset("assest/vakeel.png"),
                                        ),
                                      )),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: TabBar(
                                        indicatorColor: Colors.white,
                                        tabs: [
                                          Tab(
                                            text: "Existing",
                                          ),
                                          Tab(
                                            text: "New",
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Expanded(
                                      child: TabBarView(
                                    children: <Widget>[
                                      Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  new BorderRadius.only(
                                                topLeft:
                                                    const Radius.circular(10.0),
                                                topRight:
                                                    const Radius.circular(10.0),
                                                bottomLeft:
                                                    const Radius.circular(10.0),
                                                bottomRight:
                                                    const Radius.circular(10.0),
                                              )),
                                          padding: EdgeInsets.only(
                                              right: 15, left: 15, bottom: 10),
                                          child: Column(
                                            children: <Widget>[
                                              Form(
                                                  key: _formKey,
                                                  child: Column(
                                                    children: <Widget>[
                                                      Container(
                                                          height: 60,
                                                          child: TextFormField(
                                                            controller:
                                                                useremail,
                                                            keyboardType:
                                                                TextInputType
                                                                    .emailAddress,
                                                            decoration:
                                                                new InputDecoration(
                                                              prefixIcon: Icon(
                                                                Icons.email,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              labelText:
                                                                  'Email',
                                                            ),
                                                            validator: (val) {
                                                              if (val.length ==
                                                                  0)
                                                                return "Please enter email";
                                                              else if (!val
                                                                  .contains(
                                                                      "@"))
                                                                return "Please enter valid email";
                                                              // else if (val != data['username']) {
                                                              //   return "Please enter correct email";
                                                              // } else
                                                              return null;
                                                            },
                                                            onSaved: (val) =>
                                                                _email = val,
                                                          )),
                                                      Divider(
                                                          height: 2,
                                                          color: Colors.black),
                                                      SizedBox(
                                                        height: 3.0,
                                                      ),
                                                      new Container(
                                                          height: 60,
                                                          child: TextFormField(
                                                              obscureText: true,
                                                              controller:
                                                                  userpassword,
                                                              keyboardType:
                                                                  TextInputType
                                                                      .emailAddress,
                                                              decoration:
                                                                  new InputDecoration(
                                                                prefixIcon:
                                                                    Icon(
                                                                  Icons
                                                                      .lock_open,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                labelText:
                                                                    'Password',
                                                              ),
                                                              validator:
                                                                  (value) {
                                                                if (value
                                                                        .length ==
                                                                    0) {
                                                                  return "Please enter password";
                                                                } else if (value
                                                                        .length <=
                                                                    5)
                                                                  return "Your password should be more then 6 char long";
                                                                // else if (value != data['password']) {
                                                                //   return "Please enter correct password";
                                                                // } else
                                                                return null;
                                                              },
                                                              onSaved: (value) =>
                                                                  _password =
                                                                      value)),
                                                      Divider(
                                                          height: 2,
                                                          color: Colors.black),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      RaisedButton(
                                                        onPressed: () {
                                                      //   validateandsubmit();
                                                      login(context);
                                                    //  loginfirestore(context);
                                                        },
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        80.0)),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(0.0),
                                                        child: Ink(
                                                          decoration:
                                                              const BoxDecoration(
                                                                  color: topcenterlogin,
                                                            // gradient: LinearGradient(
                                                            //     begin: Alignment
                                                            //         .topCenter,
                                                            //     end: Alignment
                                                            //         .bottomCenter,
                                                            //     colors: [
                                                            //       topcenterlogin,
                                                            //       bottomcenterlogin
                                                            //     ]),
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        80.0)),
                                                          ),
                                                          child: Container(
                                                            constraints:
                                                                const BoxConstraints(
                                                                    minWidth: 2,
                                                                    minHeight:
                                                                        36.0), // min sizes for Material buttons
                                                            alignment: Alignment
                                                                .center,
                                                            child: const Text(
                                                              'Login',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      // RaisedButton(
                                                      //   color: bottomcenterlogin,
                                                      //     child: Text('Login',
                                                      //         style: TextStyle(
                                                      //             color: Colors
                                                      //                 .white)),
                                                      //     onPressed: () {
                                                      //       _loginset();
                                                      //     }),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Container(
                                                          child: FlatButton(
                                                              onPressed: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            ResetPassword()
                                                                            ));
                                                              },
                                                              child: Text(
                                                                  'Forgot password?',
                                                                  style: TextStyle(
                                                                      //color: kPrimaryColor,
                                                                      fontSize: 14)))),
                                                      Row(children: <Widget>[
                                                        Expanded(
                                                          child: new Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          10.0,
                                                                      right:
                                                                          15.0),
                                                              child: Divider(
                                                                color: Colors
                                                                    .black,
                                                                height: 50,
                                                              )),
                                                        ),
                                                        Text("OR"),
                                                        Expanded(
                                                          child: new Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          15.0,
                                                                      right:
                                                                          10.0),
                                                              child: Divider(
                                                                color: Colors
                                                                    .black,
                                                                height: 50,
                                                              )),
                                                        ),
                                                      ]),
                                                    ],
                                                  )),
                                            ],
                                          )),
                                      Padding(
                                          padding: EdgeInsets.only(bottom: 5),
                                          child: Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      new BorderRadius.only(
                                                    topLeft:
                                                        const Radius.circular(
                                                            10.0),
                                                    topRight:
                                                        const Radius.circular(
                                                            10.0),
                                                    bottomLeft:
                                                        const Radius.circular(
                                                            10.0),
                                                    bottomRight:
                                                        const Radius.circular(
                                                            10.0),
                                                  )),
                                              padding: EdgeInsets.only(
                                                  right: 15,
                                                  left: 15,
                                                  bottom: 10),
                                              child: Column(
                                                children: <Widget>[
                                                  Form(
                                                      key: _formKey,
                                                      child: Column(
                                                        children: <Widget>[
                                                          Container(
                                                              height: 60,
                                                              child:
                                                                  TextFormField(
                                                                controller:
                                                                    useremail,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .emailAddress,
                                                                decoration:
                                                                    new InputDecoration(
                                                                  prefixIcon:
                                                                      Icon(
                                                                    Icons.email,
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  labelText:
                                                                      'Email',
                                                                ),
                                                                validator:
                                                                    (val) {
                                                                  if (val.length ==
                                                                      0)
                                                                    return "Please enter email";
                                                                  else if (!val
                                                                      .contains(
                                                                          "@"))
                                                                    return "Please enter valid email";
                                                                  // else if (val != data['username']) {
                                                                  //   return "Please enter correct email";
                                                                  // } else
                                                                  return null;
                                                                },
                                                                onSaved:
                                                                    (val) =>
                                                                        _email =
                                                                            val,
                                                              )),
                                                          Divider(
                                                              height: 2,
                                                              color:
                                                                  Colors.black),
                                                          SizedBox(
                                                            height: 3.0,
                                                          ),
                                                          Container(
                                                              height: 60,
                                                              child:
                                                                  TextFormField(
                                                                controller:
                                                                    username,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .emailAddress,
                                                                decoration:
                                                                    new InputDecoration(
                                                                  prefixIcon:
                                                                      Icon(
                                                                    Icons
                                                                        .person,
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  labelText:
                                                                      'Name',
                                                                ), validator:
                                                                          (value) {
                                                                        if (value.length ==
                                                                            0) {
                                                                          return "Please enter name";
                                                                        } else{
                                                                          return null;
                                                                        }
                                                                      },
                                                                      onSaved: (value) =>
                                                                          _name =
                                                                              value,
                                                              )),
                                                          Divider(
                                                              height: 2,
                                                              color:
                                                                  Colors.black),
                                                          SizedBox(
                                                            height: 3.0,
                                                          ),
                                                          Container(
                                                              height: 60,
                                                              child:
                                                                  TextFormField(
                                                                controller:
                                                                    userphone,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                decoration:
                                                                    new InputDecoration(
                                                                  prefixIcon:
                                                                      Icon(
                                                                    Icons
                                                                        .contact_phone,
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  labelText:
                                                                      'Phone',
                                                                ), validator:
                                                                          (value) {
                                                                        if (value.length ==
                                                                            0) {
                                                                          return "Please enter phone number";
                                                                        } else{
                                                                          return null;
                                                                        }
                                                                      },
                                                                      onSaved: (value) =>
                                                                          _phnnumber =
                                                                              value,
                                                              )),
                                                          Divider(
                                                              height: 2,
                                                              color:
                                                                  Colors.black),
                                                          SizedBox(
                                                            height: 3.0,
                                                          ),
                                                          new Container(
                                                              height: 60,
                                                              child:
                                                                  TextFormField(
                                                                      obscureText:
                                                                          true,
                                                                      controller:
                                                                          userpassword,
                                                                      keyboardType:
                                                                          TextInputType
                                                                              .emailAddress,
                                                                      decoration:
                                                                          new InputDecoration(
                                                                        prefixIcon:
                                                                            Icon(
                                                                          Icons
                                                                              .lock_open,
                                                                          color:
                                                                              Colors.grey,
                                                                        ),
                                                                        border:
                                                                            InputBorder.none,
                                                                        labelText:
                                                                            'Password',
                                                                      ),
                                                                      validator:
                                                                          (value) {
                                                                        if (value.length ==
                                                                            0) {
                                                                          return "Please enter password";
                                                                        } else if (value.length <=
                                                                            5)
                                                                          return "Your password should be more then 6 char long";
                                                                        // else if (value != data['password']) {
                                                                        //   return "Please enter correct password";
                                                                        // } else
                                                                        return null;
                                                                      },
                                                                      onSaved: (value) =>
                                                                          _password =
                                                                              value
                                                                              )
                                                                              ),
                                                          Divider(
                                                              height: 2,
                                                              color:
                                                                  Colors.black),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          RaisedButton(
                                                            onPressed: () {
                                                             // validateandsubmit();
                                                       //   return checkapp(context);
                                                     // return dialogbox(context);
                                                     if(_clients.length==0){
return dialogbox(context);
                                                     }
                                                     
                                                     for (int i = 0; i < _clients.length ; i++){
   if(_clients[i].email == useremail.text){
                                       checkaccountdialogbox(context);
                                                  }
                                                  else{
                                                      dialogbox(context);
                                                  }
                                                     }
                                               
                                                              //  for (int i = 0; i < _clients.length  ; i++){
                                                              //      if (_clients[i].email == useremail.text){
                                                              //      return checkaccountdialogbox(context);
                                                              //      }
                                                              //      else{
                                                              //        return dialogbox(context);
                                                              //       //  setState(() {
                                                              //       //    checkacc = true;
                                                              //       //     return dialogbox(context);
                                                              //       //  });
                                                                   
                                                                
                                                              //      }
                                                              //  }
                                                            // if(checkacc == true){
                                                            //    return dialogbox(context);
                                                            // }
                                                             
                                                            },
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            80.0)),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(0.0),
                                                            child: Ink(
                                                              decoration:
                                                                  const BoxDecoration(
                                                                      color: topcenterlogin,
                                                                // gradient: LinearGradient(
                                                                //     begin: Alignment
                                                                //         .topCenter,
                                                                //     end: Alignment.bottomCenter,
                                                                //     colors: [
                                                                //       topcenterlogin,
                                                                //       bottomcenterlogin
                                                                //     ]),
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            80.0)),
                                                              ),
                                                              child: Container(
                                                                constraints:
                                                                    const BoxConstraints(
                                                                        minWidth:
                                                                            2,
                                                                        minHeight:
                                                                            36.0), // min sizes for Material buttons
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child:
                                                                    const Text(
                                                                  'Register',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          // RaisedButton(
                                                          //   color: bottomcenterlogin,
                                                          //     child: Text(
                                                          //         'Register',
                                                          //         style: TextStyle(
                                                          //             color: Colors
                                                          //                 .white)),
                                                          //     onPressed: () {
                                                          //       _logindata();
                                                          //     })
                                                        ],
                                                      )),
                                                ],
                                              ))),
                                    ],
                                  )),
                                ],
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              )
            ],
          ),
        )));
  }

  register(BuildContext context) async {
      _formKey.currentState.validate();
    if (username.text.length == 0 ||
    userpassword.text.length == 0 ||
    userphone.text.length == 0 ||
    useremail.text.length==0 ||
     !useremail.text.contains("@")
       ) {
      return null;
    }
    var dbClient = await db;
    var table =
        ("INSERT OR REPLACE INTO $TABLE ($USERNAME,$PASSWORD,$EMAIL,$PHONE) VALUES ('${username.text}','${userpassword.text}','${useremail.text}','${userphone.text}')");
   await dbClient.transaction((txn) async {
      print(table);
int id= await   txn.rawInsert(table) ;
 print(id);
      // await txn.rawInsert(table);

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      setState(() {
        _login = true;
      });
      localStorage.setString('userid', id.toString());
      localStorage.setBool('checklogin', _login);
    localStorage.setString('name', username.text);
     localStorage.setString('email', useremail.text);
    });

   return 
 Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => EventScreen(
     
            )),
        (route) => false);
  }
String userid;
// checkapp(BuildContext context){
//    for (int i = 0; i < _clients.length  ; i++){
//       if (_clients[i].email == useremail.text){
      
//        setState(() {
//           checkacc = true;
         
//           });
//            checkaccountdialogbox(context);
//       }
//       else{
//     return dialogbox(context);
       
      
   
//       }
//       //  if(checkacc == true){
//       //    return dialogbox(context);
//       //      }
//   }
// }
// signupfirestorelogin(){
//   FirebaseAuth.instance.createUserWithEmailAndPassword(email: useremail.text, password: userpassword.text);
  
// }
// loginfirestore(BuildContext context){
//     FirebaseAuth.instance
//                             .signInWithEmailAndPassword(
//                                 email: useremail.text,
//                                 password: userpassword.text).then((result)async{
//                                       await Navigator.of(context).pushAndRemoveUntil(
//               MaterialPageRoute(
//                   builder: (BuildContext context) => EventScreen()),
//               (Route<dynamic> route) => false);
//                                 });
// }
  dialogbox(BuildContext context){
     return showDialog(
    context: context,
    builder: (BuildContext context) {

      return AlertDialog(
        //title: Text('Not in stock'),
        content: const Text('Login successfully'),
        actions: [
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
            //  validateandsubmit();
              // Navigator.of(context).pop();
              register(context);
             // signupfirestorelogin();
            },
          ),
        ],
      );
    },
  );

  }
    checkaccountdialogbox(BuildContext context){
     return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        //title: Text('Not in stock'),
        content: const Text('Email already exist!'),
        actions: [
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
          //  Navigator.of(context).pop();
             Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => Rootpage()),
              (Route<dynamic> route) => false);
            },
          ),
        ],
      );
    },
  );

  }
  loginmatch(BuildContext context){
     return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        //title: Text('Not in stock'),
        content: const Text('Email or password is not valid !'),
        actions: [
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
           // Navigator.of(context).pop();
             Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );

  }
  login(BuildContext context) async {
        _formKey.currentState.validate();
    if (
    userpassword.text.length == 0 ||
 
    useremail.text.length==0 ||
     !useremail.text.contains("@")
     
       ) {
      return null;
    }
    for (int i = 0; i < _clients.length; i++) {
      if (_clients[i].email == useremail.text) {
        if (_clients[i].password == userpassword.text) {
          
          print('done');
          SharedPreferences localStorage =
              await SharedPreferences.getInstance();
              
          setState(() {
            _login = true;
          });
           

  localStorage.setString('userid' ,  _clients[i].id.toString());
          localStorage.setBool('checklogin', _login);
          await Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => EventScreen()),
              (Route<dynamic> route) => false);
        }
        else {
            loginmatch(context);
        }
      } else {
      loginmatch(context);
      }
    }
  }
 checkapp(BuildContext context) async {
  
    for (int i = 0; i < _clients.length; i++) {
      if (_clients[i].email == useremail.text) {
        // if (_clients[i].password == userpassword.text)
        //  {
          // print('done');
       
          // setState(() {
          //   checkacc = true;
          // });
           
 return  checkaccountdialogbox(context);

       // }
      } 
      else {
          setState(() {
            checkacc = true;
          });
     return  dialogbox(context);
      }
    
    }
      
  }
  var data;
  bool _login;
}
