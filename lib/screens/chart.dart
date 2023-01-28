import 'package:chosen/chartdata.dart';
import 'package:chosen/providers/client.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WeightChart extends StatefulWidget {
  const WeightChart({Key key}) : super(key: key);

  @override
  _WeightChartState createState() => _WeightChartState();
}

double fontSize = 21;

class _WeightChartState extends State<WeightChart> {
  Color purple = Color.fromARGB(255, 95, 60, 146);
  TooltipBehavior _tooltipBehavior;
  double average = 0;
  double max = 0;
  double min = 0;
  String dateMax = '';
  String dateMin = '';
  String firstDate = '';
  double firstKg = 0;
  double opacity = 0;
  List<WeightInput> chartData = [];
  Future getChartData({@required String id}) async {
    return await WeightData.getWeightData(id: id);
  }

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true, shared: true);
    var clientID = Provider.of<Client>(context, listen: false);
    getChartData(id: clientID.getClientData['id']).then((value) {
      setState(() {
        chartData = value['chart'];
        average = value['average'];
        max = value['max'];
        min = value['min'];
        dateMax = value['dateMax'];
        dateMin = value['dateMin'];
        firstKg = value['firstKg'];
        firstDate = value['firstDate'];
      });
      chartData.length < 2 ? opacity = 0 : opacity = 1;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 95, 60, 146),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new)),
        title: Text('Praćenje kilaže'),
        backgroundColor: purple,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(20, 20, 0, 20),
              padding: EdgeInsets.fromLTRB(0, 10, 25, 10),
              height: 380,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      topLeft: Radius.circular(40))),
              child: SfCartesianChart(
                enableAxisAnimation: true,
                tooltipBehavior: _tooltipBehavior,
                primaryXAxis: CategoryAxis(
                  axisLine: AxisLine(color: purple, width: 2.5),
                  arrangeByIndex: true,
                  labelRotation: 35,
                  labelStyle: TextStyle(
                    color: purple,
                    fontSize: fontSize - 6,
                  ),
                  labelPlacement: LabelPlacement.onTicks,
                  majorGridLines: const MajorGridLines(width: 0.5),
                  tickPosition: TickPosition.inside,
                  visibleMaximum: chartData.length.toDouble() - 1,
                  visibleMinimum: chartData.length < 5
                      ? 0
                      : chartData.length.toDouble() - 5,
                ),
                primaryYAxis: NumericAxis(
                  title: AxisTitle(
                      text: 'kg',
                      textStyle: TextStyle(
                        color: purple,
                        fontSize: fontSize - 5,
                      )),
                  axisLine: AxisLine(color: purple, width: 2.5),
                  labelStyle: TextStyle(
                    color: purple,
                    fontSize: fontSize - 6,
                  ),
                  tickPosition: TickPosition.inside,
                  majorGridLines: const MajorGridLines(width: 0.5),
                  interval: min == 0
                      ? 10
                      : (max - min).toInt() / 2 <= 0
                          ? 1
                          : (max - min).toInt() / 2,
                  visibleMaximum: max + 5,
                  visibleMinimum: min == 0 ? 0 : min - 5,
                  decimalPlaces: 1,
                  edgeLabelPlacement: EdgeLabelPlacement.hide,
                ),
                series: <ChartSeries>[
                  LineSeries<WeightInput, String>(
                      enableTooltip: true,
                      name: 'kg',
                      animationDuration: 1500,
                      color: purple,
                      width: 3.0,
                      dataSource: chartData,
                      xValueMapper: (WeightInput date, _) => date.date,
                      yValueMapper: (WeightInput weight, _) => weight.weight,
                      markerSettings:
                          MarkerSettings(isVisible: true, color: purple))
                ],
                plotAreaBorderWidth: 2,
                plotAreaBorderColor: Colors.transparent,
                zoomPanBehavior: ZoomPanBehavior(
                  enablePanning: true,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            AnimatedOpacity(
              duration: Duration(milliseconds: 750),
              opacity: opacity,
              child: Extremes(
                  purple: purple,
                  extreme: 'Početna:',
                  kg: firstKg,
                  date: firstDate),
            ),
            SizedBox(
              height: 20,
            ),
            AnimatedOpacity(
              opacity: opacity,
              duration: Duration(milliseconds: 1250),
              child: Extremes(
                purple: purple,
                extreme: 'Maks:',
                kg: max,
                date: dateMax,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            AnimatedOpacity(
              opacity: opacity,
              duration: Duration(milliseconds: 2000),
              child: Extremes(
                purple: purple,
                extreme: 'Min:',
                kg: min,
                date: dateMin,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            AnimatedOpacity(
                opacity: opacity,
                duration: Duration(milliseconds: 2750),
                child: Average(color: purple, loss: average)),
            SizedBox(
              height: 25,
            )
          ],
        ),
      ),
    );
  }
}

class Extremes extends StatelessWidget {
  const Extremes({
    Key key,
    @required this.purple,
    @required this.extreme,
    @required this.kg,
    @required this.date,
  }) : super(key: key);

  final Color purple;
  final String extreme;
  final double kg;
  final String date;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: width < 330 ? 70 : 85,
          child: Text(
            extreme,
            style: TextStyle(
                fontSize: width < 330 ? fontSize - 4 : fontSize,
                color: Colors.white),
          ),
        ),
        Container(
          width: width < 330 ? 100 : 120,
          padding: EdgeInsets.all(8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Text(
            '$kg kg',
            style: TextStyle(
                fontSize: width < 330 ? fontSize - 4 : fontSize, color: purple),
          ),
        ),
        Container(
          width: width < 330 ? 100 : 120,
          padding: EdgeInsets.all(8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.indigo[400]),
              borderRadius: BorderRadius.circular(20)),
          child: Text(
            date,
            style: TextStyle(
                fontSize: width < 330 ? fontSize - 6 : fontSize - 2,
                color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class Average extends StatelessWidget {
  Average({Key key, @required this.color, @required this.loss})
      : super(key: key);
  final Color color;
  final double loss;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            spreadRadius: 2.5,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Prosjek:',
            style: TextStyle(fontSize: fontSize, color: Colors.white),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            width: 170,
            padding: EdgeInsets.all(8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Text(
              '${loss < 0 ? loss.toStringAsFixed(2) : '+' + loss.toStringAsFixed(2)} kg/tjedan',
              style: TextStyle(fontSize: fontSize, color: color),
            ),
          ),
        ],
      ),
    );
  }
}
