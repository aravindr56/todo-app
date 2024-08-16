import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/pages/Authentication/login.dart';
import 'package:todo_app/pages/add_page.dart';
import 'package:todo_app/pages/edit_page.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> tasks = [];
  String ? name;
  String ? email;

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
    }
  }
      Future<void> userData() async{
        SharedPreferences data= await SharedPreferences.getInstance();
        name = data.getString('name');
        email = data.getString('email');
      }
  @override
  void initState() {
    super.initState();
    getData();
    userData();
    setState(() {
    });
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
                  decoration: BoxDecoration(
                    color: primaryColor,
                  ),
                  accountName: Text(name ?? '',style: TextStyle(color: normal,fontSize: 20,fontWeight: FontWeight.bold),),
                  accountEmail: Text(email ?? '',style: TextStyle(color: normal,fontSize: 17,fontWeight: FontWeight.bold),),
              ),
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
                  onPressed: ()async {
                    SharedPreferences data= await SharedPreferences.getInstance();
                      data.setBool('isSignedIn', false).then((value) {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                      });
                  },
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
