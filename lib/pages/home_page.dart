

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/pages/add_page.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily tasks',style: TextStyle(color: normal,fontSize: 20,fontWeight: FontWeight.bold),),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: ()async{

            // QuerySnapshot snapShot= await FirebaseFirestore.instance.collection('Tasks').get();
            // for(var i in snapShot.docs){
            //   Map<String,dynamic> docs= i.data() as Map<String, dynamic>;
            //   print(docs);

              FirebaseAuth firebaseAuth=FirebaseAuth.instance;
              print(firebaseAuth.currentUser!.uid);
              QuerySnapshot snapshot= await FirebaseFirestore.instance.collection("Tasks").where('User Id',isEqualTo: firebaseAuth.currentUser!.uid).get();
              for(var i in snapshot.docs){
                Map <String,dynamic> docs= i.data() as Map<String,dynamic>;
                print(docs["Title"]);
              }
            },


          // Navigator.push(context, MaterialPageRoute(builder: (context)=>AddPage()));

        child: Text('+',style: TextStyle(color: common,fontSize: 35),),
        backgroundColor: primaryColor,
      ),
    );
  }
}
