import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:demoqlct/models/transaction.dart';
import 'package:uuid/uuid.dart';

class AddTransactionScreen extends StatefulWidget {
  final Function addTransaction;

  AddTransactionScreen({required this.addTransaction});

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime? _selectedDate;
  String _selectedCategory = 'Ăn uống'; // Giá trị mặc định
  TransactionType _selectedType = TransactionType.expense;

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  void _submitData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final enteredNote = _noteController.text;

    if (enteredAmount == null || enteredAmount <= 0 || _selectedDate == null) {
      return; // Hiển thị thông báo lỗi
    }

    final newTx = Transaction(
      id: Uuid().v4(),
      amount: enteredAmount,
      date: _selectedDate!,
      note: enteredNote,
      category: _selectedCategory,
      type: _selectedType,
    );

    widget.addTransaction(newTx); // Gọi hàm callback để thêm giao dịch vào danh sách

    Navigator.pop(context); // Đóng màn hình
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm giao dịch'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Số tiền'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              controller: _amountController,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Ghi chú'),
              controller: _noteController,
            ),
            Row(
              children: [
                Text(
                  _selectedDate == null
                      ? 'Chưa chọn ngày!'
                      : 'Ngày: ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}',
                ),
                TextButton(
                  child: Text(
                    'Chọn ngày',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: _presentDatePicker,
                ),
              ],
            ),
            DropdownButton<String>(
              value: _selectedCategory,
              items: [
                DropdownMenuItem(child: Text('Ăn uống'), value: 'Ăn uống'),
                DropdownMenuItem(child: Text('Giải trí'), value: 'Giải trí'),
                DropdownMenuItem(child: Text('Lương'), value: 'Lương'),
                // Thêm các danh mục khác vào đây
              ],
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
            Row(
              children: [
                Text('Loại:'),
                Radio<TransactionType>(
                  value: TransactionType.expense,
                  groupValue: _selectedType,
                  onChanged: (TransactionType? value) {
                    setState(() {
                      _selectedType = value!;
                    });
                  },
                ),
                Text('Chi tiêu'),
                Radio<TransactionType>(
                  value: TransactionType.income,
                  groupValue: _selectedType,
                  onChanged: (TransactionType? value) {
                    setState(() {
                      _selectedType = value!;
                    });
                  },
                ),
                Text('Thu nhập'),
              ],
            ),
            ElevatedButton(
              child: Text('Thêm giao dịch'),
              onPressed: _submitData,
            ),
          ],
        ),
      ),
    );
  }
}