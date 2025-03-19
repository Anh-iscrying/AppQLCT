import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/transaction.dart'; // Import MyTransaction
import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionProvider with ChangeNotifier {
  String? uid;

  TransactionProvider({this.uid});

  List<MyTransaction> _incomeTransactions = [];
  List<MyTransaction> _expenseTransactions = [];

  List<MyTransaction> get incomeTransactions => [..._incomeTransactions];

  List<MyTransaction> get expenseTransactions => [..._expenseTransactions];

  void addTransaction(
      String title,
      double amount,
      DateTime date,
      TransactionType type,
      Category category,
      String note,
      ) async {
    final newTx = MyTransaction(
      id: const Uuid().v4(),
      title: title,
      amount: amount,
      date: date,
      type: type,
      category: category,
      note: note,
    );

    if (type == TransactionType.income) {
      _incomeTransactions.add(newTx);
    } else {
      _expenseTransactions.add(newTx);
    }

    // Lưu vào Firestore
    if (uid != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('transactions')
          .doc(newTx.id)
          .set({
        'title': newTx.title,
        'amount': newTx.amount,
        'date': newTx.date,
        'type': newTx.type.toString(),
        'category': newTx.category.toString(),
        'note': newTx.note,
      });
    }
    notifyListeners();
  }

  // Hàm sửa giao dịch
  void updateTransaction(MyTransaction updatedTx) async {
    final txIndex = _getTransactionIndex(updatedTx.id, updatedTx.type);
    if (txIndex >= 0) {
      if (updatedTx.type == TransactionType.income) {
        _incomeTransactions[txIndex] = updatedTx;
      } else {
        _expenseTransactions[txIndex] = updatedTx;
      }

      // Cập nhật trên Firestore
      if (uid != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('transactions')
            .doc(updatedTx.id)
            .update({
          'title': updatedTx.title,
          'amount': updatedTx.amount,
          'date': updatedTx.date,
          'type': updatedTx.type.toString(),
          'category': updatedTx.category.toString(),
          'note': updatedTx.note,
        });
      }
      notifyListeners();
    }
  }

  // Tìm index của giao dịch trong danh sách tương ứng
  int _getTransactionIndex(String id, TransactionType type) {
    if (type == TransactionType.income) {
      return _incomeTransactions.indexWhere((tx) => tx.id == id);
    } else {
      return _expenseTransactions.indexWhere((tx) => tx.id == id);
    }
  }

  // Hàm xóa giao dịch
  void deleteTransaction(String id, TransactionType type) async {
    if (type == TransactionType.income) {
      _incomeTransactions.removeWhere((tx) => tx.id == id);
    } else {
      _expenseTransactions.removeWhere((tx) => tx.id == id);
    }

    // Xóa trên Firestore
    if (uid != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('transactions')
          .doc(id)
          .delete();
    }
    notifyListeners();
  }

  // Tính tổng thu nhập
  double get totalIncome {
    return _incomeTransactions.fold(0.0, (sum, tx) => sum + tx.amount);
  }

  // Tính tổng chi phí
  double get totalExpense {
    return _expenseTransactions.fold(0.0, (sum, tx) => sum + tx.amount);
  }


  List<MyTransaction> getTransactionsByType(TransactionType type) {
    return type == TransactionType.income ? _incomeTransactions : _expenseTransactions;
  }
}