import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/components/my_button.dart';
import 'package:todo_app/components/my_text_button.dart';
import 'package:todo_app/components/my_text_fiels.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/pages/home_page.dart';

import 'login.dart';
class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController name=TextEditingController();
  TextEditingController email=TextEditingController();
  TextEditingController password=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up',style: TextStyle(color: normal,fontSize: 20,fontWeight: FontWeight.bold),),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),

      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: MYTextField(text: 'Name', controller: name),
              ),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: MYTextField(text: 'Email', controller: email),
              ),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: MYTextField(text: 'Password', controller: password),
              ),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: MYButton(text: 'Sign Up', onPressed:() async {
                  FirebaseAuth firebaseAuth= FirebaseAuth.instance;
                 await firebaseAuth.createUserWithEmailAndPassword(email: email.text, password: password.text);
          
                  SharedPreferences data= await SharedPreferences.getInstance() ;
                  await data.setString('name', name.text);
                  await data.setString('email', email.text);
                  await data.setBool('isSignedIn', true).then((value) =>
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage())),
                  );
                }, fixedSize:Size(320, 50), color: primaryColor,),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: MyTextButton(text: 'Existing User? Login', onPressed: (){
                  Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>LoginPage()));
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}