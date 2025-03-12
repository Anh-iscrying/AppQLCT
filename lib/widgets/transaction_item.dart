import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:demoqlct/models/transaction.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final Function deleteTransaction;

  TransactionItem({required this.transaction, required this.deleteTransaction});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      elevation: 5,
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: FittedBox(
              child: Text('${transaction.amount}'),
            ),
          ),
        ),
        title: Text(
          transaction.note,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          DateFormat('dd/MM/yyyy').format(transaction.date),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          color: Theme.of(context).colorScheme.error,
          onPressed: () => deleteTransaction(transaction.id),
        ),
      ),
    );
  }
}