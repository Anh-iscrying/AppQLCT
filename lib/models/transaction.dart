class Transaction {
  String id;
  double amount;
  DateTime date;
  String note;
  String category;
  TransactionType type; // Thu nhập hay chi tiêu

  Transaction({
    required this.id,
    required this.amount,
    required this.date,
    required this.note,
    required this.category,
    required this.type,
  });
}

enum TransactionType { income, expense }