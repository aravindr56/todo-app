import 'package:flutter/material.dart';

Color primaryColor=Colors.blueAccent.shade100;
Color secondaryColor=Colors.cyanAccent.shade100;
Color normal=Colors.black;
Color common=Colors.white;


//
// FirebaseAuth firebaseAuth=FirebaseAuth.instance;
// print(firebaseAuth.currentUser!.uid);
// QuerySnapshot snapshot= await FirebaseFirestore.instance.collection("Tasks").where(''User Id'',isEqualTo: firebaseAuth.currentUser!.uid).get();
// for(var i in snapshot.docs){
// Map <String,dynamic> docs= i.data() as Map<String,dynamic>;
// print(docs);
// }

// QuerySnapshot snapShot= await FirebaseFirestore.instance.collection('Tasks').get();
// for(var i in snapShot.docs){
//   Map<String,dynamic> docs= i.data() as Map<String, dynamic>;
//   print(docs);