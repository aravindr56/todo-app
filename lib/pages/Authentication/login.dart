import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/components/my_button.dart';
import 'package:todo_app/components/my_text_button.dart';
import 'package:todo_app/components/my_text_fiels.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/pages/Authentication/sign_up.dart';
import 'package:todo_app/pages/home_page.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email=TextEditingController();
  TextEditingController password=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login',style: TextStyle(color: normal,fontSize: 20,fontWeight: FontWeight.bold),),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: MYTextField(text: 'Email', controller: email),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: MYTextField(text: 'Passsword', controller: password),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: MYButton(text: 'Login', onPressed:() async{
              FirebaseAuth firebaseAuth=  FirebaseAuth.instance;
              await  firebaseAuth.signInWithEmailAndPassword(email: email.text, password: password.text);

              SharedPreferences data= await SharedPreferences.getInstance();
              await data.setBool('isSignedIn', true).then((value) =>
                    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>HomePage())),
                );
              }, fixedSize:Size(300, 50), color: primaryColor,),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: MyTextButton(text: 'New User. Sign Up.', onPressed:(){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignUp()));
              }),
            ),
          ],
        ),
      ),
    );
  }
}