import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import './initiazlied-page.dart';
import 'dart:developer';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('user_database');
  runApp(Nav2App());
}

class Nav2App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => Initialized(),
        '/details': (context) => MyHomePage(title: 'User Listing'),
      },
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User Listing',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: const MyHomePage(title: 'User Listing'),
    );
  }
}

class CustomCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Column(
        children: <Widget>[
          new Image.asset('/images/profile.png'),
          new Padding(
              padding: new EdgeInsets.all(7.0),
              child: new Row(
                children: <Widget>[
                  new Padding(
                    padding: new EdgeInsets.all(7.0),
                    child: new Icon(Icons.thumb_up),
                  ),
                  new Padding(
                    padding: new EdgeInsets.all(7.0),
                    child: new Text(
                      'Like',
                      style: new TextStyle(fontSize: 18.0),
                    ),
                  ),
                  new Padding(
                    padding: new EdgeInsets.all(7.0),
                    child: new Icon(Icons.comment),
                  ),
                  new Padding(
                    padding: new EdgeInsets.all(7.0),
                    child: new Text('Comments',
                        style: new TextStyle(fontSize: 18.0)),
                  )
                ],
              ))
        ],
      ),
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

  Future<void> _saveEntry(newRecord) async {
    await _userDatabase.add(newRecord);
    _refreshItems();
  }

  Future<void> _updateEntry(int itemKey, Map<String, dynamic> item) async {
    await _userDatabase.put(itemKey, item);
    _refreshItems();
  }

  Future<void> _deleteEntry(int itemKey) async {
    await _userDatabase.delete(itemKey);
    _refreshItems();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      duration: Duration(seconds: 2),
      content: Text('User has been deleted'),
    ));
  }

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

  Widget card(
      String name, String phone, String email, index, BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 23,
      borderOnForeground: true,
      shadowColor: Colors.blue,
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        height: 50,
        child: Padding(
            padding: EdgeInsets.all(13.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  '/images/avatar.png',
                  width: 220,
                  height: 220,
                ),
                Row(
                  children: [
                    Text(
                      'Name : ' + name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Text(
                      'Phone Number : ' + phone,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Text(
                      'Email : ' + email,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(
                  height: 60,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _showUserForm(context, _recordList[index]['key']);
                          },
                          child: Text('Edit'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            onPrimary: Colors.white,
                            elevation: 15,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: Size(100, 45),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 30),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _deleteEntry(_recordList[index]['key']);
                          },
                          child: Text('Delete'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            onPrimary: Colors.white,
                            elevation: 15,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: Size(100, 45),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),

        body: Container(
          margin: EdgeInsets.all(23),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('/images/login_bg_hd.png'),
              opacity: 0.5,
              fit: BoxFit.cover,
            ),
          ),
          child: _recordList.isEmpty
              ? const Center(child: Text('No User Data'))
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _recordList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return card(
                        _recordList[index]['name'],
                        _recordList[index]['phone'],
                        _recordList[index]['email'],
                        index,
                        context);
                  },
                ),
        ),

        // body: Container(
        //   child: _recordList.isEmpty
        //       ? const Center(child: Text('No User Data'))
        //       : ListView.separated(
        //           // scrollDirection: Axis.horizontal,
        //           separatorBuilder: (context, index) => const SizedBox(
        //                 height: 25,
        //               ),
        //           padding: const EdgeInsets.all(15),
        //           itemCount: _recordList.length,
        //           itemBuilder: (context, index) {
        //             return ListTile(
        //               // dense: true,
        //               tileColor: Colors.blue.withOpacity(0.2),
        //               contentPadding: const EdgeInsets.symmetric(
        //                   vertical: 15, horizontal: 10),
        //               shape: RoundedRectangleBorder(
        //                 side: BorderSide(
        //                     width: 1, color: Colors.black.withOpacity(0.7)),
        //                 borderRadius: BorderRadius.circular(12),
        //               ),
        //               leading: CircleAvatar(
        //                 backgroundImage: AssetImage(
        //                     '/images/Avatar-Profile.png'), //NetworkImage
        //                 radius: 100,
        //                 backgroundColor: Colors.white,
        //               ), //CircleAvatar

        //               title: Row(
        //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: [
        //                   Column(
        //                     children: [
        //                       Text(
        //                         "Name   :  " + _recordList[index]["name"],
        //                         style: const TextStyle(
        //                           fontWeight: FontWeight.bold,
        //                         ),
        //                       ),
        //                     ],
        //                   ),
        //                   Column(
        //                     children: [
        //                       Text(
        //                         "Phone   :  " + _recordList[index]["phone"],
        //                         style: const TextStyle(
        //                             fontWeight: FontWeight.w400),
        //                       ),
        //                     ],
        //                   ),
        //                   Column(
        //                     children: [
        //                       Text(
        //                         "Email   :  " + _recordList[index]["email"],
        //                         style: const TextStyle(
        //                             fontWeight: FontWeight.w400),
        //                       ),
        //                     ],
        //                   ),
        //                 ],
        //               ),
        //               trailing: Row(
        //                 mainAxisSize: MainAxisSize.min,
        //                 children: [
        //                   IconButton(
        //                       onPressed: () {
        //                         _showUserForm(
        //                             context, _recordList[index]['key']);
        //                       },
        //                       icon: const Icon(
        //                         Icons.edit,
        //                         color: Colors.lightBlue,
        //                         size: 16,
        //                       )),
        //                   IconButton(
        //                       onPressed: () {
        //                         _deleteEntry(_recordList[index]['key']);
        //                       },
        //                       icon: const Icon(
        //                         Icons.delete,
        //                         color: Colors.red,
        //                         size: 16,
        //                       )),
        //                 ],
        //               ),
        //             );
        //           }),
        // ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showUserForm(context, null);
          },
          tooltip: 'add',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  submitData(itemkey) {
    // Do something here
    if (itemkey == null) {
      if (_nameController.value.text.isNotEmpty &&
          _phoneController.value.text.isNotEmpty &&
          _emailController.value.text.isNotEmpty) {
        _saveEntry({
          "name": _nameController.text,
          "phone": _phoneController.text,
          "email": _emailController.text,
        });
      } else {
        // ScaffoldMessenger.of(context)
        //     .showSnackBar(const SnackBar(
        //   duration: Duration(seconds: 4),
        //   content: Text('Please Fill the required user info'),
        // ));
      }
    }
    if (itemkey != null) {
      _updateEntry(itemkey, {
        "name": _nameController.text,
        "phone": _phoneController.text,
        "email": _emailController.text,
      });
    }
    _nameController.clear();
    _phoneController.clear();
    _emailController.clear();
    Navigator.of(context, rootNavigator: true).pop('dialog');
  }

  void _showUserForm(BuildContext ctx, int? itemkey) async {
    if (itemkey != null) {
      final existingItem =
          _recordList.firstWhere((element) => element['key'] == itemkey);
      _nameController.text = existingItem['name'];
      _phoneController.text = existingItem['phone'];
      _emailController.text = existingItem['email'];
    }
    showDialog(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            // <-- SEE HERE
            title: Text(
              itemkey == null ? 'Create New User' : 'User Detail Info',
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),

            content: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'User Name',
                        // hintText: 'User Name',
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                width: 3, color: Colors.greenAccent)),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        // hintText: 'Phone',
                        labelText: 'Phone',
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                width: 3, color: Colors.greenAccent)),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        // hintText: 'Email',
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                width: 3, color: Colors.greenAccent)),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(children: [
                      Spacer(),
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _nameController.clear();
                              _phoneController.clear();
                              _emailController.clear();
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.grey,
                              onPrimary: Colors.white,
                              elevation: 15,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              minimumSize: Size(130, 45),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      Column(children: [
                        ElevatedButton(
                          onPressed: () => submitData(itemkey),
                          child: Text(itemkey == null ? 'Create' : 'Update'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blueAccent,
                            onPrimary: Colors.white,
                            elevation: 15,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: Size(130, 45),
                          ),
                        ),
                      ]),
                    ]),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
