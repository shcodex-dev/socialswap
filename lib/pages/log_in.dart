// ignore_for_file: sized_box_for_whitespace, use_build_context_synchronously, prefer_final_fields, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:socialswap/pages/forgotpassword.dart';
import 'package:socialswap/pages/sign_up.dart';
import 'package:socialswap/components/reuseable_widgets.dart';
import 'package:socialswap/service/database.dart';
import 'package:socialswap/service/shared_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialswap/components/navBar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => LogInState();
}

class LogInState extends State<LogIn> {
  String email = "", password = "", name = "", pic = "", username = "", id = "";
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool btnState = false;

  final _formkey = GlobalKey<FormState>();

  userLogin() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      QuerySnapshot querySnapshot =
          await DatabaseMethods().getUserbyemail(email);

      name = "${querySnapshot.docs[0]["Name"]}";
      username = "${querySnapshot.docs[0]["username"]}";
      pic = "${querySnapshot.docs[0]["Photo"]}";
      id = querySnapshot.docs[0].id;

      await SharedPreferenceHelper().saveUserDisplayName(name);
      await SharedPreferenceHelper().saveUserName(username);
      await SharedPreferenceHelper().saveUserId(id);
      await SharedPreferenceHelper().saveUserPic(pic);
      await SharedPreferenceHelper().saveUserEmail(email);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => NavBar()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              'No User Found for that Email',
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            ),
          ),
        );
        setState(() {
          btnState = false;
        });
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              'Wrong Password Provided',
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            ),
          ),
        );
        setState(() {
          btnState = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              'Something Went Wrong',
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            ),
          ),
        );
        setState(() {
          btnState = false;
        });
      }
    }
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
                      Color.fromARGB(255, 45, 45, 45),
                      Color.fromARGB(255, 181, 181, 181)
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
                    Center(child: Image.asset(
                      "assets/image/logo.png",
                      height: 100.0,
                      width: 100.0,
                    ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Center(
                      child: Text(
                        "Your Crypto Companion",
                        style: TextStyle(
                            color: Color.fromARGB(255, 181, 181, 181),
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,),
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Center(
                      child: Text(
                        "Log In",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Center(
                      child: Text(
                        "Log In to your Account",
                        style: TextStyle(
                            color: Color.fromARGB(255, 181, 181, 181),
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
                        child: SingleChildScrollView(
                          child: Container(
                            height: MediaQuery.of(context).size.height / 2.2,
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
                                  SizedBox(
                                    height: 40.0,
                                  ),
                                  // Label and Input field for Email //
                                  resuedTextField("Email", Icons.mail_outline,
                                      false, _emailController),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  // Label and Input field for Password //
                                  resuedTextField(
                                      "Password",
                                      Icons.password_outlined,
                                      true,
                                      _passwordController),

                                  SizedBox(
                                    height: 30.0,
                                  ),
                                  // Forgot Password //
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ForgotPassword()));
                                    },
                                    child: Container(
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                        "Forgot Password?",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    height: 35.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Login Button //
                    GestureDetector(
                      onTap: () {
                        if (_formkey.currentState!.validate()) {
                          setState(() {
                            email = _emailController.text;
                            password = _passwordController.text;
                            btnState = true;
                          });
                        }
                        userLogin();
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
                                              Color.fromARGB(255, 45, 45, 45),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                        child: Text(
                                          "Login",
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
                          "Don't have an account? ",
                          style: TextStyle(color: Colors.black, fontSize: 16.0),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUp()));
                          },
                          child: Text(
                            "Sign Up Now!",
                            style: TextStyle(
                                color: Color(0xFF7f30fe),
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
