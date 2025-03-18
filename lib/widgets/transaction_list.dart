import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../screens/transaction_detail_screen.dart'; // Import trang chi tiết
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function(String id, TransactionType type) onDelete;
  final Function(Transaction transaction) onEdit;

  const TransactionList({
    Key? key,
    required this.transactions,
    required this.onDelete,
    required this.onEdit,
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
          margin:
          const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          elevation: 3,
          child: InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => TransactionDetailDialog(transaction: transaction),
              );
            },
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _getColorForCategory(transaction.category),
                radius: 30,
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: FittedBox(
                    child: Text(
                      '${transaction.category.name}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              title: Text(transaction.title,
                  style: const TextStyle(fontWeight: FontWeight.bold)),

              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    NumberFormat('#,##0 VNĐ').format(transaction.amount),
                    style: const TextStyle(color: Colors.black, fontSize: 18,),
                  ),
                  Text(DateFormat('dd/MM/yyyy').format(transaction.date)),
                ],
              ),

              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      onEdit(transaction);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      onDelete(transaction.id, transaction.type);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
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