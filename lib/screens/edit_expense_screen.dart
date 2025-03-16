import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';
import '../providers/transaction_provider.dart';

class EditExpenseScreen extends StatefulWidget {
  final Transaction transaction;

  const EditExpenseScreen({Key? key, required this.transaction})
      : super(key: key);

  @override
  _EditExpenseScreenState createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  Category _selectedCategory = Category.anuong; // Default Expense Category

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.transaction.title;
    _amountController.text = widget.transaction.amount.toString();
    _noteController.text = widget.transaction.note;
    _selectedDate = widget.transaction.date;
    _selectedCategory = widget.transaction.category;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _presentDatePicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    );

    if (pickedDate == null) return;

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitData() {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text;
      final amount = double.parse(_amountController.text);
      final note = _noteController.text;

      final transactionProvider =
      Provider.of<TransactionProvider>(context, listen: false);

      final updatedTx = Transaction(
        id: widget.transaction.id,
        title: title,
        amount: amount,
        date: _selectedDate,
        type: TransactionType.expense,
        category: _selectedCategory,
        note: note,
      );

      transactionProvider.updateTransaction(updatedTx);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa Chi tiêu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Tiêu đề'),
                controller: _titleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tiêu đề';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Số tiền'),
                controller: _amountController,
                keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập số tiền';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Vui lòng nhập số tiền hợp lệ';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Ghi chú'),
                controller: _noteController,
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Ngày: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}',
                    ),
                  ),
                  TextButton(
                    child: const Text(
                      'Chọn ngày',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: _presentDatePicker,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  const Text('Danh mục:'),
                  const SizedBox(width: 10),
                  DropdownButton<Category>(
                    value: _selectedCategory,
                    onChanged: (Category? newValue) {
                      setState(() {
                        _selectedCategory = newValue!;
                      });
                    },
                    items: const [
                      DropdownMenuItem(
                        child: Text('Ăn uống'),
                        value: Category.anuong,
                      ),
                      DropdownMenuItem(
                        child: Text('Giải trí'),
                        value: Category.giaitri,
                      ),
                      DropdownMenuItem(
                        child: Text('Sức khỏe'),
                        value: Category.suckhoe,
                      ),
                      DropdownMenuItem(
                        child: Text('Giáo dục'),
                        value: Category.giaoduc,
                      ),
                      DropdownMenuItem(
                        child: Text('Quà tặng'),
                        value: Category.quatang,
                      ),
                      DropdownMenuItem(
                        child: Text('Tạp hóa'),
                        value: Category.taphoa,
                      ),
                      DropdownMenuItem(
                        child: Text('Gia đình'),
                        value: Category.giadinh,
                      ),
                      DropdownMenuItem(
                        child: Text('Di chuyển'),
                        value: Category.diichuyen,
                      ),
                      DropdownMenuItem(
                        child: Text('Khác'),
                        value: Category.khac,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text('Lưu Chi tiêu'),
                onPressed: _submitData,
              ),
            ],
          ),
        ),
      ),
    );
  }
}