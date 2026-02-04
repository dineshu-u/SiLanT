import 'dart:convert' show jsonEncode, jsonDecode;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  DateTime? dob;
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final cpassCtrl = TextEditingController();

  //String errorMsg = "";
  String nameerror = "";
  String emailerror = "";
  String pwderror = "";
  String cerror = "";
  Future<void> signup(dynamic nameCtrl, dynamic emailCtrl, dynamic passCtrl,
      dynamic cpassCtrl) async {
    final res = await http.post(
      Uri.parse("http://127.0.0.1:5000/signup"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": nameCtrl.text,
        "email": emailCtrl.text,
        "password": passCtrl.text,
        "c_password": cpassCtrl.text,
      }),
    );
    final data = jsonDecode(res.body);
    final errors = data["errors"] ?? {};
    if (data["success"] == true) {
      Navigator.pushReplacementNamed(context, '/');
    }
    setState(() {
  nameerror = errors["name"] ?? "";
  emailerror = errors["email"] ?? "";
  pwderror = errors["password"] ?? "";
  cerror = errors["c_password"] ?? "";
});
   
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text("Signup")),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            width: w > 600 ? 400 : w * 0.95,
            //height: 900,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              border: Border.all(),
              //color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Column(
              //padding:Padding(padding: padding),
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "SignUp",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text("Enter Your Name"),
                if (nameerror.isNotEmpty)
                  Text(nameerror, style: TextStyle(color: Colors.red)),
                SizedBox(height: 10),
                TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    labelText: 'Enter Your Name',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Text("Enter Your Email"),
                SizedBox(height: 10),
                TextField(
                  controller: emailCtrl,
                  decoration: InputDecoration(
                    labelText: "Email",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                ),
                if (emailerror.isNotEmpty)
                  Text(emailerror, style: TextStyle(color: Colors.red)),
                SizedBox(height: 20),
                TextField(
                  controller: passCtrl,
                  obscureText: true,
                  //obscureText: true, // hides password
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                    fillColor: Colors.white,
                  ),
                ),
                if (pwderror.isNotEmpty)
                  Text(pwderror, style: TextStyle(color: Colors.red)),
                SizedBox(height: 20),
                TextField(
                  obscureText: true, // hides password
                  controller: cpassCtrl,
                  decoration: InputDecoration(
                    labelText: " confirm Password",
                    border: OutlineInputBorder(),
                    fillColor: Colors.white,
                  ),
                ),
                if (cerror.isNotEmpty)
                  Text(cerror, style: TextStyle(color: Colors.red)),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    dob = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2000),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                  },
                  child: const Text("Select Date of Birth"),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    signup(nameCtrl, emailCtrl, passCtrl, cpassCtrl);
                  },
                  child: const Text("Signup"),
                ),
                SizedBox(height: 10),
                Text("Already Have Account"),
                SizedBox(height: 4),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signin');
                  },
                  child: Text("SignIn"),
                ),
                if (nameerror.isNotEmpty)
                  Text(nameerror, style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
