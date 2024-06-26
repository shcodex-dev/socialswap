import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socialswap/components/navBar.dart';
import 'package:socialswap/pages/log_in.dart';
import 'dart:async';

class EmailVerificationPage extends StatefulWidget {
  @override
  _EmailVerificationPageState createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    isEmailVerified = _user!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();
      timer =
          Timer.periodic(Duration(seconds: 10), (_) => checkEmailVerified());
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> sendVerificationEmail() async {
    try {
      print("Enterd in it");
      await _user?.sendEmailVerification();
      setState(() => canResendEmail = false);
      await Future.delayed(Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } catch (e) {
      print('Error sending email verification: $e');
    }
  }

  Future<void> checkEmailVerified() async {
    User? user = _auth.currentUser;

    if (user != null) {
      print("User Exist");
      // Reload the user to get the latest state
      await user.reload();
      user = _auth.currentUser;

      setState(() {
        _user = user;
        isEmailVerified = user?.emailVerified ?? false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isEmailVerified
        ? NavBar()
        : SafeArea(
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
                      padding: const EdgeInsets.only(top: 40.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 50.0, horizontal: 20.0),
                            child: Material(
                              elevation: 5.0,
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: 400,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                padding: EdgeInsets.symmetric(
                                    vertical: 30.0, horizontal: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 40.0,
                                    ),

                                    Text(
                                      "A verification email has been sent to ${_user?.email}.",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18.0),
                                    ),
                                    SizedBox(
                                      height: 75.0,
                                    ),
                                    GestureDetector(
                                      onTap: canResendEmail
                                          ? sendVerificationEmail
                                          : null,
                                      child: Center(
                                        child: Container(
                                          width: 180,
                                          child: Material(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            elevation: 10.0,
                                            child: Center(
                                              child: Container(
                                                width: 180,
                                                padding: EdgeInsets.all(10.0),
                                                decoration: BoxDecoration(
                                                    color: Color.fromARGB(
                                                        255, 44, 44, 44),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Center(
                                                  child: Text(
                                                    "Resend Email",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18.0,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 25.0,
                                    ),
                                    // Check Verification Button //
                                    GestureDetector(
                                      onTap: () async {
                                        await checkEmailVerified();
                                        if (isEmailVerified) {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => NavBar()),
                                          );
                                        }
                                      },
                                      child: Center(
                                        child: Container(
                                          width: 180,
                                          child: Material(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            elevation: 10.0,
                                            child: Center(
                                              child: Container(
                                                width: 180,
                                                padding: EdgeInsets.all(10.0),
                                                decoration: BoxDecoration(
                                                    color: Color.fromARGB(
                                                        255, 44, 44, 44),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Center(
                                                  child: Text(
                                                    "Check Verification",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18.0,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 25,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Login with another account ",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16.0),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        LogIn()));
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
                                  ],
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
