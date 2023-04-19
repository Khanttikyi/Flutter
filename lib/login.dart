import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_crud_with_hive_local_database/main.dart';
import 'package:flutter_crud_with_hive_local_database/user-management.dart';
import 'dart:math';
import 'package:hive_flutter/hive_flutter.dart';
import './initiazlied-page.dart';
import 'dart:developer';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/framework.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: const LoginPage(title: 'Login'),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  var isValid = true;
  late Future<ByteData> _imageByteData;
  late Future<ByteData> __imageBgByteData;
  @override
  void initState() {
    // TODO: implement initState
    // _imageByteData = rootBundle.load('assets/images/BSS_LOGO.png');
    // __imageBgByteData = rootBundle.load('assets/images/login_bg_hd.png');
    super.initState();
  }

  Future<List<ByteData>> _loadAssets() async {
    List<Future<ByteData>> futures = [
      rootBundle.load('assets/images/login_bg_hd.png'),
      rootBundle.load('assets/images/BSS_LOGO.png'),
    ];

    // Wait for both asset Futures to complete
    List<ByteData> results = await Future.wait(futures);

    // Return the results as a list
    return results;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ByteData>>(
        future: _loadAssets(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            ByteData firstImageData = snapshot.data![0];
            ByteData secondImageData = snapshot.data![1];
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: Text("Login"),
              ),
              body: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: MemoryImage(firstImageData.buffer.asUint8List()),
                    fit: BoxFit.cover,
                    opacity: 0.1,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 80.0),
                        child: Center(
                          child: Container(
                            width: 400,
                            height: 200,
                            // child: Image.asset('/images/BSS_LOGO.png')),
                            // child: Image.memory(snapshot.data!.buffer.asUint8List()),
                            child: Image.memory(secondImageData.buffer.asUint8List()),
                          ),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 35.0, right: 35.0, top: 15, bottom: 0),
                          //padding: EdgeInsets.symmetric(horizontal: 15),
                          child: SizedBox(
                            width: 350,
                            child: TextField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'UserName',
                                  hintText: 'Enter UserName'),
                            ),
                          )),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 35.0, right: 35.0, top: 15, bottom: 0),
                        //padding: EdgeInsets.symmetric(horizontal: 15),
                        child: SizedBox(
                          width: 350,
                          child: TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Password',
                                hintText: 'Enter password'),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: isValid
                            ? null
                            : Text('UserName or Password Wrong !',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        height: 50,
                        width: 250,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(25)),
                        child: ElevatedButton(
                          onPressed: () {
                            loginUser();
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            onPrimary: Colors.white,
                            elevation: 15,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: Size(300, 55),
                          ),
                        ),
                      ),
                    ],
                  ),
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
        });
  }

  loginUser() {
    if (_usernameController.value.text == 'admin' &&
        _passwordController.value.text == 'bs123456') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => UserManagement()));
      setState(() {
        isValid = true;
      });
    } else {
      setState(() {
        isValid = false;
      });
    }
  }
}
