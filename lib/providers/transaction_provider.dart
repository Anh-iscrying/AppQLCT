// transaction_provider.dart
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/transaction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionProvider with ChangeNotifier {
  String? uid;

  TransactionProvider({this.uid});

  List<MyTransaction> _incomeTransactions = [];
  List<MyTransaction> _expenseTransactions = [];

  List<MyTransaction> get incomeTransactions => [..._incomeTransactions];
  List<MyTransaction> get expenseTransactions => [..._expenseTransactions];

  Future<void> addTransaction(
      String title,
      double amount,
      DateTime date,
      TransactionType type,
      Category category,
      String note,
      ) async {
    if (uid == null) {
      print("Lỗi: UID người dùng chưa được thiết lập.");
      return; // Hoặc throw một exception
    }

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
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('transactions')
          .doc(newTx.id)
          .set(newTx.toMap());
      notifyListeners();
    } catch (error) {
      print("Lỗi khi thêm giao dịch vào Firestore: $error");
      // Xử lý lỗi (ví dụ: hiển thị thông báo cho người dùng)
    }
  }

  // Hàm sửa giao dịch
  Future<void> updateTransaction(MyTransaction updatedTx) async {
    if (uid == null) {
      print("Lỗi: UID người dùng chưa được thiết lập.");
      return;
    }

    final txIndex = _getTransactionIndex(updatedTx.id, updatedTx.type);
    if (txIndex >= 0) {
      if (updatedTx.type == TransactionType.income) {
        _incomeTransactions[txIndex] = updatedTx;
      } else {
        _expenseTransactions[txIndex] = updatedTx;
      }

      // Cập nhật trên Firestore
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('transactions')
            .doc(updatedTx.id)
            .update(updatedTx.toMap());
        notifyListeners();
      } catch (error) {
        print("Lỗi khi cập nhật giao dịch trên Firestore: $error");
        // Xử lý lỗi
      }
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
  Future<void> deleteTransaction(String id, TransactionType type) async {
    if (uid == null) {
      print("Lỗi: UID người dùng chưa được thiết lập.");
      return;
    }
    try {
      if (type == TransactionType.income) {
        _incomeTransactions.removeWhere((tx) => tx.id == id);
      } else {
        _expenseTransactions.removeWhere((tx) => tx.id == id);
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('transactions')
          .doc(id)
          .delete();
      notifyListeners();
    } catch (error) {
      print("Lỗi khi xóa giao dịch trên Firestore: $error");
      // Xử lý lỗi
    }
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

  Future<void> loadExpenseTransactions(String uid) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('transactions')
          .where('type', isEqualTo: TransactionType.expense.toString())
          .get();

      _expenseTransactions = snapshot.docs.map((doc) => MyTransaction.fromMap(doc.data() as Map<String, dynamic>)).toList();
      notifyListeners();
    } catch (e) {
      print('Error loading expense transactions: $e');
    }
  }

  Future<void> loadIncomeTransactions(String uid) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('transactions')
          .where('type', isEqualTo: TransactionType.income.toString())
          .get();

      _incomeTransactions = snapshot.docs.map((doc) => MyTransaction.fromMap(doc.data() as Map<String, dynamic>)).toList();
      notifyListeners();
    } catch (e) {
      print('Error loading income transactions: $e');
    }
  }

  void clearTransactions() {
    _expenseTransactions.clear();
    _incomeTransactions.clear();
    notifyListeners();
  }

  //Clear UID
  void clearUID(){
    uid = null;
    notifyListeners();
  }
}