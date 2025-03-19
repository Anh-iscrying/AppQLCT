// models/user.dart
// lib/models/user.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel { // Đổi tên thành UserModel
  final String uid;
  final String name;
  final String email;
  final DateTime? birthDate;

  UserModel({ // Đổi tên constructor
    required this.uid,
    required this.name,
    required this.email,
    this.birthDate,
  });

  // Factory constructor để tạo UserModel từ DocumentSnapshot
  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel( // Đổi tên constructor
      uid: doc.id,
      name: doc.get('name') ?? '',
      email: doc.get('email') ?? '',
      birthDate: (doc.get('birthDate') as Timestamp?)?.toDate(),
    );
  }

  // Chuyển đổi UserModel sang Map để lưu vào Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'birthDate': birthDate,
    };
  }
}