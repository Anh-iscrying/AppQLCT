import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:demoqlct/models/transaction.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartScreen extends StatelessWidget {
  final List<Transaction> transactions;

  ChartScreen({required this.transactions});

  Map<String, double> get groupedTransactionValues {
    Map<String, double> map = {};
    for (var transaction in transactions) {
      if (transaction.type == TransactionType.expense) {
        map.update(
          transaction.category,
              (existingValue) => existingValue + transaction.amount,
          ifAbsent: () => transaction.amount,
        );
      }
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AspectRatio(
        aspectRatio: 1.3,
        child: PieChart(
          PieChartData(
            sections: getSections(),
            borderData: FlBorderData(show: false),
            centerSpaceRadius: 40,
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> getSections() {
    List<PieChartSectionData> list = [];
    groupedTransactionValues.forEach((key, value) {
      list.add(PieChartSectionData(
        color: getRandomColor(), // Hàm để tạo màu ngẫu nhiên cho mỗi section
        value: value,
        title: key,
        radius: 50,
      ));
    });
    return list;
  }

  Color getRandomColor() {
    // Hàm tạo màu ngẫu nhiên. Bạn có thể sử dụng các thư viện hỗ trợ hoặc tự viết.
    // Ví dụ đơn giản:
    return Color((Math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  }
}