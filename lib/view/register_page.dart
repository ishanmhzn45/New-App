import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/view/login_page.dart';

class RegisterPage extends StatelessWidget {
   RegisterPage({super.key});
  final TextEditingController name = TextEditingController(),email= TextEditingController(),password = TextEditingController();
  final _formKey =GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
             TextFormField(
              validator: (value) {
                if(value == null || value.isEmpty){
                  return 'Please Enter Your Name';
                }
                return null;
              },
              controller: name,
              decoration: const InputDecoration(
                labelText: 'Enter Name',
                hintText: 'Enter Your Name',
              ),
            ),
             TextFormField(
              validator: (value) {
                if(value == null || value.isEmpty){
                  return 'Please Enter Your Email';
                }
                return null;
              },
              controller: email,
              decoration: const InputDecoration(
                labelText: 'Enter Email',
                hintText: 'Enter Your Email',
              ),
            ),
             TextFormField(
              validator: (value) {
                if(value == null || value.isEmpty){
                  return 'Please Enter Password';
                }
                return null;
              },
              controller: password,
              decoration: const InputDecoration(
                labelText: 'Enter Password',
                hintText: 'Enter Your Password',
              ),
            ),
            TextButton(
                onPressed: () async {
                  if(_formKey.currentState!.validate()){
                    final resp = await http.post(
                        Uri.parse('http://192.168.0.106:8000/api/v1/register'),
                        body: {"name": name.text, "email": email.text, "password": password.text});
                      final decodedData = jsonDecode(resp.body);
                      debugPrint(decodedData.toString()
                    );
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginPage()));
                  }
                },
                child: const Text(
                  'Register',
                  style: TextStyle(
                    backgroundColor: Colors.green,
                    color: Colors.white,
                  ),
                )),
                
          ],
        ),
      ),
    );
  }
}
