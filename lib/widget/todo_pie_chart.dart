import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';

import '../provider/todos.dart';

class ToDoPieChart extends StatelessWidget {
  const ToDoPieChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodosProvider>(context);
    Map<String, double> dataMap = provider.dataMap;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: PieChart(
        dataMap: dataMap,
        colorList: const <Color>[
          Colors.green,
          Colors.yellow,
          Colors.orange,
          Colors.red,
          Colors.grey,
        ],
        chartValuesOptions: const ChartValuesOptions(
          showChartValuesInPercentage: true,
          decimalPlaces: 0,
        ),
      ),
    );
  }
}
