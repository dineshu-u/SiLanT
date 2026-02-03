import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //variable declaration
  final namectr = TextEditingController();
  final pwdctr = TextEditingController();
  //String errmsg = "";
  String nameError = "";
  String passError = "";
  String manError = "";
  // String confirmPassError = "";

  void signin() async {
    final res = await http.post(
      Uri.parse("http://127.0.0.1:5000/signin"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": namectr.text,
        "pwd": pwdctr.text,
      }),
    );

    final data = jsonDecode(res.body);

    if (data["success"] == true) {
      Navigator.pushReplacementNamed(context, '/');
    }
    if (data["success"] == false) {
      final error = data["error"].toString().toLowerCase();
      if (error.contains("name")) setState(() => nameError = data["error"]);
      if (error.contains("pwd")) setState(() => passError = data["error"]);
      //if (error.contains("Mandatory")) setState(() => manError = data["error"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: Text("Login Page")),
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Container(
          width: w > 600 ? 400 : w * 0.85,
          height: h > 500 ? 400 : h * 0.85,
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Login Page",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              //SizedBox(height:30),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Enter Your Name"),
              ),
              SizedBox(height: 10),
              TextField(
                controller: namectr,
                decoration: InputDecoration(
                  hintText: 'Enter Your Name',
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              if (nameError.isNotEmpty)
                Text(nameError, style: TextStyle(color: Colors.red)),

              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Enter Your Password"),
              ),
              SizedBox(height: 10),
              TextField(
                controller: pwdctr,
                decoration: InputDecoration(
                  hintText: 'Enter Your Password',
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              if (passError.isNotEmpty)
                Text(passError, style: TextStyle(color: Colors.red)),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  setState(() {
                    passError = "";
                    nameError = "";
                  });
                  signin();
                },
                child: Text("Login"),
              ),
              //if (manError.isNotEmpty)
              //Text(manError, style: TextStyle(color: Colors.red)),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: Text("SignUp"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
