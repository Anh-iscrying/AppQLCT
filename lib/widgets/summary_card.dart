import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final double income;
  final double expense;
  final double incomeByFilter;
  final double expenseByFilter;

  const SummaryCard({Key? key, required this.income, required this.expense, this.incomeByFilter = 0, this.expenseByFilter = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double balance = income - expense;

    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Tổng cộng',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '${balance.toStringAsFixed(0)} đ',
              style: TextStyle(
                  fontSize: 24,
                  color: balance >= 0 ? Colors.green : Colors.red),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text('Thu nhập', style: TextStyle(color: Colors.green)),
                    Text('${incomeByFilter.toStringAsFixed(0)} đ',
                        style: const TextStyle(color: Colors.green)),
                  ],
                ),
                Column(
                  children: [
                    Text('Chi phí', style: TextStyle(color: Colors.red)),
                    Text('${expenseByFilter.toStringAsFixed(0)} đ',
                        style: const TextStyle(color: Colors.red)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}