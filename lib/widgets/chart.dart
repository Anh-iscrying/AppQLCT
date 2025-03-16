import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final TransactionType transactionType;
  final List<Transaction> transactions;

  const Chart({Key? key, required this.transactionType, required this.transactions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<Category, double> categoryTotals = {};

    for (var tx in transactions) {
      categoryTotals.update(
        tx.category,
            (value) => value + tx.amount,
        ifAbsent: () => tx.amount,
      );
    }

    List<PieChartSectionData> sections = categoryTotals.entries.map((entry) {
      double total = transactions.fold(0.0, (sum, item) => sum + item.amount);
      double percentage = total > 0 ? (entry.value / total) * 100 : 0;

      return PieChartSectionData(
        color: _getColorForCategory(entry.key),
        value: entry.value,
        title: '${entry.value.toStringAsFixed(0)}\n(${percentage.toStringAsFixed(1)}%)',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 12, // Reduce font size for better fit
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return PieChart(
      PieChartData(
        sections: sections,
        borderData: FlBorderData(show: false),
        centerSpaceRadius: 40,
        sectionsSpace: 0,
      ),
    );
  }

  Color _getColorForCategory(Category category) {
    switch (category) {
      case Category.anuong:
        return Colors.blue;
      case Category.giaitri:
        return Colors.green;
      case Category.suckhoe:
        return Colors.red;
      case Category.giaoduc:
        return Colors.orange;
      case Category.quatang:
        return Colors.purple;
      case Category.taphoa:
        return Colors.teal;
      case Category.giadinh:
        return Colors.lime;
      case Category.diichuyen:
        return Colors.indigo;
      case Category.khac:
        return Colors.amber;
      case Category.luong:
        return Colors.cyan;
      case Category.thuong:
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }
}