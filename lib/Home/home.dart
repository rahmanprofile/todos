import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Task/task.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List todos = List.empty();
  String title = "";
  String description = "";
  @override
  void initState() {
    super.initState();
    todos = ["Hello", "Hey There"];
  }

  deleteTodo(item) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyTask").doc(item);
    documentReference.delete().whenComplete(() => AlertDialog(
          title: Text(
            "Dear User",
            style: GoogleFonts.lato(fontSize: 22.0, color: Colors.grey[900]),
          ),
          content: const Text("Hey! Dear user your todo deleted successfully!"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK")),
          ],
        ));
  }

  final collection = FirebaseFirestore.instance.collection("task");
  final systemColor = SystemUiOverlayStyle(
      statusBarColor: Colors.blueGrey.shade700,
      systemNavigationBarColor: Colors.white);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(systemColor);
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            Container(
              height: 110,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blueGrey[700]
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.grey[300]
                      ),
                      child:const Icon(Icons.person,size: 60),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:const [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Surya Narayana",
                            style: TextStyle(fontSize: 20,color: Colors.white)
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Todo Pad",
                            style: TextStyle(fontSize: 18,color: Colors.white)
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade700,
        title: const Text("T O D O"),
        elevation: 10.0,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                AuthProvider().signOut();
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("MyTask").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong!");
          } else if (snapshot.hasData || snapshot.data != null) {
            return ListView.builder(
              shrinkWrap: true,
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (BuildContext context, index) {
                  QueryDocumentSnapshot<Object?>? documentSnapshot =
                      snapshot.data?.docs[index];
                  return Dismissible(
                    key: Key(index.toString()),
                    child: ListTile(
                      title: Text((documentSnapshot != null)
                          ? (documentSnapshot["todoTitle"])
                          : " "),
                      subtitle: Text((documentSnapshot != null)
                          ? ((documentSnapshot['todoDesc'] != null)
                              ? documentSnapshot['todoDesc']
                              : "")
                          : ""),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () {
                          setState(() {
                            deleteTodo((documentSnapshot != null)
                                ? (documentSnapshot["todoTitle"])
                                : "");
                          });
                        },
                      ),
                    ),
                  );
                });
          }
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const Task()));
        },
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }
}

class AuthProvider {
  void signOut() {}
}
