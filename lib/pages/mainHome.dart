// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_typing_uninitialized_variables, body_might_complete_normally_nullable, prefer_is_empty, sized_box_for_whitespace, avoid_print


import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import 'package:socialswap/components/item.dart';
import 'package:socialswap/models/coin.dart';
import 'package:socialswap/pages/Recommendpage.dart';
import 'package:socialswap/pages/prediction.dart';
import 'package:socialswap/service/shared_pref.dart';
import 'package:socialswap/wallet/wallet_main.dart';

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

  // coin market list
  List? coinMarket = [];
  var coinMarketList;

  String chk = '';
  var chkLogin = -1;

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
                  chk == "false"  || chkLogin == -1
                      ? IconButton(
                          icon: const Icon(Icons.add, size: 50.0,), onPressed: () {
                            Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainApp()));
                          })
                      : Text(
                          '\$ 0.00',
                          style: TextStyle(fontSize: 35),
                        ),
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
                  Container(
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
                                  itemCount: 3,
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
    chk = (await SharedPreferenceHelper().getStoreCheck())!;
    chkLogin = (await SharedPreferenceHelper().getWalletBalance())! as int;

    print(chkLogin);


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

      try {
        coinMarketList = coinFromJson(x);
      } catch (e) {
        print('Error parsing JSON: $e');
      }

      setState(() {
        coinMarket = coinMarketList;
      });
    } else {
      print(response.statusCode);
    }
  }
}
