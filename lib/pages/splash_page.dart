import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/pages/Authentication/sign_up.dart';
import 'package:todo_app/pages/home_page.dart';
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState(){
    super.initState();
    checkUserLogin();
  }


  Future<void> checkUserLogin() async{
    SharedPreferences data= await SharedPreferences.getInstance();
    bool ? isSignedIn=data.getBool('isSignedIn');

    if(isSignedIn != null && isSignedIn){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
    }
    else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignUp()));
    }
  }
  Widget build(BuildContext context) {
    return Scaffold (

    );
  }
}
