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