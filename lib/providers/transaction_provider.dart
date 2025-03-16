import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/transaction.dart';

class TransactionProvider with ChangeNotifier {
  List<Transaction> _incomeTransactions = [];
  List<Transaction> _expenseTransactions = [];

  List<Transaction> get incomeTransactions => [..._incomeTransactions];

  List<Transaction> get expenseTransactions => [..._expenseTransactions];

  // Hàm thêm giao dịch (tự động phân loại)
  void addTransaction(
      String title,
      double amount,
      DateTime date,
      TransactionType type,
      Category category,
      String note,
      ) {
    final newTx = Transaction(
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

    notifyListeners();
  }

  // Hàm sửa giao dịch
  void updateTransaction(Transaction updatedTx) {
    final txIndex = _getTransactionIndex(updatedTx.id, updatedTx.type);
    if (txIndex >= 0) {
      if (updatedTx.type == TransactionType.income) {
        _incomeTransactions[txIndex] = updatedTx;
      } else {
        _expenseTransactions[txIndex] = updatedTx;
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
  void deleteTransaction(String id, TransactionType type) {
    if (type == TransactionType.income) {
      _incomeTransactions.removeWhere((tx) => tx.id == id);
    } else {
      _expenseTransactions.removeWhere((tx) => tx.id == id);
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


  List<Transaction> getTransactionsByType(TransactionType type) {
    return type == TransactionType.income ? _incomeTransactions : _expenseTransactions;
  }
}