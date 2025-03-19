import 'package:demoqlct/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
// ... (import các model dữ liệu của bạn)

Future<void> logout(BuildContext context, List<MyTransaction> transactions) async {
  // Lưu dữ liệu quản lý thu chi
  final prefs = await SharedPreferences.getInstance();
  final transactionData = jsonEncode(transactions.map((e) => e.toMap()).toList());
  await prefs.setString('transactionData', transactionData);

  // Đăng xuất
  await FirebaseAuth.instance.signOut();
}