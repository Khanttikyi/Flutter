import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:User_Management/login.dart';
import 'package:User_Management/main.dart';

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
  late Future<ByteData> _imageByteData;
  @override
  void initState() {
    _imageByteData = rootBundle.load('assets/images/login_bg_hd.png');
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _imageByteData,
      builder: (BuildContext context, AsyncSnapshot<ByteData> snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              centerTitle: true,
            ),
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: MemoryImage(snapshot.data!.buffer.asUint8List()),
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
                                builder: (context) =>
                                    LoginPage(title:'Login')),
                          );
                        },
                        child: Text(
                          'GET START',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
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
        } else if (snapshot.hasError) {
          // An error occurred while retrieving the data
          return Text('Error retrieving data: ${snapshot.error}');
        } else {
          // Data is still being retrieved
          return CircularProgressIndicator();
        }
      },
    );
  }
}
