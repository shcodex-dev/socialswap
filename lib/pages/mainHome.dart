import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:socialswap/components/item.dart';
import 'package:socialswap/components/navBar.dart';
import 'package:socialswap/models/coin.dart';
import 'package:socialswap/pages/Recommendpage.dart';
import 'package:socialswap/pages/prediction.dart';
import 'package:socialswap/service/shared_pref.dart';
import 'package:socialswap/wallet/wallet_main.dart';
import 'package:path/path.dart' as path;

class MainHome extends StatefulWidget {
  final VoidCallback navigateToMainApp;
  const MainHome({Key? key, required this.navigateToMainApp}) : super(key: key);

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  // coin market list
  List? coinMarket = [];
  var coinMarketList;
  String? chk;
  String balance = "0.0";
  double walletMoney = 0.0;

  Future<void> getassets() async {
    chk = (await SharedPreferenceHelper().getStoreCheck());
    balance = (await SharedPreferenceHelper().getWalletBalance())!;
  }

  @override
  void initState() {
    super.initState();
    getassets();
    getCoinMarket();
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: myHeight,
        width: myWidth,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 112, 143, 253),
                Color(0xffFBC700),
              ]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: myHeight * 0.03),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: myWidth * 0.02),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      'Portfolio',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 222, 222, 222),
                        borderRadius: BorderRadius.circular(3)),
                    child: GestureDetector(
                      onTap: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Recommend()))
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4, right: 4),
                        child: Text(
                          'Recommended',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: myWidth * 0.07),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  chk == "false"
                      ? Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.add,
                                size: 50.0,
                                color: Color.fromARGB(255, 45, 45, 45),
                              ),
                              onPressed: () async {
                                widget.navigateToMainApp();
                              },
                            ),
                            Text(
                              "Create Wallet",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 45, 45, 45)),
                            )
                          ],
                        )
                      : Text(
                          '\$ ' + walletMoney.toString(),
                          style: TextStyle(fontSize: 35),
                        ),
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(myWidth * 0.02),
                        width: myWidth * 0.1,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.5)),
                        child: GestureDetector(
                          onTap: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignalsPage()))
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 2, right: 2),
                            child: Image.asset(
                              'assets/icons/5.1.png',
                              height: myHeight * 0.05,
                            ),
                          ),
                        ),
                      ),
                      Text("Predictions"),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: myHeight * 0.02,
            ),
            Container(
              height: myHeight * 0.6,
              width: myWidth,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      blurRadius: 5,
                      color: Colors.grey.shade300,
                      spreadRadius: 3,
                      offset: Offset(0, 3))
                ],
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: myHeight * 0.04,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: myWidth * 0.08),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Assets',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: myHeight * 0.02,
                  ),
                  chk == "false"
                      ? Container(
                          height: myHeight * 0.48,
                        )
                      : Container(
                          height: myHeight * 0.48,
                          child: isRefreshing == true
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: Color.fromARGB(255, 81, 81, 81),
                                  ),
                                )
                              : coinMarket == null || coinMarket!.length == 0
                                  ? Padding(
                                      padding: EdgeInsets.all(myHeight * 0.06),
                                      child: Center(
                                        child: Text(
                                          'Attention this Api is free, so you cannot send multiple requests per second, please wait and try again later.',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    )
                                  : SingleChildScrollView(
                                      child: ListView.builder(
                                        itemCount: 1,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return Item(
                                            item: coinMarket![index],
                                            bal: balance,
                                          );
                                        },
                                      ),
                                    ),
                        ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  bool isRefreshing = true;

  Future<List<Coin>?> getCoinMarket() async {
    const url =
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=ethereum&sparkline=true';

    await loadFromFile();

    var response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });

    setState(() {
      isRefreshing = false;
    });

    if (response.statusCode == 200) {
      var x = response.body;
      saveToFile(response.body);

      try {
        coinMarketList = coinFromJson(x);
      } catch (e) {
        print('Error parsing JSON: $e');
      }

      setState(() {
        coinMarket = coinMarketList;
        walletMoney = coinMarketList![0].currentPrice * double.parse(balance);
      });
    } else {
      print(response.statusCode);
      await loadFromFile();
    }
  }

  Future<void> loadFromFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = path.join(directory.path, 'balance.json');
      final file = File(filePath);

      if (await file.exists()) {
        final fileContent = await file.readAsString();
        coinMarketList = coinFromJson(fileContent);
        setState(() {
          print(
              'REad from Local data file found++++++++++++++++++++++++++++++++++');
          coinMarket = coinMarketList;
          walletMoney = coinMarketList![0].currentPrice * double.parse(balance);
          isRefreshing = false;
        });
      } else {
        print("File does not exist");
        isRefreshing = true;
      }
    } catch (error) {
      isRefreshing = true;
    }
  }

  Future<void> saveToFile(String data) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = path.join(directory.path, 'balance.json');
    final file = File(filePath);
    await file.writeAsString(data);
    print('Save to Local data file found++++++++++++++++++++++++++++++++++');
  }
}
