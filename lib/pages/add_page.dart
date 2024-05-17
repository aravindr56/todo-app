import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/components/my_button.dart';
import 'package:todo_app/components/my_text_fiels.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  TextEditingController title=TextEditingController();
  TextEditingController descriptive=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: normal,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text('Add Task',style: TextStyle(color: normal,fontSize: 20,fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50,left: 14,right: 14,bottom: 25),
            child: MYTextField(text: 'Title', controller: title),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 14,right: 14,bottom: 30,top: 20),
            child: MYTextField(text: 'Descriptive', controller:descriptive),
          ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: MYButton(text: 'Add Task', onPressed: (){
              print("__________STARTED..");
              FirebaseAuth firebaseAuth=FirebaseAuth.instance;
              FirebaseFirestore fireStore= FirebaseFirestore.instance;
              fireStore.collection('Tasks').doc().set({
                'Title':title.text.trim(),
                'Description':descriptive.text.trim(),
                'User Id':firebaseAuth.currentUser !.uid,
              }).then((value) {
                print("__________eNDEDED..");
                descriptive.clear();
                title.clear();
              });
            }, fixedSize:Size(300, 50), color: primaryColor,),
          ),
        ],
      ),
    );
  }
}
