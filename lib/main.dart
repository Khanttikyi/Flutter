import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:User_Management/user-management.dart';
import 'package:hive_flutter/hive_flutter.dart';
import './initiazlied-page.dart';
import 'dart:developer';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('user_database');
  Future.delayed(Duration(seconds: 10)).then((value) {
    runApp(Initialized());
  });
}

class Nav2App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
     
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User Management',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      
      home: const MyHomePage(title: 'User Management'),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool submit = false;
  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _phoneController = new TextEditingController();
  final TextEditingController _emailController = new TextEditingController();
  var newRecord = Map<String, dynamic>;
  List<Map<String, dynamic>> _recordList = [];

  final _userDatabase = Hive.box('user_database');


  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController.addListener(() {
      setState(() {
        submit = _nameController.text.isNotEmpty;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
   return Scaffold(
                appBar: AppBar(
                  title: Text(widget.title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  centerTitle: true,
                ),
                body: Text("TEXT"),
              );
  }
}
