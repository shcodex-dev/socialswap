import 'package:socialswap/pages/chat_page.dart';
import 'package:socialswap/pages/home.dart';
import 'package:socialswap/pages/log_in.dart';
import 'package:socialswap/pages/update_page.dart';
import 'package:socialswap/service/auth.dart';
import 'package:socialswap/service/database.dart';
import 'package:socialswap/service/shared_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewProfile extends StatefulWidget {
  const ViewProfile({super.key});

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  String? myName, myProfilePic, myUserName, myEmail;

  getthesharedpref() async {
    myName = await SharedPreferenceHelper().getDisplayName();
    myProfilePic = await SharedPreferenceHelper().getUserPic();
    myUserName = await SharedPreferenceHelper().getUserName();
    myEmail = await SharedPreferenceHelper().getUserEmail();
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    ontheload();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color.fromARGB(255, 44, 44, 44),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            Column(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 31, 31, 31),
                        Color.fromARGB(255, 165, 165, 165)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          myName!,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Center(
                        child: Text(
                          myUserName!,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  tileColor: Colors.grey[200],
                  title: Text('Update Profile',
                      style: TextStyle(
                          color: Colors.blueGrey[500],
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold)),
                  leading: Icon(
                    Icons.edit,
                    color: Colors.blueGrey[500],
                    size: 30.0,
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UpdateProfile()));
                  },
                ),
                SizedBox(height: 300.0),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 80.0),
                  child: Material(
                    elevation: 5.0,
                    child: ListTile(
                      tileColor: Color.fromARGB(255, 78, 78, 78),
                      title: Center(
                        child: Text('Logout',
                            style: TextStyle(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold)),
                      ),
                      onTap: () {
                        AuthMethods().logout();
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => LogIn()));
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 50.0, bottom: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UpdateProfile()));
                    },
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 181, 181, 181),
                          borderRadius: BorderRadius.circular(20)),
                      child: Icon(
                        Icons.edit,
                        color: Color.fromARGB(255, 44, 44, 44),
                      ),
                    ),
                  ),
                  Text(
                    "User Profile",
                    style: TextStyle(
                        color: Color.fromARGB(255, 181, 181, 181),
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      AuthMethods().logout();
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => LogIn()));
                    },
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 180, 180, 180),
                          borderRadius: BorderRadius.circular(20)),
                      child: Icon(
                        Icons.logout,
                        color: Color.fromARGB(255, 44, 44, 44),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.25,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              child: Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(
                        color: Color.fromARGB(255, 117, 117, 117),
                        width: 2,
                      ),
                    ),
                    elevation: 0,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(height: 10),
                          Center(
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(myProfilePic!),
                            ),
                          ),
                          Container(height: 10),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(
                        color: Color.fromARGB(255, 117, 117, 117),
                        width: 2,
                      ),
                    ),
                    elevation: 0,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Center(
                            child: Text(
                              "Name",
                              style: TextStyle(
                                  fontSize: 24, color: Colors.grey[800]),
                            ),
                          ),
                          Container(height: 10),
                          Center(
                            child: Text(myName.toString(),
                                style: TextStyle(
                                    fontSize: 15, color: Colors.grey[700])),
                          ),
                          Container(height: 10),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(
                        color: Color.fromARGB(255, 117, 117, 117),
                        width: 2,
                      ),
                    ),
                    elevation: 0,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Center(
                            child: Text(
                              "Username",
                              style: TextStyle(
                                  fontSize: 24, color: Colors.grey[800]),
                            ),
                          ),
                          Container(height: 10),
                          Center(
                            child: Text(myUserName.toString(),
                                style: TextStyle(
                                    fontSize: 15, color: Colors.grey[700])),
                          ),
                          Container(height: 10),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(
                        color: Color.fromARGB(255, 117, 117, 117),
                        width: 2,
                      ),
                    ),
                    elevation: 0,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Center(
                            child: Text(
                              "Email",
                              style: TextStyle(
                                  fontSize: 24, color: Colors.grey[800]),
                            ),
                          ),
                          Container(height: 10),
                          Center(
                            child: Text(myEmail.toString(),
                                style: TextStyle(
                                    fontSize: 15, color: Colors.grey[700])),
                          ),
                          Container(height: 10),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
