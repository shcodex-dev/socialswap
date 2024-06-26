import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:socialswap/components/item2.dart';
import 'package:socialswap/models/coin.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class Recommend extends StatefulWidget {
  const Recommend({super.key});

  @override
  State<Recommend> createState() => _RecommendState();
}

class _RecommendState extends State<Recommend> {
  @override
  void initState() {
    getCoinMarket();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 45, 45, 45),
        body: Container(
          height: myHeight,
          width: myWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: myHeight * 0.04,
              ),
              Text(
                "Recommend to Buy",
                style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: myHeight * 0.02,
              ),
              Container(
                height: myHeight * 0.80,
                width: myWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: myHeight * 0.03,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: myWidth * 0.08),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      ),
                    ),
                    SizedBox(
                      height: myHeight * 0.02,
                    ),
                    SizedBox(
                      height: myHeight * 0.02,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: myWidth * 0.05),
                      child: Row(
                        children: [],
                      ),
                    ),
                    SizedBox(
                      height: myHeight * 0.01,
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: myWidth * 0.03),
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
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: coinMarket!.length,
                                    itemBuilder: (context, index) {
                                      return Column(children: [
                                        Item2(
                                          item: coinMarket![index],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        )
                                      ]);
                                    },
                                  ),
                      ),
                    ),
                    SizedBox(
                      height: myHeight * 0.01,
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

  bool isRefreshing = true;

  List? coinMarket = [];
  var coinMarketList;
  Future<List<Coin>?> getCoinMarket() async {
    const url =
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&sparkline=true';

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
      coinMarketList = coinFromJson(x);
      setState(() {
        coinMarket = coinMarketList;
      });
    } else {
      print(response.statusCode);
      await loadFromFile();
    }
  }

  Future<void> loadFromFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = path.join(directory.path, 'recommend.json');
      final file = File(filePath);

      if (await file.exists()) {
        final fileContent = await file.readAsString();
        coinMarketList = coinFromJson(fileContent);
        setState(() {
          print(
              'REad from Local data file found++++++++++++++++++++++++++++++++++');
          coinMarket = coinMarketList;
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
    final filePath = path.join(directory.path, 'recommend.json');
    final file = File(filePath);
    await file.writeAsString(data);
    print('Save to Local data file found++++++++++++++++++++++++++++++++++');
  }
}
