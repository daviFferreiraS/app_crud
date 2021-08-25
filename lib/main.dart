import 'package:app_crud_2/loading.dart';
import 'package:app_crud_2/todolist.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
                body: Center(child: Text(snapshot.error.toString())));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          }
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: TodoList(),
              theme: ThemeData(
                scaffoldBackgroundColor: Colors.white,
                primarySwatch: Colors.cyan,
              ));
        });
  }
}
