// import 'dart:io';

import 'package:socialswap/wallet/context/wallet/wallet_provider.dart';

import 'package:socialswap/wallet/router.dart';
import 'package:socialswap/wallet/services_provider.dart';
// import 'package:socialswap/wallet/utils/http_override.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
class MainApp extends StatefulWidget {
  MainApp({Key? key}) : super(key: key);

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late Future<List<SingleChildWidget>> storesFuture;

  @override
  void initState() {
    super.initState();
    storesFuture = createProviders();
  }

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SingleChildWidget>>(
      future: storesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          return MultiProvider(
            providers: snapshot.data!,
            child: WalletProvider(
              builder: (context, store) => MaterialApp(
                debugShowCheckedModeBanner: false,
                initialRoute: '/',
                routes: getRoutes(context),
                navigatorObservers: [observer],
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                  buttonTheme: const ButtonThemeData(
                    buttonColor: Colors.blue,
                    textTheme: ButtonTextTheme.primary,
                  ),
                ),
              ),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}