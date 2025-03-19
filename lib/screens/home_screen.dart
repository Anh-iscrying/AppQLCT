import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../providers/transaction_provider.dart';
import '../widgets/transaction_list_home.dart';
import 'income_expense_screen.dart';
import '../widgets/summary_card.dart';
import '../account_screen.dart';

class HomeScreen extends StatelessWidget {
  final String uid;
  const HomeScreen({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.value(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Xử lý lỗi nếu có
          return Text('Error: ${snapshot.error}');
        } else {

          return ChangeNotifierProvider(
            create: (context) => TransactionProvider(uid: snapshot.data as String),
            child: _HomeScreenContent(uid: snapshot.data as String),
          );
        }
      },
    );
  }
}

class _HomeScreenContent extends StatefulWidget {
  final String uid;
  const _HomeScreenContent({Key? key, required this.uid}) : super(key: key);

  @override
  State<_HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<_HomeScreenContent> with TickerProviderStateMixin {
  DateTime? _selectedDate = DateTime.now();
  TimeFilter _selectedFilter = TimeFilter.day;
  DateTimeRange? _selectedRange;
  late TabController _timeFilterTabController;

  @override
  void initState() {
    super.initState();
    _timeFilterTabController =
        TabController(length: 5, vsync: this, initialIndex: 0);
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

  @override
  void dispose() {
    _timeFilterTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);

    // Tính toán tổng thu nhập và chi phí dựa trên bộ lọc thời gian
    double totalIncomeByFilter = 0;
    double totalExpenseByFilter = 0;

    // Danh sách giao dịch đã lọc được
    List<MyTransaction> combinedTransactions = getFilteredTransactions(
      transactionProvider,
      _selectedFilter,
      _selectedDate,
      _selectedRange,
    );

    // Tính toán lại thu nhập và chi phí sau khi lọc
    totalIncomeByFilter = combinedTransactions
        .where((tx) => tx.type == TransactionType.income)
        .fold(0.0, (sum, tx) => sum + tx.amount);
    totalExpenseByFilter = combinedTransactions
        .where((tx) => tx.type == TransactionType.expense)
        .fold(0.0, (sum, tx) => sum + tx.amount);

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
            title: const Text('Quản lý chi tiêu'),
            actions: [
              IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AccountScreen(),
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
        color: Color(0xFFF5F5DC),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SummaryCard(
                income: transactionProvider.totalIncome,
                expense: transactionProvider.totalExpense,
                incomeByFilter: totalIncomeByFilter,
                expenseByFilter: totalExpenseByFilter
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Nút quản lý thu nhập
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IncomeExpenseScreen(
                          selectedDate: _selectedDate,
                          selectedFilter: _selectedFilter,
                          selectedRange: _selectedRange,
                          transactionType: TransactionType.income,
                        ),
                      ),
                    );
                  },
                  child: const Text('Quản lý Thu nhập'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150, 50),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),

                // Nút quản lý chi tiêu
                const SizedBox(width: 20,),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IncomeExpenseScreen(
                          transactionType: TransactionType.expense,
                          selectedDate: _selectedDate,
                          selectedFilter: _selectedFilter,
                          selectedRange: _selectedRange,
                        ),
                      ),
                    );
                  },
                  child: const Text('Quản lý Chi tiêu'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150, 50),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),

            // Bộ lọc thời gian
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

            Expanded(
              child: TransactionListHome(
                transactions: combinedTransactions,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<MyTransaction> getFilteredTransactions(
      TransactionProvider transactionProvider,
      TimeFilter selectedFilter,
      DateTime? selectedDate,
      DateTimeRange? selectedRange,) {
    List<MyTransaction> transactions = transactionProvider.transactions;

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

    return transactions;
  }

  List<MyTransaction> filterByDay(
      List<MyTransaction> transactions, DateTime? selectedDate) {
    if (selectedDate == null) return [];
    return transactions
        .where((tx) =>
    tx.date.year == selectedDate.year &&
        tx.date.month == selectedDate.month &&
        tx.date.day == selectedDate.day)
        .toList();
  }

  List<MyTransaction> filterByWeek(
      List<MyTransaction> transactions, DateTime? selectedDate) {
    if (selectedDate == null) return [];
    DateTime firstDayOfWeek = _getFirstDayOfWeek(selectedDate);
    DateTime lastDayOfWeek = _getLastDayOfWeek(selectedDate);
    return transactions
        .where((tx) =>
    tx.date.isAfter(firstDayOfWeek.subtract(const Duration(days: 1))) &&
        tx.date.isBefore(lastDayOfWeek.add(const Duration(days: 1))))
        .toList();
  }

  List<MyTransaction> filterByMonth(
      List<MyTransaction> transactions, DateTime? selectedDate) {
    if (selectedDate == null) return [];
    return transactions
        .where((tx) =>
    tx.date.year == selectedDate.year &&
        tx.date.month == selectedDate.month)
        .toList();
  }

  List<MyTransaction> filterByYear(
      List<MyTransaction> transactions, DateTime? selectedDate) {
    if (selectedDate == null) return [];
    return transactions
        .where((tx) => tx.date.year == selectedDate.year)
        .toList();
  }

  List<MyTransaction> filterByRange(
      List<MyTransaction> transactions, DateTimeRange? selectedRange) {
    if (selectedRange == null) return [];
    return transactions
        .where((tx) =>
    tx.date.isAfter(selectedRange.start.subtract(const Duration(days: 1))) &&
        tx.date.isBefore(selectedRange.end.add(const Duration(days: 1))))
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

extension on TransactionProvider {
  List<MyTransaction> get transactions => expenseTransactions + incomeTransactions;
}

enum TimeFilter {
  all,
  day,
  week,
  month,
  year,
  range,
}