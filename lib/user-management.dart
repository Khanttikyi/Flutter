import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:User_Management/login.dart';
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
    rootBundle.load('assets/images/user_profle.png'),
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
  double _screenWidth = 0;
  int _crossAxisCount = 1;
  double _childAspectRatio = 1;
  double _fontSize = 10;
  MediaQueryData _mediaQueryData = MediaQueryData();
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    _mediaQueryData = MediaQuery.of(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!
        .addPostFrameCallback((_) => _onAfterBuild(context));
    _nameController.addListener(() {
      setState(() {
        submit = _nameController.text.isNotEmpty;
      });
    });
    _refreshItems();
  }

  void _onAfterBuild(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    setState(() {
      _screenWidth = screenWidth;
      _crossAxisCount = _calculateCrossAxisCount(screenWidth);
      _childAspectRatio =
          _calculateChildAspectRatio(screenWidth, _crossAxisCount);
      _fontSize = _calculateFontSize(screenWidth);
    });
  }

  double _calculateFontSize(double screenWidth) {
    if (screenWidth >= 1200) {
      return 18;
    } else if (screenWidth >= 800) {
      return 10;
    } else if (screenWidth >= 370) {
      return 10;
    } else {
      return 10;
    }
  }

  int _calculateCrossAxisCount(double screenWidth) {
    if (screenWidth >= 1200) {
      return 4;
    } else if (screenWidth >= 800) {
      return 3;
    } else if (screenWidth >= 370) {
      return 2;
    } else {
      return 1;
    }
  }

  double _calculateChildAspectRatio(double screenWidth, int crossAxisCount) {
    return screenWidth / crossAxisCount / 150;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ByteData>>(
        future: _loadAssets(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            ByteData firstImageData = snapshot.data![0];
            ByteData secondImageData = snapshot.data![3];
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
                drawer: Drawer(
                  width: _screenWidth>=1200?370:220,
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
                      //     =scrollDirection: Axis.horizontal,
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
                            crossAxisCount: _crossAxisCount,
                            childAspectRatio: _childAspectRatio,
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

  Widget card(String name, String phone, String email, index,
      BuildContext context, img) {
    return Card(
       color: Colors.white,
      elevation: 20,
      borderOnForeground: true,
      shadowColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),side: BorderSide(color:Colors.blueGrey,width: 1)),
      child: Container(
        // margin: EdgeInsets.all(15),
        
        child: Padding(
            padding: EdgeInsets.all(3),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.lightBlue,
                        width: 3.0,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.memory(
                          img.buffer.asUint8List(),
                          width: 45,
                          height: 45,
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              email,
                              style: TextStyle(),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              phone,
                              style: TextStyle(),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                _screenWidth >= 1200
                    ? Divider()
                    : SizedBox(
                        height: 5,
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                          child: Opacity(
                            opacity: 0.8,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.lightBlue, // background color
                                onPrimary: Colors.white, // text color
                                textStyle: TextStyle(fontSize: _fontSize),
                              ),
                              onPressed: () {
                                _showUserForm(
                                    context, _recordList[index]['key']);
                              },
                              icon: Icon(
                                Icons.edit,
                                size: _fontSize,
                              ),
                              label: Text('Edit'),
                            ),
                          )),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: Opacity(
                          opacity: 0.8,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.red, // background color
                                onPrimary: Colors.white, // text color
                                textStyle: TextStyle(fontSize: _fontSize)),
                            onPressed: () {
                              _deleteEntry(_recordList[index]['key']);
                            },
                            icon: Icon(
                              Icons.delete,
                              size: _fontSize,
                            ),
                            label: Text('Delete'),
                          ),
                        ),
                      ),
                    )
                    // Container(
                    //   child: Column(children: [
                    //     ElevatedButton.icon(
                    //       style: ElevatedButton.styleFrom(
                    //         primary: Colors.lightBlue, // background color
                    //         onPrimary: Colors.white, // text color
                    //         textStyle: TextStyle(fontSize: _fontSize),
                    //       ),
                    //       onPressed: () {
                    //         _showUserForm(context, _recordList[index]['key']);
                    //       },
                    //       icon: Icon(
                    //         Icons.edit,
                    //         size: _fontSize,
                    //       ),
                    //       label: Text('Edit'),
                    //     ),
                    //   ]),
                    // ),
                    // Container(
                    //   child: Column(children: [
                    //     ElevatedButton.icon(
                    //       style: ElevatedButton.styleFrom(
                    //           primary: Colors.red, // background color
                    //           onPrimary: Colors.white, // text color
                    //           textStyle: TextStyle(fontSize: _fontSize)),
                    //       onPressed: () {
                    //         _deleteEntry(_recordList[index]['key']);
                    //       },
                    //       icon: Icon(
                    //         Icons.delete,
                    //         size: _fontSize,
                    //       ),
                    //       label: Text('Delete'),
                    //     ),
                    //   ]),
                    // ),
                  ],
                ),
              ],
            )),
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
