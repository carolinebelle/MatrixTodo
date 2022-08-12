import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';

import '../provider/todos.dart';

class ToDoPieChart extends StatelessWidget {
  const ToDoPieChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodosProvider>(context);
    Map<String, double> dataMap = provider.dataMapCompleted;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: PieChart(
        dataMap: dataMap,
        colorList: const <Color>[
          Colors.green,
          Color.fromARGB(255, 214, 198, 49),
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
