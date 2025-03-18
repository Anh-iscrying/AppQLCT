import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionDetailDialog extends StatelessWidget {
  final Transaction transaction;

  const TransactionDetailDialog({Key? key, required this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Container(
        child: Center(
          child: Text(
            transaction.title,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),

      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Số tiền: ',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: '${NumberFormat('#,##0').format(transaction.amount)} VNĐ',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),

                ],
              ),
            ),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Ngày: ',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: '${DateFormat('dd/MM/yyyy').format(transaction.date)}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Loại: ',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: '${transaction.type == TransactionType.income ? 'Thu nhập' : 'Chi tiêu'}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Danh mục: ',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: '${transaction.category.name}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Ghi chú:',
              style: TextStyle(fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(transaction.note.isNotEmpty ? transaction.note : 'Không có ghi chú',
                style: TextStyle(fontSize: 16,)),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.amber,
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          child: const Text(
            'Đóng',
            style: TextStyle(
              color: Colors.black, // Màu chữ
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),

      ],
    );
  }
}