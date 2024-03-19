import 'dart:typed_data';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:socialswap/service/database.dart';
import 'package:socialswap/service/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  String? myName, myProfilePic, myUserName, StrName, Userid, StrUsername;
  bool btnState = false;

  getthesharedpref() async {
    Userid = await SharedPreferenceHelper().getUserId();
    StrName = myName = await SharedPreferenceHelper().getDisplayName();
    myProfilePic = await SharedPreferenceHelper().getUserPic();
    StrUsername = myUserName = await SharedPreferenceHelper().getUserName();
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

  MemoryImage? image;
  String name = "", username = "";
  final imagePicker = ImagePicker();
  final DatabaseMethods db = DatabaseMethods();

  updateData() async {
    try {
      if (name != StrName) {
        await DatabaseMethods().updateName(Userid!, name);
        await SharedPreferenceHelper().saveUserDisplayName(name);
        StrName = name;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Name Updated Successfully',
              style: TextStyle(fontSize: 20.0),
            ),
          ),
        );
      }
      if (username != StrUsername) {
        if (await DatabaseMethods().checkIfUserNameExists(username)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                'Username already exists',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          );
          setState(() {
            username = myUserName = StrUsername!;
            btnState = false;
          });
          return; // Stop further execution
        }
        await DatabaseMethods()
            .updateUserName(Userid!, username, username[0].toUpperCase());
        await SharedPreferenceHelper().saveUserName(username);
        StrUsername = username;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Username Updated Successfully',
              style: TextStyle(fontSize: 20.0),
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(
            'Failed to update: ${e}',
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      );
    }
    setState(() {
      btnState = false;
    });
  }

  Future<void> pickImage() async {
    try {
      final XFile? pickedFile = await imagePicker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        final imageBytes = await pickedFile.readAsBytes();

        setState(() {
          image = MemoryImage(Uint8List.fromList(imageBytes));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(
            'Unable to Select Image',
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color.fromARGB(255, 44, 44, 44),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 50.0, bottom: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "",
                    ),
                    Text(
                      "Update Profile",
                      style: TextStyle(
                          color: Color.fromARGB(255, 182, 182, 182),
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "",
                    )
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
                        child: Center(
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(myProfilePic!),
                              ),
                              Positioned(
                                bottom: 1,
                                right: 1,
                                child: IconButton(
                                  onPressed: () {
                                    pickImage();
                                  },
                                  icon: const Icon(
                                    Icons.add_a_photo,
                                    color: Colors.teal,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                              child: TextFormField(
                                initialValue: myName,
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(color: Colors.white),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    myName = value;
                                  });
                                },
                              ),
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
                                "User Name",
                                style: TextStyle(
                                    fontSize: 24, color: Colors.grey[800]),
                              ),
                            ),
                            Container(height: 10),
                            Center(
                              child: TextFormField(
                                initialValue: myUserName,
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(color: Colors.white),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    myUserName = value;
                                  });
                                },
                              ),
                            ),
                            Container(height: 10),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          username = myUserName!;
                          name = myName!;
                          btnState = true;
                        });
                        updateData();
                      },
                      child: btnState
                          ? SpinKitCircle(
                              itemBuilder: (BuildContext context, int index) {
                                return DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: index.isEven
                                        ? Colors.black
                                        : Colors.purple,
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Container(
                                width: 130,
                                child: Material(
                                  borderRadius: BorderRadius.circular(10),
                                  elevation: 10.0,
                                  child: Center(
                                    child: Container(
                                      width: 130,
                                      padding: EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromARGB(255, 44, 44, 44),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                        child: Text(
                                          "Update",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
