import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final DateTime? birthDate;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.birthDate,
  });

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
      uid: doc.id,
      name: doc.get('name') ?? '',
      email: doc.get('email') ?? '',
      birthDate: (doc.get('birthDate') as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'birthDate': birthDate,
    };
  }
}