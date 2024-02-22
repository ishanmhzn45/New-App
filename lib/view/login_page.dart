import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/view/home_screen.dart';


class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final TextEditingController email = TextEditingController(), password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              validator : (value){
                if(value == null  || value.isEmpty) {
                  return 'Please Enter Your Email';
                }
                return null;
              },
              controller: email,
              decoration: const InputDecoration(
                labelText: 'Enter Email',
              ),
            ),
            TextFormField(
              validator : (value){
                if(value == null  || value.isEmpty) {
                  return 'Please Enter Your Password';
                }
                return null;
              },
              controller: password,
              decoration: const InputDecoration(
                labelText: 'Enter Password',
              ),
            ),
            TextButton(
              onPressed: () async{
                try{
                  if(_formKey.currentState!.validate()){
                    final resp = await http.post(
                    Uri.parse('http://192.168.0.106:8000/api/v1/login'),
                    body: {"email": email.text, "password": password.text});
                    final decodedData = resp.body;
                    debugPrint(decodedData.toString());
                    Navigator.pushReplacement(context, 
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen())
                    );
                  }
                } catch (e) {
                debugPrint('Server Error');
                showDialog(
                  context: context, 
                  builder: (context) =>  AlertDialog(
                    title: Text('Server Error'),
                    content: Text('There is an unexpected error in Server'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        }, 
                        child: Text('Ok')
                        )
                    ],
                  )
                );
                }
              },
              child: const Text('Login',
              style: TextStyle(
                backgroundColor: Colors.green,
                color: Colors.white,
              ),
              )
            )
          ],
        ),
      ),
    );
  }
}