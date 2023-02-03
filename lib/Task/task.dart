import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';


class Task extends StatefulWidget {
  const Task({Key? key }) : super(key: key);

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {

  String title = "";
  String description = "";
  final TextEditingController myTitle = TextEditingController();
  final TextEditingController myDescription = TextEditingController();
  createTodo() {
    DocumentReference documentReference =
    FirebaseFirestore.instance.collection("MyTask").doc(title);
    Map<String, String> todoList = {
      'todoTitle': title,
      'todoDesc': description,
    };
    documentReference.set(todoList).whenComplete(() => AlertDialog(
      title: Text(
        "Dear User",
        style: GoogleFonts.lato(fontSize: 22.0, color: Colors.grey[900]),
      ),
      content:
      const Text("Your created todo list are successfully created !"),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("OK")),
      ],
    ));
  }

  final systemColor = SystemUiOverlayStyle(
      statusBarColor: Colors.blueGrey.shade700,
      systemNavigationBarColor: Colors.white);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(systemColor);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade700,
        title: const Text("Create new"),
        elevation: 10.0,
        centerTitle: false,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        onPressed: () {
          setState(() {
            createTodo();
          });
          Navigator.pop(context);
        },
        child: const Icon(Icons.save_alt_outlined, size: 30),
      ),
      body: ListView(
        children: [
          TextFormField(
            controller: myTitle,
            onChanged: (String value) {
              title = value;
            },
            maxLines: 1,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
                color: Colors.green[900]),
            decoration: InputDecoration(
              hintText: "Title",
              border:const OutlineInputBorder(borderSide: BorderSide.none),
              hintStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                  color: Colors.green[900]),
            ),
          ),
          TextFormField(
            controller: myDescription,
            onChanged: (String value){
              description = value;
            },
            maxLines: 100,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
                color: Colors.green[900]),
            decoration: InputDecoration(
              hintText: "Desc",
              border:const OutlineInputBorder(borderSide: BorderSide.none),
              hintStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                  color: Colors.green[900]),
            ),
          ),
        ],
      ),
    );
  }
}
