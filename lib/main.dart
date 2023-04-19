import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_crud_with_hive_local_database/user-management.dart';
import 'package:hive_flutter/hive_flutter.dart';
import './initiazlied-page.dart';
import 'dart:developer';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('user_database');
  runApp(Initialized());
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

Future<List<ByteData>> _loadAssets() async {
  List<Future<ByteData>> futures = [
    rootBundle.load('assets/images/profile.png'),
    rootBundle.load('assets/images/avatar.png'),
    rootBundle.load('assets/images/login_bg_hd.png'),
  ];

  // Wait for both asset Futures to complete
  List<ByteData> results = await Future.wait(futures);

  // Return the results as a list
  return results;
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


  void _refreshItems() {
    final data = _userDatabase.keys.map((e) {
      final item = _userDatabase.get(e);
      return {
        "key": e,
        "name": item["name"],
        "phone": item["phone"],
        "email": item["email"]
      };
    }).toList();
    setState(() {
      _recordList = data.reversed.toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController.addListener(() {
      setState(() {
        submit = _nameController.text.isNotEmpty;
      });
    });
    _refreshItems();
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
