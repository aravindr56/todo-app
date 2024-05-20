

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/pages/add_page.dart';
import 'package:todo_app/pages/edit_page.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> tasks = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection(
        'Tasks')
        .where("userId", isEqualTo: firebaseAuth.currentUser!.uid)
        .orderBy("time", descending: true)
        .get();
    List<Map<String, dynamic>> listOfTasks = [];
    for (var i in snapshot.docs) {
      Map <String, dynamic> docs = i.data() as Map<String, dynamic>;
      docs.addAll({
        "docId": i.id
      });
      listOfTasks.add(docs);

      tasks = listOfTasks;
      setState(() {});
      setState(() {});
    }
  }
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Daily tasks', style: TextStyle(
              color: normal, fontSize: 20, fontWeight: FontWeight.bold),),
          backgroundColor: primaryColor,
          centerTitle: true,
        ),
        drawer: Drawer(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                  accountName: Text('Aravind'),
                  accountEmail: Text("aravindr330@gmail.com")),
              ListTile(
                title: Text('Delete'),
                leading: IconButton(
                  onPressed: (){},
                  icon: Icon(Icons.delete),
                ),
              ),
              Divider(),
              ListTile(
                title: Text('Log out'),
                leading: IconButton(
                  onPressed: (){},
                  icon: Icon(Icons.login_outlined),
                ),
              ),
              Divider(),
            ],
          ),
        ),
        body: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(14.0),
              child: ListTile(
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(color: Colors.blueAccent.shade700,),
                ),
                title: Text(tasks[index]['title']),
                subtitle: Text(tasks[index]['description']),

                trailing: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) =>
                              EditPage(
                                title: tasks[index]['title'],
                                descriptive: tasks[index]['description'],
                                docId: tasks[index]['docId'],
                              ))).then((value) {
                        getData();
                      });
                    },
                        icon: Icon(Icons.edit, color: normal, size: 20,)),
                    IconButton(onPressed: () {
                      FirebaseFirestore firestore= FirebaseFirestore.instance;
                      firestore.collection('Tasks').doc(tasks[index]['docId']).delete().
                      then((value){
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Task Deleted Succesfully"),
                            backgroundColor: Colors.green,));
                      });
                      setState(() {
                        getData();
                      });
                    },
                        icon: Icon(
                          Icons.delete_forever, color: normal, size: 20,)),
                  ],
                ),
              ),
            );
          },
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddPage()))
                .then((value) {
              getData();
            });
          },
          child: Text('+', style: TextStyle(color: common, fontSize: 35),),
          backgroundColor: primaryColor,
        ),
      );
    }
  }
