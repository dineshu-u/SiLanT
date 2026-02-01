import 'dart:convert' show jsonEncode, jsonDecode;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/*Future<void> callApi() async {
  final res = await http.get(
    Uri.parse("https://nonetheless-sphereless-amelia.ngrok-free.dev/"),
  );
  print(res.body);
}*/

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  DateTime? dob;
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  String errorMsg = "";
  Future<void> signup(
    dynamic nameCtrl,
    dynamic emailCtrl,
    dynamic passCtrl,
  ) async {
    final res = await http.post(
      Uri.parse("https://nonetheless-sphereless-amelia.ngrok-free.dev/signup"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": nameCtrl.text,
        "email": emailCtrl.text,
        "password": passCtrl.text,
      }),
    );
    final data = jsonDecode(res.body);
    setState(() {
      errorMsg = data["error"] ?? "Signup successful";
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

                SizedBox(height: 20),
                TextField(
                  obscureText: true, // hides password
                  decoration: InputDecoration(
                    labelText: " confirm Password",
                    border: OutlineInputBorder(),
                    fillColor: Colors.white,
                  ),
                ),
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
                    signup(nameCtrl, emailCtrl, passCtrl);
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
                if (errorMsg.isNotEmpty)
                  Text(errorMsg, style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
