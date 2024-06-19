// ignore_for_file: prefer_const_constructors, prefer_const_declarations, prefer_if_null_operators

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

import 'package:readmore/readmore.dart';

class CryptoNewsList extends StatefulWidget {
  const CryptoNewsList({Key? key}) : super(key: key);

  @override
  _CryptoNewsListState createState() => _CryptoNewsListState();
}

class _CryptoNewsListState extends State<CryptoNewsList> {
  List<dynamic> newsItems = [];
  @override
  void initState() {
    super.initState();
    loadFromFile();
    getNews();
  }

  Future<void> getNews() async {
    final String apiUrl = 'https://coinpaprika1.p.rapidapi.com/exchanges';
    final Map<String, String> headers = {
      'X-RapidAPI-Key': 'c1aa11a19amsh715c0f82e73c8f1p1fd6ecjsn1a72a39d59dd',
      'X-RapidAPI-Host': 'coinpaprika1.p.rapidapi.com',
    };

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: headers,
      );

      if (response.statusCode == 200) {
        List<dynamic> responseData = jsonDecode(response.body);
        await saveToFile(response.body);
        // setState(() {
        //   newsItems = responseData;
        // });

        setState(() {
          newsItems = responseData.map((item) {
            final String heading = item['name'] ?? '';
            final dynamic links = item['links'];
            final String source = links != null &&
                    links['website'] != null &&
                    links['website'].isNotEmpty
                ? links['website'][0]
                : '';
            final String description = item['description'] ?? '';

            return {
              'heading': heading,
              'source': source,
              'description': description,
            };
          }).toList();
        });
      } else {
        print('Failed to load data');
        await loadFromFile();
      }
    } catch (error) {
      print(error);
      await loadFromFile();
    }
  }

  Future<void> saveToFile(String data) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = path.join(directory.path, 'data.json');
    final file = File(filePath);
    await file.writeAsString(data);
    print('Save to Local data file found++++++++++++++++++++++++++++++++++');
  }

  Future<bool> fileExitsData() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = path.join(directory.path, 'data.json');
      final file = File(filePath);

      if (await file.exists()) {
        final fileContent = await file.readAsString();
        List<dynamic> responseData = jsonDecode(fileContent);

        // Create a list to store the news items
        List<Map<String, String>> localNewsItems = responseData.map((item) {
          final String heading = item['name'] ?? '';
          final dynamic links = item['links'];
          final String source = links != null &&
                  links['website'] != null &&
                  links['website'].isNotEmpty
              ? links['website'][0]
              : '';
          final String description = item['description'] ?? '';

          return {
            'heading': heading,
            'source': source,
            'description': description,
          };
        }).toList();

        // Update the state
        setState(() {
          print(
              'Read from Local data file found++++++++++++++++++++++++++++++++++');
          newsItems = localNewsItems;
        });

        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<void> loadFromFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = path.join(directory.path, 'data.json');
      final file = File(filePath);

      if (await file.exists()) {
        final fileContent = await file.readAsString();
        List<dynamic> responseData = jsonDecode(fileContent);

        setState(() {
          print(
              'REad from Local data file found++++++++++++++++++++++++++++++++++');
          newsItems = responseData.map((item) {
            final String heading = item['name'] ?? '';
            final dynamic links = item['links'];
            final String source = links != null &&
                    links['website'] != null &&
                    links['website'].isNotEmpty
                ? links['website'][0]
                : '';
            final String description = item['description'] ?? '';

            return {
              'heading': heading,
              'source': source,
              'description': description,
            };
          }).toList();
        });
      } else {
        print('Local data file not found');
      }
    } catch (error) {
      print('Failed to load local data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final myHeight = MediaQuery.of(context).size.height;

    Future<void> _launchUrl(Uri url) async {
      if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
      }
    }

    Widget cryptoNewsWidgetMaker(cryptoNewsObject toShow) {
      return Container(
        width: screenWidth * 0.9,
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 20.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10.0,
                  spreadRadius: 10.0)
            ]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 50.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: NetworkImage(""), fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  left: 10,
                  bottom: 7,
                  child: GestureDetector(
                    onTap: () {
                      // Open the URL when tapped
                      launchUrl(Uri.parse(toShow
                          .source)); // Ensure to import 'package:url_launcher/url_launcher.dart';
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        toShow.source,
                        style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            decoration: TextDecoration.underline,
                            color: Colors.blue),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(
                  vertical: screenWidth * 0.015,
                  horizontal: screenWidth * 0.02),
              child: Text(
                toShow.heading,
                style: TextStyle(
                    fontFamily: 'mulish',
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
                margin: EdgeInsets.only(
                    left: screenWidth * 0.02,
                    right: screenWidth * 0.02,
                    bottom: screenWidth * 0.02),
                child: ReadMoreText(
                  toShow.description,
                  trimLines: 3,
                  trimMode: TrimMode.Line,
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'mulish',
                      fontWeight: FontWeight.w500),
                )),
          ],
        ),
      );
    }

    Stream streamOfNews() {
      return Stream.periodic(Duration(seconds: 1), (count) => getNews());
    }

    return StreamBuilder(
      stream: streamOfNews(),
      builder: (context, snapshot) {
        return newsItems.length == 1
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Scaffold(
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
                            "Latest Cryptocurrency News",
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
                              child: Padding(
                                padding: const EdgeInsets.only(top: 30.0),
                                child: StreamBuilder(
                                  stream: streamOfNews(),
                                  builder: (context, snapshot) {
                                    return newsItems.length == 0
                                        ? Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : ListView.builder(
                                            itemCount: newsItems.length,
                                            itemBuilder: (context, index) {
                                              cryptoNewsObject toShow =
                                                  cryptoNewsObject(
                                                      heading: newsItems[index]
                                                          ["heading"],
                                                      source: newsItems[index]
                                                          ["source"],
                                                      description:
                                                          newsItems[index]
                                                              ["description"]);
                                              return cryptoNewsWidgetMaker(
                                                  toShow);
                                            },
                                          );
                                  },
                                ),
                              ))
                        ])));
      },
    );
  }
}

class cryptoNewsObject {
  final String heading;
  final String source;
  final String description;
  cryptoNewsObject(
      {required this.heading, required this.source, required this.description});
}
