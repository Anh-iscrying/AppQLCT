import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';
import '../providers/transaction_provider.dart';
import '../widgets/transaction_list.dart';
import '../widgets/chart.dart';
import 'add_income_screen.dart';
import 'add_expense_screen.dart';
import 'home_screen.dart';
import 'edit_income_screen.dart';
import 'edit_expense_screen.dart';
import 'package:intl/intl.dart';

class IncomeExpenseScreen extends StatefulWidget {
  final TransactionType transactionType;
  DateTime? selectedDate;
  TimeFilter selectedFilter;
  DateTimeRange? selectedRange;

  IncomeExpenseScreen({
    Key? key,
    required this.transactionType,
    this.selectedDate,
    required this.selectedFilter,
    this.selectedRange,
  }) : super(key: key);

  @override
  State<IncomeExpenseScreen> createState() => _IncomeExpenseScreenState();
}

class _IncomeExpenseScreenState extends State<IncomeExpenseScreen>
    with TickerProviderStateMixin {
  late TabController _timeFilterTabController;
  DateTime? _selectedDate;
  TimeFilter _selectedFilter = TimeFilter.day;
  DateTimeRange? _selectedRange;
  String _searchTerm = '';
  Category? _selectedIncomeCategory;
  Category? _selectedExpenseCategory;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
    _selectedFilter = widget.selectedFilter;
    _selectedRange = widget.selectedRange;
    _timeFilterTabController = TabController(
        length: 5,
        vsync: this,
        initialIndex: getTabIndex(widget.selectedFilter));
    _timeFilterTabController.addListener(() {
      setState(() {
        switch (_timeFilterTabController.index) {
          case 0:
            _selectedFilter = TimeFilter.day;
            _selectedDate = DateTime.now();
            break;
          case 1:
            _selectedFilter = TimeFilter.week;
            break;
          case 2:
            _selectedFilter = TimeFilter.month;
            break;
          case 3:
            _selectedFilter = TimeFilter.year;
            break;
          case 4:
            _selectedFilter = TimeFilter.range;
            break;
          default:
            _selectedFilter = TimeFilter.day;
        }
      });
    });
  }

  int getTabIndex(TimeFilter filter) {
    switch (filter) {
      case TimeFilter.day:
        return 0;
      case TimeFilter.week:
        return 1;
      case TimeFilter.month:
        return 2;
      case TimeFilter.year:
        return 3;
      case TimeFilter.range:
        return 4;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);

    List<Transaction> transactions = [];
    transactions = getFilteredTransactions(
      transactionProvider,
      _selectedFilter,
      _selectedDate,
      _selectedRange,
      widget.transactionType,
      _searchTerm,
      widget.transactionType == TransactionType.income ? _selectedIncomeCategory : _selectedExpenseCategory,
    );

    return Scaffold(
      appBar: PreferredSize(
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
            title: Text(widget.transactionType == TransactionType.income
                ? 'Quản lý Thu nhập'
                : 'Quản lý Chi tiêu'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                      widget.transactionType == TransactionType.income
                          ? AddIncomeScreen()
                          : AddExpenseScreen(),
                    ),
                  );
                },
              ),
            ],
            backgroundColor: Colors.transparent,
          ),
        ),
      ),
      body: Container(
        color: const Color(0xFFF5F5DC),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 7,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Tìm kiếm theo tên',

                          prefixIcon: Icon(Icons.search,),
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchTerm = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: DropdownButton<Category>(
                        value: widget.transactionType == TransactionType.income ? _selectedIncomeCategory : _selectedExpenseCategory,
                        hint: const Text('Bộ lọc'),
                        onChanged: (Category? newValue) {
                          setState(() {
                            if (widget.transactionType == TransactionType.income) {
                              _selectedIncomeCategory = newValue;
                            } else {
                              _selectedExpenseCategory = newValue;
                            }
                          });
                        },
                        items: _buildCategoryDropdownMenuItems(),
                        isExpanded: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            TabBar(
              controller: _timeFilterTabController,
              isScrollable: true,
              indicatorColor: Colors.amber,
              labelColor: Colors.amber,
              tabs: const [
                Tab(text: 'Ngày'),
                Tab(text: 'Tuần'),
                Tab(text: 'Tháng'),
                Tab(text: 'Năm'),
                Tab(text: 'Khoảng thời gian'),
              ],
            ),
            // Bộ lọc thời gian
            if (_selectedFilter == TimeFilter.day && _selectedDate != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        setState(() {
                          _selectedDate =
                              _selectedDate!.subtract(const Duration(days: 1));
                        });
                      },
                    ),
                    InkWell(
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2099),
                          initialDatePickerMode: DatePickerMode.year,
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _selectedDate = pickedDate;
                          });
                        }
                      },
                      child: Text(
                        DateFormat('dd/MM/yyyy').format(_selectedDate!),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () {
                        setState(() {
                          _selectedDate =
                              _selectedDate!.add(const Duration(days: 1));
                        });
                      },
                    ),
                  ],
                ),
              ),
            if (_selectedFilter == TimeFilter.week && _selectedDate != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        setState(() {
                          _selectedDate = _getPreviousWeek(_selectedDate!);
                        });
                      },
                    ),
                    InkWell(
                      onTap: () async {
                        DateTime initialDate = _selectedDate ?? DateTime.now();
                        DateTime firstDayOfWeek = initialDate.subtract(Duration(
                            days: initialDate.weekday -
                                1 >
                                0
                                ? initialDate.weekday - 1
                                : 6));

                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: firstDayOfWeek,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2099),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _selectedDate = pickedDate;
                          });
                        }
                      },
                      child: Text(
                        " ${DateFormat('dd/MM/yyyy').format(_getFirstDayOfWeek(_selectedDate!))} - ${DateFormat('dd/MM/yyyy').format(_getLastDayOfWeek(_selectedDate!))}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () {
                        setState(() {
                          _selectedDate = _getNextWeek(_selectedDate!);
                        });
                      },
                    ),
                  ],
                ),
              ),
            if (_selectedFilter == TimeFilter.month && _selectedDate != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        setState(() {
                          _selectedDate = DateTime(_selectedDate!.year,
                              _selectedDate!.month - 1, 1);
                        });
                      },
                    ),
                    InkWell(
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2099),
                          initialDatePickerMode: DatePickerMode.year,
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _selectedDate =
                                DateTime(pickedDate.year, pickedDate.month, 1);
                          });
                        }
                      },
                      child: Text(
                        DateFormat('MM/yyyy').format(_selectedDate!),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () {
                        setState(() {
                          _selectedDate = DateTime(_selectedDate!.year,
                              _selectedDate!.month + 1, 1);
                        });
                      },
                    ),
                  ],
                ),
              ),
            if (_selectedFilter == TimeFilter.year && _selectedDate != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        setState(() {
                          _selectedDate =
                              DateTime(_selectedDate!.year - 1, 1, 1);
                        });
                      },
                    ),
                    InkWell(
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2099),
                          initialDatePickerMode: DatePickerMode.year,
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _selectedDate = DateTime(pickedDate.year, 1, 1);
                          });
                        }
                      },
                      child: Text(
                        "${_selectedDate!.year}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () {
                        setState(() {
                          _selectedDate =
                              DateTime(_selectedDate!.year + 1, 1, 1);
                        });
                      },
                    ),
                  ],
                ),
              ),
            if (_selectedFilter == TimeFilter.range)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () async {
                        final pickedRange = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2099),
                          initialDateRange: _selectedRange,
                        );
                        setState(() {
                          _selectedRange = pickedRange;
                          if (pickedRange != null) {
                            _selectedDate = _selectedRange!.start;
                          }
                        });

                        setState(() {
                          _selectedRange = DateTimeRange(
                              start: _selectedRange!.start
                                  .subtract(const Duration(days: 7)),
                              end: _selectedRange!.end
                                  .subtract(const Duration(days: 7)));
                        });
                      },
                    ),
                    InkWell(
                      onTap: () async {
                        final pickedRange = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2099),
                          initialDateRange: _selectedRange,
                        );
                        setState(() {
                          _selectedRange = pickedRange;
                          if (pickedRange != null) {
                            _selectedDate = _selectedRange!.start;
                          }
                        });
                      },
                      child: Text(
                        _selectedRange != null
                            ? "${DateFormat('dd/MM/yyyy').format(_selectedRange!.start)} - ${DateFormat('dd/MM/yyyy').format(_selectedRange!.end)}"
                            : "Khoảng thời gian",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () async {
                        final pickedRange = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2099),
                          initialDateRange: _selectedRange,
                        );
                        setState(() {
                          _selectedRange = pickedRange;
                          if (pickedRange != null) {
                            _selectedDate = _selectedRange!.start;
                          }
                        });

                        setState(() {
                          _selectedRange = DateTimeRange(
                              start: _selectedRange!.start
                                  .add(const Duration(days: 7)),
                              end: _selectedRange!.end
                                  .add(const Duration(days: 7)));
                        });
                      },
                    ),
                  ],
                ),
              ),
            // Chart
            SizedBox(
              height: 200,
              child: Chart(
                transactionType: widget.transactionType,
                transactions: transactions,
              ),
            ),
            Expanded(
              child: TransactionList(
                transactions: transactions,
                onDelete: (id, type) {
                  transactionProvider.deleteTransaction(id, type);
                },
                onEdit: (transaction) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                      widget.transactionType == TransactionType.income
                          ? EditIncomeScreen(transaction: transaction)
                          : EditExpenseScreen(transaction: transaction),
                    ),
                  );
                },
              ),
            ),

          ],
        ),
      ),
    );
  }

  List<Transaction> getFilteredTransactions(
      TransactionProvider transactionProvider,
      TimeFilter selectedFilter,
      DateTime? selectedDate,
      DateTimeRange? selectedRange,
      TransactionType transactionType,
      String searchTerm,
      Category? selectedCategory,) {
    List<Transaction> transactions =
    transactionProvider.getTransactionsByType(transactionType);

    switch (selectedFilter) {
      case TimeFilter.all:
        break;
      case TimeFilter.day:
        transactions = filterByDay(transactions, selectedDate);
        break;
      case TimeFilter.week:
        transactions = filterByWeek(transactions, selectedDate);
        break;
      case TimeFilter.month:
        transactions = filterByMonth(transactions, selectedDate);
        break;
      case TimeFilter.year:
        transactions = filterByYear(transactions, selectedDate);
        break;
      case TimeFilter.range:
        transactions = filterByRange(transactions, selectedRange);
        break;
      default:
        break;
    }

    if (searchTerm.isNotEmpty) {
      transactions = filterBySearchTerm(transactions, searchTerm);
    }

    if (selectedCategory != null) {
      transactions = filterByCategory(transactions, selectedCategory);
    }

    return transactions;
  }

  List<Transaction> filterByDay(
      List<Transaction> transactions, DateTime? selectedDate) {
    if (selectedDate == null) return [];
    return transactions
        .where((tx) =>
    tx.date.year == selectedDate.year &&
        tx.date.month == selectedDate.month &&
        tx.date.day == selectedDate.day)
        .toList();
  }

  List<Transaction> filterByWeek(
      List<Transaction> transactions, DateTime? selectedDate) {
    if (selectedDate == null) return [];
    DateTime firstDayOfWeek = _getFirstDayOfWeek(selectedDate);
    DateTime lastDayOfWeek = _getLastDayOfWeek(selectedDate);
    return transactions
        .where((tx) =>
    tx.date.isAfter(firstDayOfWeek.subtract(const Duration(days: 1))) &&
        tx.date.isBefore(lastDayOfWeek.add(const Duration(days: 1))))
        .toList();
  }

  List<Transaction> filterByMonth(
      List<Transaction> transactions, DateTime? selectedDate) {
    if (selectedDate == null) return [];
    return transactions
        .where((tx) =>
    tx.date.year == selectedDate.year &&
        tx.date.month == selectedDate.month)
        .toList();
  }

  List<Transaction> filterByYear(
      List<Transaction> transactions, DateTime? selectedDate) {
    if (selectedDate == null) return [];
    return transactions
        .where((tx) => tx.date.year == selectedDate.year)
        .toList();
  }

  List<Transaction> filterByRange(
      List<Transaction> transactions, DateTimeRange? selectedRange) {
    if (selectedRange == null) return [];
    return transactions
        .where((tx) =>
    tx.date.isAfter(selectedRange.start.subtract(const Duration(days: 1))) &&
        tx.date.isBefore(selectedRange.end.add(const Duration(days: 1))))
        .toList();
  }
  List<Transaction> filterBySearchTerm(
      List<Transaction> transactions, String searchTerm) {
    searchTerm = searchTerm.toLowerCase();
    return transactions
        .where((tx) => tx.title.toLowerCase().contains(searchTerm))
        .toList();
  }

  List<Transaction> filterByCategory(
      List<Transaction> transactions, Category selectedCategory) {
    return transactions.where((tx) => tx.category == selectedCategory).toList();
  }

  List<DropdownMenuItem<Category>> _buildCategoryDropdownMenuItems() {
    List<Category> categories = Category.values.toList();
    if (widget.transactionType == TransactionType.income) {
      categories.removeWhere((element) => element == Category.anuong || element == Category.giaitri || element == Category.suckhoe || element ==Category.giaoduc || element == Category.quatang || element ==Category.taphoa || element ==Category.giadinh || element ==Category.diichuyen);
    }else{
      categories.removeWhere((element) => element == Category.luong || element == Category.thuong);
    }

    return categories
        .map((Category category) => DropdownMenuItem<Category>(
      value: category,
      child: Text(category.name),
    ))
        .toList();
  }


  DateTime _getFirstDayOfWeek(DateTime date) {
    return date.subtract(Duration(
        days: date.weekday - 1 > 0 ? date.weekday - 1 : 6));
  }

  DateTime _getLastDayOfWeek(DateTime date) {
    return date.add(Duration(
        days: DateTime.daysPerWeek -
            (date.weekday - 1 > 0 ? date.weekday - 1 : 6)));
  }

  DateTime _getPreviousWeek(DateTime date) {
    return date.subtract(const Duration(days: 7));
  }

  DateTime _getNextWeek(DateTime date) {
    return date.add(const Duration(days: 7));
  }

}