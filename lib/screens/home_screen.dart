import 'package:flutter/material.dart';
import 'package:demoqlct/models/transaction.dart';
import 'package:demoqlct/screens/add_transaction_screen.dart';
import 'package:demoqlct/widgets/transaction_item.dart';
import 'package:demoqlct/screens/chart_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Transaction> _transactions = [
    // Dữ liệu mẫu
    Transaction(
      id: 't1',
      amount: 1000000,
      date: DateTime.now(),
      note: 'Lương tháng 10',
      category: 'Lương',
      type: TransactionType.income,
    ),
    Transaction(
      id: 't2',
      amount: 200000,
      date: DateTime.now(),
      note: 'Ăn trưa',
      category: 'Ăn uống',
      type: TransactionType.expense,
    ),
  ];

  double get totalIncome {
    return _transactions
        .where((tx) => tx.type == TransactionType.income)
        .fold(0.0, (sum, tx) => sum + tx.amount);
  }

  double get totalExpense {
    return _transactions
        .where((tx) => tx.type == TransactionType.expense)
        .fold(0.0, (sum, tx) => sum + tx.amount);
  }

  void _addTransaction(Transaction tx) {
    setState(() {
      _transactions.add(tx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tx) => tx.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ứng dụng quản lý chi tiêu'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddTransactionScreen(addTransaction: _addTransaction),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('Tổng thu nhập: ${totalIncome.toStringAsFixed(0)}'),
                    Text('Tổng chi tiêu: ${totalExpense.toStringAsFixed(0)}'),
                    Text('Số dư: ${(totalIncome - totalExpense).toStringAsFixed(0)}'),
                  ],
                ),
              ),
            ),
            ChartScreen(transactions: _transactions), // Biểu đồ
            ..._transactions.map((tx) => TransactionItem(
              transaction: tx,
              deleteTransaction: _deleteTransaction,
            )), // Danh sách giao dịch
          ],
        ),
      ),
    );
  }
}