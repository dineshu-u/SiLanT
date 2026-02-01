import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/pages/feed.dart';
import 'package:my_app/pages/login.dart';
import 'package:my_app/pages/signup.dart';

void main() {
  runApp(const SilantApp());
}

class SilantApp extends StatelessWidget {
  const SilantApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ FIX 1: Keep ONLY ONE MaterialApp (removed nested MaterialApp)
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute:'/signin',
      title: 'SILANT',
      routes:{
         '/':(c)=>HomePage(),
         '/signin':(c)=>Login(),
         '/signup':(c)=>SignUp()

      }
    );
  }
}

/*class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Login Page")),
      body: SingleChildScrollView(
        child: Container(
          
          child: Column(children:[
            Text("Enter Your Name")
          ]
                ),
        )
      ),
    );
  }
}

*/