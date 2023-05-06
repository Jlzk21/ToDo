import 'package:flutter/material.dart';
import 'package:group2/pages/addnote.dart';
import 'package:group2/pages/homepage.dart';


class Group2Application extends StatelessWidget {
  const Group2Application({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Group 2 ToDo",
      theme: ThemeData(
        primarySwatch: Colors.brown,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/addnote': (context) => const AddNote(),
      },
    );
  }
}
