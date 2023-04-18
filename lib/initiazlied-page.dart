import 'package:flutter/material.dart';
import 'package:flutter_crud_with_hive_local_database/login.dart';
import 'package:flutter_crud_with_hive_local_database/main.dart';

class Initialized extends StatelessWidget {
  const Initialized({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User Management System',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: const InitializedPage(title: 'User Management System'),
    );
  }
}

class InitializedPage extends StatefulWidget {
  const InitializedPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<InitializedPage> createState() => _InitializedPageState();
}

class _InitializedPageState extends State<InitializedPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('/images/login_bg_hd.png'),
            opacity: 0.5,
            fit: BoxFit.cover,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginPage(title:'Login')),
                    );
                  },
                  child: Text('GET START',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blueAccent,
                    onPrimary: Colors.white,
                    elevation: 15,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size(300, 55),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
