import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class SignalsPage extends StatefulWidget {
  @override
  _SignalsPageState createState() => _SignalsPageState();
}

class _SignalsPageState extends State<SignalsPage> {
  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 45, 45, 45),
        body: Column(
          children: [
            SizedBox(
              height: myHeight * 0.04,
            ),
            Text(
              "Prediction Signals",
              style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "ETH",
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold),
                ),
                Image(
                  image: NetworkImage(
                      'https://coin-images.coingecko.com/coins/images/279/large/ethereum.png'),
                  height: myWidth * 0.1,
                ),
              ],
            ),
            SizedBox(
              height: myHeight * 0.04,
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
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: StreamBuilder(
                  stream:
                      FirebaseDatabase.instance.ref().child('signals').onValue,
                  builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                    if (snapshot.hasData &&
                        snapshot.data!.snapshot.value != null) {
                      Map<dynamic, dynamic> map =
                          snapshot.data!.snapshot.value as dynamic;
                      List<dynamic> signals = map['data'];

                      signals = signals.take(15).toList().reversed.toList();

                      List<FlSpot> buySpots = [];
                      List<FlSpot> sellSpots = [];
                      List<FlSpot> holdSpots = [];
                      List<FlSpot> emaSpots = [];
                      List<FlSpot> priceSpots = [];
                      List<String> dates = [];
                      List<String> hours = [];

                      double minY = double.infinity;
                      double maxY = double.negativeInfinity;

                      int index = 0;
                      for (var signal in signals) {
                        double ema = signal['ema'];
                        double price = signal['price'];
                        String type = signal['type'];
                        String timestamp = signal['timestamp'];
                        DateTime date = DateTime.parse(timestamp)
                            .toUtc()
                            .add(Duration(hours: 12));
                        dates.add(DateFormat('MM-dd').format(date));
                        hours.add(DateFormat('HH').format(date));
                        emaSpots.add(FlSpot(index.toDouble(), ema));
                        priceSpots.add(FlSpot(index.toDouble(), price));

                        if (type == 'b') {
                          buySpots.add(FlSpot(index.toDouble(), price));
                        } else if (type == 's') {
                          sellSpots.add(FlSpot(index.toDouble(), price));
                        } else if (type == 'h') {
                          holdSpots.add(FlSpot(index.toDouble(), price));
                        }

                        if (price < minY) minY = price;
                        if (price > maxY) maxY = price;
                        if (ema < minY) minY = ema;
                        if (ema > maxY) maxY = ema;

                        index++;
                      }

                      // Add padding to the top and bottom
                      double padding = (maxY - minY) * 0.1;
                      minY -= padding;
                      maxY += padding;

                      return Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          children: [
                            Expanded(
                              child: LineChart(
                                LineChartData(
                                  minY: minY,
                                  maxY: maxY,
                                  titlesData: FlTitlesData(
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) {
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    hours[value.toInt()],
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    dates[value.toInt()],
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        interval:
                                            (dates.length / 15).toDouble(),
                                      ),
                                    ),
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: false,
                                      ),
                                    ),
                                    topTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: false,
                                      ),
                                    ),
                                    rightTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) {
                                          return Text(
                                            value.toStringAsFixed(0),
                                            style: TextStyle(
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold),
                                          );
                                        },
                                        interval: (maxY - minY) / 3,
                                      ),
                                    ),
                                  ),
                                  gridData: FlGridData(show: true),
                                  borderData: FlBorderData(show: true),
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: buySpots,
                                      barWidth: 0,
                                      color: Colors.green,
                                      dotData: FlDotData(
                                        show: true,
                                        getDotPainter:
                                            (spot, percent, barData, index) =>
                                                FlDotCirclePainter(
                                          radius: 7,
                                          color: Colors.green,
                                        ),
                                      ),
                                      isStrokeCapRound: true,
                                    ),
                                    LineChartBarData(
                                      spots: sellSpots,
                                      barWidth: 0,
                                      color: Colors.red,
                                      dotData: FlDotData(
                                        show: true,
                                        getDotPainter:
                                            (spot, percent, barData, index) =>
                                                FlDotCirclePainter(
                                          radius: 7,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                    LineChartBarData(
                                      spots: holdSpots,
                                      show: false,
                                      barWidth: 0,
                                      color: Colors.grey,
                                    ),
                                    LineChartBarData(
                                      spots: emaSpots,
                                      isCurved: true,
                                      barWidth: 2,
                                      color: Colors.blue,
                                      dotData: FlDotData(show: false),
                                      isStrokeCapRound: true,
                                    ),
                                    LineChartBarData(
                                      spots: priceSpots,
                                      isCurved: true,
                                      barWidth: 2,
                                      color: Colors.purple,
                                      dotData: FlDotData(show: false),
                                      isStrokeCapRound: true,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  LegendItem(color: Colors.green, text: 'Buy'),
                                  SizedBox(width: 10),
                                  LegendItem(color: Colors.red, text: 'Sell'),
                                  SizedBox(width: 10),
                                  LegendItem(color: Colors.blue, text: 'EMA'),
                                  SizedBox(width: 10),
                                  LegendItem(
                                      color: Colors.purple, text: 'Price'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const LegendItem({Key? key, required this.color, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          color: color,
        ),
        SizedBox(width: 5),
        Text(text),
      ],
    );
  }
}
