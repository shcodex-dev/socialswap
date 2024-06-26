import 'package:socialswap/pages/emailverification.dart';
import 'package:socialswap/pages/log_in.dart';
import 'package:socialswap/service/database.dart';
import 'package:socialswap/service/shared_pref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:flutter/services.dart' show rootBundle;

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  MemoryImage? image;
  final imagePicker = ImagePicker();

  bool btnState = false;
  final DatabaseMethods db = DatabaseMethods();

  // File picker codec //
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
      print(e);
    }
  }

  String password = "", confirmPassword = "", name = "", email = "";

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  registration() async {
    if (password != "" && password == confirmPassword) {
      try {
        if (email.startsWith("www")) {
          email = email.replaceFirst("www.", "");
        }
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        String Id = randomAlphaNumeric(10);
        String user = _emailController.text.replaceAll("@gmail.com", "");
        String updateusername =
            user.replaceFirst(user[0], user[0].toUpperCase());
        String firstletter = user.substring(0, 1).toUpperCase();

        String? imageUrl = '';
        if (image != null) {
          imageUrl = await db.uploadImage(
            bytes: image!.bytes,
            id: FirebaseAuth.instance.currentUser!.uid.toString(),
            folder: 'profilePics',
          );
        } else {
          final ByteData assetImageData =
              await rootBundle.load('assets/image/person.png');
          final Uint8List assetImageBytes = assetImageData.buffer.asUint8List();
          imageUrl = await db.uploadImage(
            bytes: assetImageBytes,
            id: FirebaseAuth.instance.currentUser!.uid.toString(),
            folder: 'profilePics',
          );
        }
        Map<String, dynamic> userInfoMap = {
          "Name": _nameController.text,
          "E-mail": _emailController.text,
          "username": updateusername.toUpperCase(),
          "SearchKey": firstletter,
          "Photo": imageUrl,
          "Id": Id,
          "privateKey": "",
          "address": "",
        };
        await DatabaseMethods().addUserDetails(userInfoMap, Id);
        await SharedPreferenceHelper().saveUserId(Id);
        await SharedPreferenceHelper()
            .saveUserDisplayName(_nameController.text);
        await SharedPreferenceHelper().saveUserEmail(_emailController.text);
        await SharedPreferenceHelper().saveUserPic(imageUrl);
        await SharedPreferenceHelper().saveUserName(
            _emailController.text.replaceAll("@gmail.com", "").toUpperCase());

        await SharedPreferenceHelper().saveStoreCheck("false");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Registration Successful',
              style: TextStyle(fontSize: 20.0),
            ),
          ),
        );
        User? userInfo = userCredential.user;
        if (userInfo != null && !userInfo.emailVerified) {
          await userInfo.sendEmailVerification();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => EmailVerificationPage()),
          );
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                'Password Provided is too Weak',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          );
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                'Account Already exists',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(
            'Password is not Right',
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      );
    }
    setState(() {
      btnState = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 2.0,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 46, 46, 46),
                      Color.fromARGB(255, 180, 180, 180)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(
                      bottom: Radius.elliptical(
                          MediaQuery.of(context).size.width, 105.0)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Text(
                            "Soical Swap",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold),
                          ),
                          Image.asset(
                            'assets/image/logo.png',
                            height: 100.0,
                            width: 100.0,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Center(
                      child: Text(
                        "Your Crypto Companion",
                        style: TextStyle(
                            color: Color.fromARGB(255, 206, 204, 204),
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500),
                      ),
                    ),

                    // Laviated Box //
                    Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 20.0),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 645,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.symmetric(
                              vertical: 30.0, horizontal: 20.0),

                          // Text Fields //
                          child: Form(
                            key: _formkey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Stack(
                                    children: [
                                      CircleAvatar(
                                        radius: 50,
                                        backgroundImage: image,
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

                                // Label and Input field for Name //m

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Name',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(height: 10.0),
                                    Container(
                                      padding: EdgeInsets.only(left: 10.0),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1.0, color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: TextFormField(
                                          controller: _nameController,
                                          validator: (value) {
                                            final numberRegExp = RegExp(r'\d');
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Please Enter Name";
                                            } else if (numberRegExp
                                                .hasMatch(value)) {
                                              return "Name should not contain numbers";
                                            }
                                            return null;
                                          },
                                          enableSuggestions: true,
                                          autocorrect: true,
                                          style: TextStyle(fontSize: 18.0),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            prefixIcon: Icon(
                                              Icons.person_outlined,
                                              color: Color(0xFF7f30fe),
                                            ),
                                          ),
                                          keyboardType:
                                              TextInputType.emailAddress),
                                    ),
                                  ],
                                ),

                                SizedBox(
                                  height: 10.0,
                                ),
                                // Label and Input field for Email //
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Email",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(height: 10.0),
                                    Container(
                                      padding: EdgeInsets.only(left: 10.0),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1.0, color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: TextFormField(
                                          controller: _emailController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Please Enter Email";
                                            } else if (!value
                                                .endsWith("@gmail.com")) {
                                              return "Please only Enter Gmail Address";
                                            }
                                            return null;
                                          },
                                          autocorrect: true,
                                          style: TextStyle(fontSize: 18.0),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            prefixIcon: Icon(
                                              Icons.mail_outline,
                                              color: Color(0xFF7f30fe),
                                            ),
                                          ),
                                          keyboardType:
                                              TextInputType.emailAddress),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                // Label and Input field for Password //
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Password",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(height: 10.0),
                                    Container(
                                      padding: EdgeInsets.only(left: 10.0),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1.0, color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: TextFormField(
                                          controller: _passwordController,
                                          validator: (value) {
                                            final numberRegExp = RegExp(r'\d');
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Please Enter Password";
                                            } else if (!numberRegExp
                                                .hasMatch(value)) {
                                              return "Password should atleast contain one numbers";
                                            } else if (value.length < 8) {
                                              return "Password should be more then 8 Character long";
                                            }
                                            return null;
                                          },
                                          obscureText: true,
                                          enableSuggestions: false,
                                          autocorrect: false,
                                          style: TextStyle(fontSize: 18.0),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            prefixIcon: Icon(
                                              Icons.password_outlined,
                                              color: Color(0xFF7f30fe),
                                            ),
                                          ),
                                          keyboardType:
                                              TextInputType.visiblePassword),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                // Label and Input field for Confirm Password //
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Confirm Password",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(height: 10.0),
                                    Container(
                                      padding: EdgeInsets.only(left: 10.0),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1.0, color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: TextFormField(
                                          controller:
                                              _confirmPasswordController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Please Enter Confirm Password";
                                            }
                                            return null;
                                          },
                                          obscureText: true,
                                          enableSuggestions: false,
                                          autocorrect: false,
                                          style: TextStyle(fontSize: 18.0),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            prefixIcon: Icon(
                                              Icons.password_outlined,
                                              color: Color(0xFF7f30fe),
                                            ),
                                          ),
                                          keyboardType: true
                                              ? TextInputType.visiblePassword
                                              : TextInputType.emailAddress),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_formkey.currentState!.validate()) {
                          setState(() {
                            email = _emailController.text;
                            name = _nameController.text;
                            password = _passwordController.text;
                            confirmPassword = _confirmPasswordController.text;
                            btnState = true;
                          });
                          registration();
                        }
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
                                          "Sign Up",
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
                    SizedBox(
                      height: 20.0,
                    ),
                    // Create an Account //
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: TextStyle(color: Colors.black, fontSize: 16.0),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LogIn()));
                          },
                          child: Text(
                            "Login Now!",
                            style: TextStyle(
                                color: Color(0xFF7f30fe),
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 20.0,
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
