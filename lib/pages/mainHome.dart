// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_typing_uninitialized_variables, body_might_complete_normally_nullable, prefer_is_empty, sized_box_for_whitespace, avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:socialswap/components/item.dart';
import 'package:socialswap/components/item2.dart';
import 'package:socialswap/models/coin.dart';
import 'package:socialswap/pages/home.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  @override
  void initState() {
    getCoinMarket();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
                        'Main portfolio',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 222, 222, 222),
                          borderRadius: BorderRadius.circular(3)),
                      child: GestureDetector(
                        onTap: () => {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Home()))
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4, right: 4),
                          child: Text(
                            'Top 10 coins',
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
                    Text(
                      '\$ 7,466.20',
                      style: TextStyle(fontSize: 35),
                    ),
                    Container(
                      padding: EdgeInsets.all(myWidth * 0.02),
                      width: myWidth * 0.1,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.5)),
                      child: Image.asset(
                        'assets/icons/5.1.png',
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: myWidth * 0.07),
                child: Row(
                  children: [
                    Text(
                      '+162% all time',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: myHeight * 0.02,
              ),
              Container(
                height: 510,
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
                      height: myHeight * 0.03,
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
                          Icon(Icons.add)
                        ],
                      ),
                    ),
                    SizedBox(
                      height: myHeight * 0.02,
                    ),
                    Container(
                      height: myHeight * 0.28,
                      child: isRefreshing == true
                          ? Center(
                              child: CircularProgressIndicator(
                                color: Color(0xffFBC700),
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
                                    itemCount: 4,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return Item(
                                        item: coinMarket![index],
                                      );
                                    },
                                  ),
                                ),
                    ),
                    SizedBox(
                      height: myHeight * 0.02,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: myWidth * 0.05),
                      child: Row(
                        children: [
                          Text(
                            'Recommend to Buy',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ],
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
                                  color: Color(0xffFBC700),
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
                                    scrollDirection: Axis.horizontal,
                                    itemCount: coinMarket!.length,
                                    itemBuilder: (context, index) {
                                      return Item2(
                                        item: coinMarket![index],
                                      );
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

    setState(() {
      isRefreshing = true;
    });
    var response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    setState(() {
      isRefreshing = false;
    });
    if (response.statusCode == 200) {
      var x = response.body;
      coinMarketList = coinFromJson(x);
      setState(() {
        coinMarket = coinMarketList;
      });
    } else {
      print(response.statusCode);
    }
  }
}
