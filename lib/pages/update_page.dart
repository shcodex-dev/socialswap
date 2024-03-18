import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
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
  String? myName, myProfilePic, myUserName, myEmail;
  bool btnState = false;

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

  MemoryImage? image;
  String name = "", email = "";
  final imagePicker = ImagePicker();
  final DatabaseMethods db = DatabaseMethods();

  updateData() async {
    try {
      if (email.startsWith("www")) {
        email = email.replaceFirst("www.", "");
      }
      if (email != FirebaseAuth.instance.currentUser!.email) {
        await FirebaseAuth.instance.currentUser!.verifyBeforeUpdateEmail(email);
        String user = email.replaceAll("@gmail.com", "");
        String updateusername =
            user.replaceFirst(user[0], user[0].toUpperCase());
        String firstletter = user.substring(0, 1).toUpperCase();
        bool emailExists = await DatabaseMethods().checkIfEmailExists(email);

        if (emailExists) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                'Email already exists',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          );
          return; // Stop further execution
        }

        Map<String, dynamic> userInfoMap = {
          "Name": name,
          "E-mail": email,
          "username": updateusername.toUpperCase(),
          "SearchKey": firstletter,
          // "Photo": imageUrl,
        };

        // Update user details

        await DatabaseMethods().updateUserDetails(
            FirebaseAuth.instance.currentUser!.uid.toString(), userInfoMap);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Update Email Successful',
              style: TextStyle(fontSize: 20.0),
            ),
          ),
        );

        // Update shared preferences
        await SharedPreferenceHelper().saveUserEmail(email);
        // await SharedPreferenceHelper().saveUserPic(imageUrl);
        await SharedPreferenceHelper().saveUserName(
          email.replaceAll("@gmail.com", "").toUpperCase(),
        );
      }
      if (name != FirebaseAuth.instance.currentUser!.displayName) {
        print("enderd");
        print(FirebaseAuth.instance.currentUser!.uid);
        await DatabaseMethods().updateUserName(
            FirebaseAuth.instance.currentUser!.uid.toString(), name);
        await SharedPreferenceHelper().saveUserDisplayName(name);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Update Name Successful',
              style: TextStyle(fontSize: 20.0),
            ),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(
            'Failed to update: ${e.message}',
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      );
    }
  }

  Future<void> pickImage() async {
    try {
      final XFile? pickedFile = await imagePicker.pickImage(
        source: ImageSource
            .gallery, // You can also use ImageSource.camera for taking a new photo
      );

      if (pickedFile != null) {
        final imageBytes = await pickedFile.readAsBytes();

        setState(() {
          image = MemoryImage(Uint8List.fromList(imageBytes));
        });
      }
    } catch (e) {
      print(e);
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
                                "Email",
                                style: TextStyle(
                                    fontSize: 24, color: Colors.grey[800]),
                              ),
                            ),
                            Container(height: 10),
                            Center(
                              child: TextFormField(
                                initialValue: myEmail,
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(color: Colors.white),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    myEmail = value;
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
                          email = myEmail!;
                          name = myName!;
                        });
                        updateData();
                      },
                      child: btnState
                          ? SpinKitCircle(
                              itemBuilder: (BuildContext context, int index) {
                                return DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: index.isEven
                                        ? Colors.red
                                        : Colors.green,
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
