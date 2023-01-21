
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';




class ResetPassword extends StatefulWidget {
 @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

enum FormType { login, register }

class _LoginPageState extends State<ResetPassword> {
  String _email;
  String _password;
  final formkey = new GlobalKey<FormState>();
  FormType _formtype = FormType.login;
TextEditingController useremail =new TextEditingController();
TextEditingController userpassword =new TextEditingController();
TextEditingController _name =new TextEditingController();
TextEditingController _description =new TextEditingController();
TextEditingController _phone =new TextEditingController();
TextEditingController _address =new TextEditingController();
  bool validateandsave() {
    final form = formkey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
 @override
  void initState() {
    super.initState();
   
    }
  AlertDialog alert = AlertDialog(
    title: Text("Notice"),
    content: Text("go to login"),
  );

 
  void validateandsubmit() async {
     
  
  }

  void movetoRegister() {
    formkey.currentState.reset();
    setState(() {
      _formtype = FormType.register;
    });
  }

  void movetoLogin() {
    formkey.currentState.reset();
    setState(() {
      _formtype = FormType.login;
    });
  }
bool _login= false;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text('Reset Password'),
      backgroundColor: Colors.orange
      ,),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
      Container(
        width: MediaQuery.of(context).size.width,
        height: 1,
      
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Spacer(),
            Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.person,
                size: 80,
                color: Colors.white,
              ),
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 32, right: 32),
                child: Text(
                  'Signin',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            )
          ],
        ),
      ),
      SizedBox(
        height: 60.0,
      ),
      new SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: new Form(
            key: formkey,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: buildInputs() + buildsubmitButtons(),
            )),
      )
    ])));
  }

  List<Widget> buildInputs() {
    return [
      new  TextFormField(
        controller: useremail,
        keyboardType: TextInputType.emailAddress,
        decoration: new InputDecoration(
            labelText: 'Email',
         //    prefixIcon: Icon(Icons.location_city),
          border: 
            new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(65.0)
                ,)
                ),
       
      ),
     
     
      SizedBox(
        height: 10.0,
      ),
       TextFormField(
         obscureText: true,
        controller: userpassword,
        keyboardType: TextInputType.emailAddress,
        decoration: new InputDecoration(
            labelText: 'New Password',
            // prefixIcon: Icon(Icons.location_city),
          border: 
            new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(65.0)
                ,)
                ),
       
      ),
     
      SizedBox(
        height: 10,
      )
    ];
  }
// Future<List> sendresetpassword() async {
//   final response = await http.post(apipath + '/forgotPassword',
//   //  "http://192.168.1.6:3040/forgotPassword",
//   //  "https://agilemedapp-cn4rzuzz6a-el.a.run.app/createAppointment",
//    body: {
//       "username":useremail.text,
//     // "email": useremail.text,
//     // "description": _description.text,
//     // "phone_number1":_phone.text,
//     // "address1":_address.text,
//    "password": userpassword.text,
   
//   });
  
// }
//  _loginset() async {
//     await http.post(apipath + '/login',
//       //"http://192.168.1.6:3040/login",
//         body: {
//           'username': useremail.text,
//             'password': userpassword.text,
//         }).then((result) async {
//       print(result.body);
//       var data = jsonDecode(result.body);
//       if(data ['error'] == 'User does not exist'){
//         return null;
//       }else{
//  setState(() {
//       _login=true;
//     });
//     var body = json.decode(result.body);
//     SharedPreferences localStorage = await SharedPreferences.getInstance();
//     //localStorage.setString('token',result.body);
// localStorage.setString('token', body['token']);
// // return json.decode(result.body);
//    Navigator.push(context, MaterialPageRoute(builder: (context)=>Categoryset()));
//       }
   
  
//     });
//   }
  List<Widget> buildsubmitButtons() {
    if (_formtype == FormType.login) {
      return [
        new RaisedButton(
        //    color: themecolor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.black)),
            child: new Text(
              'Register',
              style: TextStyle(color: Colors.white),
            ),
            onPressed:(){
            //  validateandsubmit();
          //  _loginset();
       //   sendresetpassword();
          }
         ),
//         new FlatButton(
//             onPressed: (){
//              Navigator.pop(context)
// ;            }, child: new Text('Have an Account ? Login')),
      ];
    } else {
      return [
        new RaisedButton(
       //   color: themecolor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.red)),
          child: new Text('Register'),
          onPressed:(){
           // validateandsubmit();
        //   _loginset();
          }
           
        ),
        // new FlatButton(
        //     onPressed: movetoLogin, child: new Text('Have an Account ? Login'))
      ];
    }
  }

}