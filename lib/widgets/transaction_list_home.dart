import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionListHome extends StatelessWidget {
  final List<Transaction> transactions;

  const TransactionListHome({
    Key? key,
    required this.transactions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? const Center(child: Text('Không có giao dịch nào.'))
        : ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          elevation: 3,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: transaction.type == TransactionType.income
                  ? Colors.green
                  : Colors.red,
              radius: 30,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: FittedBox(
                  child: Text(
                    '${transaction.amount.toStringAsFixed(0)}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            title: Text(transaction.title,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(DateFormat('dd/MM/yyyy').format(transaction.date)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
            ),
          ),
        );
      },
    );
  }
}