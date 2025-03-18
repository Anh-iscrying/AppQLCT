import 'package:flutter/material.dart';

class Transaction {
  String id;
  String title;
  double amount;
  DateTime date;
  TransactionType type;
  Category category;
  String note;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
    required this.category,
    required this.note,
  });
}

enum TransactionType {
  income,
  expense,
}

enum Category {
  anuong,
  giaitri,
  suckhoe,
  giaoduc,
  quatang,
  taphoa,
  giadinh,
  diichuyen,
  khac,
  luong,
  thuong,
}

extension CategoryExtension on Category {
  String get name {
    switch (this) {
      case Category.anuong:
        return "Ăn uống";
      case Category.giaitri:
        return "Giải trí";
      case Category.suckhoe:
        return "Sức khỏe";
      case Category.giaoduc:
        return "Giáo dục";
      case Category.quatang:
        return "Quà tặng";
      case Category.taphoa:
        return "Tạp hóa";
      case Category.giadinh:
        return "Gia đình";
      case Category.diichuyen:
        return "Di chuyển";
      case Category.khac:
        return "Khác";
      case Category.luong:
        return "Lương";
      case Category.thuong:
        return "Thưởng";
      default:
        return "";
    }
  }
}

enum IncomeCategory{
  luong,
  thuong,
  khac,
}

extension IncomeCategoryExtension on IncomeCategory {
  String get name {
    switch (this) {
      case IncomeCategory.luong:
        return "Lương";
      case IncomeCategory.thuong:
        return "Thưởng";
      case IncomeCategory.khac:
        return "Khác";
      default:
        return "";
    }
  }
}

enum ExpenseCategory{
  anuong,
  giaitri,
  suckhoe,
  giaoduc,
  quatang,
  taphoa,
  giadinh,
  diichuyen,
  khac,
}

extension ExpenseCategoryExtension on ExpenseCategory {
  String get name {
    switch (this) {
      case ExpenseCategory.anuong:
        return "Ăn uống";
      case ExpenseCategory.giaitri:
        return "Giải trí";
      case ExpenseCategory.suckhoe:
        return "Sức khỏe";
      case ExpenseCategory.giaoduc:
        return "Giáo dục";
      case ExpenseCategory.quatang:
        return "Quà tặng";
      case ExpenseCategory.taphoa:
        return "Tạp hóa";
      case ExpenseCategory.giadinh:
        return "Gia đình";
      case ExpenseCategory.diichuyen:
        return "Di chuyển";
      case ExpenseCategory.khac:
        return "Khác";
      default:
        return "";
    }
  }
}