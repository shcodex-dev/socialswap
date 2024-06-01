import 'package:flutter/material.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final myHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 45, 45, 45),
      body: Container(
        height: myHeight,
        width: screenWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: myHeight * 0.04,
            ),
            Text(
              "Wallet",
              style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: myHeight * 0.02,
            ),
            Container(
              height: myHeight * 0.75,
              width: screenWidth,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      child: const Text('Create new wallet'),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/create');
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: OutlinedButton(
                        child: const Text('Import wallet'),
                        onPressed: () {
                          Navigator.of(context).pushNamed('/import');
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
