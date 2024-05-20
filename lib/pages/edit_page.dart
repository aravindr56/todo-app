import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/my_button.dart';
import '../components/my_text_fiels.dart';
import '../constants/colors.dart';

class EditPage extends StatefulWidget {
 final String title;
 final String descriptive;
   final String docId;
  const EditPage({super.key,required this.title,required this.descriptive,required this.docId});


  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController title=TextEditingController();
  TextEditingController descriptive=TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    title.text=widget.title;
    descriptive.text=widget.descriptive;
    super.initState();
  }

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
        title: Text('Edit Task',style: TextStyle(color: normal,fontSize: 20,fontWeight: FontWeight.bold),),
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
            child: MYButton(text: 'Edit Task', onPressed: (){

              FirebaseFirestore firestore=FirebaseFirestore.instance;
              firestore.collection('Tasks').doc(widget.docId).update({
                "title": title.text,
                "description":descriptive.text,
              }).
              then((value) {
                descriptive.clear();
                title.clear();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar
                  (content: Text("Task edited Succesfully"),
                  backgroundColor: Colors.green.shade400,),
                );
                Navigator.pop(context);
              }).catchError ((error){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Failed to edit task: $error'),
                  backgroundColor: Colors.red,),
                );
              });
            }, fixedSize:Size(300, 50), color: primaryColor,),
          ),
        ],
      ),
    );
  }
}




