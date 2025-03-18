import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';
import '../providers/transaction_provider.dart';

class AddExpenseScreen extends StatefulWidget {
  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  Category _selectedCategory = Category.anuong;

  bool _isTitleFilled = false;

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

      transactionProvider.addTransaction(
        title,
        amount,
        _selectedDate,
        TransactionType.expense,
        _selectedCategory,
        note,
      );

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:PreferredSize(
        preferredSize: Size.fromHeight(65.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.amber,
                Color(0xFFF5F5DC),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: AppBar(
            title: const Text('Thêm Chi tiêu'),
            backgroundColor: Colors.transparent,
          ),
        ),
      ),
      body: Container(
        color: Color(0xFFF5F5DC),
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Tiêu đề',
                  labelStyle: TextStyle(
                    color: _isTitleFilled ? Colors.black : Colors.black,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber, width: 2.0),
                  ),
                ),
                controller: _titleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tiêu đề';
                  }
                  return null;
                },
                cursorColor: Colors.amber,
                onChanged: (text) {
                  setState(() {
                    _isTitleFilled = text.isNotEmpty;
                  });
                },
              ),

              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Số tiền',
                  labelStyle: TextStyle(
                    color: _isTitleFilled ? Colors.black: Colors.black,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber, width: 2.0),
                  ),
                ),
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập số tiền';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Vui lòng nhập số tiền hợp lệ';
                  }
                  return null;

                },
                cursorColor: Colors.amber,
                onChanged: (text) {
                  setState(() {
                    _isTitleFilled = text.isNotEmpty;
                  });
                },
              ),

              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Ghi chú',
                  labelStyle: TextStyle(
                    color: _isTitleFilled ? Colors.black : Colors.black,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber, width: 2.0),
                  ),
                ),
                controller: _noteController,
                cursorColor: Colors.amber,
                onChanged: (text) {
                  setState(() {
                    _isTitleFilled = text.isNotEmpty;
                  });
                },
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
                    child: Icon(
                      Icons.calendar_today,
                      size: 20.0,
                      color: Colors.amber,
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
                        value: Category.anuong,
                        child: Text('Ăn uống'),
                      ),
                      DropdownMenuItem(
                        value: Category.giaitri,
                        child: Text('Giải trí'),
                      ),
                      DropdownMenuItem(
                        value: Category.suckhoe,
                        child: Text('Sức khỏe'),
                      ),
                      DropdownMenuItem(
                        value: Category.giaoduc,
                        child: Text('Giáo dục'),
                      ),
                      DropdownMenuItem(
                        value: Category.quatang,
                        child: Text('Quà tặng'),
                      ),
                      DropdownMenuItem(
                        value: Category.taphoa,
                        child: Text('Tạp hóa'),
                      ),
                      DropdownMenuItem(
                        value: Category.giadinh,
                        child: Text('Gia đình'),
                      ),
                      DropdownMenuItem(
                        value: Category.diichuyen,
                        child: Text('Di chuyển'),
                      ),
                      DropdownMenuItem(
                        value: Category.khac,
                        child: Text('Khác'),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text('Thêm Chi tiêu'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                ),
                onPressed: _submitData,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
