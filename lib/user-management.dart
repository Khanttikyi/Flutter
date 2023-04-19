import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_crud_with_hive_local_database/login.dart';
import 'package:hive_flutter/hive_flutter.dart';
import './initiazlied-page.dart';
import 'dart:developer';

class Nav2App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User Management',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: const UserManagementPage(title: 'User Management'),
    );
  }
}

class UserManagement extends StatelessWidget {
  const UserManagement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User Management',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: const UserManagementPage(title: 'User Management'),
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

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
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

  Widget card(String name, String phone, String email, index,
      BuildContext context, img) {
    return Card(
      color: Colors.white,
      elevation: 20,
      borderOnForeground: true,
      shadowColor: Colors.lightBlue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        // margin: EdgeInsets.all(15),
        child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Image.memory(
                  img.buffer.asUint8List(),
                  width: 50,
                  height: 50,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Text(
                      phone,
                      style: TextStyle(),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Text(
                      email,
                      style: TextStyle(),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Colors.amber,
                            ),
                            onPressed: () {
                              _showUserForm(context, _recordList[index]['key']);
                            },
                          ),
                        ],
                      ),
                      SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              _deleteEntry(_recordList[index]['key']);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ByteData>>(
        future: _loadAssets(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            ByteData firstImageData = snapshot.data![0];
            ByteData secondImageData = snapshot.data![1];
            ByteData thirdImageData = snapshot.data![2];
            return GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Scaffold(
                appBar: AppBar(
                  title: Text(widget.title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  centerTitle: true,
                ),
                endDrawer: Drawer(
                  width: 220,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      Container(
                        height: 124,
                        width:
                            180, // Set the height of the header to 120 pixels
                        child: DrawerHeader(
                          decoration: BoxDecoration(
                            color: Colors.lightBlue,
                          ),
                          child: Text(
                            'User Management',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.manage_accounts),
                        title: Text('User Management'),
                        onTap: () {
                          // Navigate to the settings screen
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.logout_outlined),
                        title: Text('Logout'),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => Login()));
                        },
                      ),
                    ],
                  ),
                ),
                body: Container(
                  height: MediaQuery.of(context).size.height,
                  // margin: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: MemoryImage(thirdImageData.buffer.asUint8List()),
                      opacity: 0.5,
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: _recordList.isEmpty
                      ? const Center(child: Text('No User Data'))
                      // : ListView.builder(
                      //     scrollDirection: Axis.horizontal,
                      //     itemCount: _recordList.length,
                      //     itemBuilder: (BuildContext context, int index) {
                      //       return card(
                      //         _recordList[index]['name'],
                      //         _recordList[index]['phone'],
                      //         _recordList[index]['email'],
                      //         index,
                      //         context,
                      //         secondImageData
                      //       );

                      //     },
                      //   ),
                      : GridView.builder(
                          itemCount: _recordList.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.79,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return card(
                                _recordList[index]['name'],
                                _recordList[index]['phone'],
                                _recordList[index]['email'],
                                index,
                                context,
                                secondImageData);
                          }),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    _showUserForm(context, null);
                  },
                  tooltip: 'add',
                  child: const Icon(Icons.add),
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
          return Material(
            type: MaterialType.transparency,
            child: Center(
              child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
              child: AlertDialog(
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
                                  // minimumSize: Size(130, 45),
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
                              child:
                                  Text(itemkey == null ? 'Create' : 'Update'),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blueAccent,
                                onPrimary: Colors.white,
                                elevation: 15,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                // minimumSize: Size(130, 45),
                              ),
                            ),
                          ]),
                        ]),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            ),
          );
        });
  }
}
