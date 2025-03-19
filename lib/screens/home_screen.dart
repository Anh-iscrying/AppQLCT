import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../providers/transaction_provider.dart';
import '../widgets/transaction_list_home.dart'; // Giữ lại để hiển thị danh sách
import 'income_expense_screen.dart';
import '../widgets/summary_card.dart';
import '../account_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.uid}) : super(key: key);
  final String uid; // UID của người dùng đã đăng nhập

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
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

    // Tải dữ liệu khi HomeScreen được khởi tạo
    _loadInitialData();
  }

  // Hàm tải dữ liệu ban đầu (sử dụng trong initState)
  Future<void> _loadInitialData() async {
    final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
    await transactionProvider.loadTransactions(widget.uid); // Truyền UID
  }

  @override
  void dispose() {
    _timeFilterTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);

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
            // Summary Card (hiển thị tổng thu nhập và chi phí)
            SummaryCard(
              income: transactionProvider.totalIncome,
              expense: transactionProvider.totalExpense,
              incomeByFilter: _calculateTotalIncomeByFilter(transactionProvider),
              expenseByFilter: _calculateTotalExpenseByFilter(transactionProvider),
            ),

            // Các nút quản lý thu nhập và chi tiêu
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                          uid: widget.uid, // Pass the UID
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
                          uid: widget.uid, // Pass the UID
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

            // Bộ lọc thời gian (TabBar)
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

            // Các tùy chọn bộ lọc thời gian
            _buildTimeFilterOptions(),

            // Danh sách giao dịch
            Expanded(
              child: _buildTransactionList(transactionProvider),
            ),
          ],
        ),
      ),
    );
  }

  // Widget hiển thị danh sách giao dịch (sử dụng FutureBuilder)
  Widget _buildTransactionList(TransactionProvider transactionProvider) {
    return FutureBuilder<List<MyTransaction>>(
      future: Future.value(getFilteredTransactions(transactionProvider)), // Lọc dữ liệu
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Lỗi: ${snapshot.error}'));
        } else {
          final transactions = snapshot.data ?? [];
          if (transactions.isEmpty) {
            return Center(child: Text('Không có giao dịch nào.'));
          }
          return TransactionListHome(transactions: transactions);
        }
      },
    );
  }

  // Widget hiển thị các tùy chọn bộ lọc thời gian
  Widget _buildTimeFilterOptions() {
    if (_selectedFilter == TimeFilter.day && _selectedDate != null) {
      return _buildDayFilterOptions();
    } else if (_selectedFilter == TimeFilter.week && _selectedDate != null) {
      return _buildWeekFilterOptions();
    } else if (_selectedFilter == TimeFilter.month && _selectedDate != null) {
      return _buildMonthFilterOptions();
    } else if (_selectedFilter == TimeFilter.year && _selectedDate != null) {
      return _buildYearFilterOptions();
    } else if (_selectedFilter == TimeFilter.range) {
      return _buildRangeFilterOptions();
    } else {
      return Container(); // Không hiển thị gì nếu không có bộ lọc nào được chọn
    }
  }

  // Widget hiển thị tùy chọn lọc theo ngày
  Widget _buildDayFilterOptions() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              setState(() {
                _selectedDate = _selectedDate!.subtract(const Duration(days: 1));
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
                initialDatePickerMode: DatePickerMode.day, // Cho phép chọn ngày
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
                _selectedDate = _selectedDate!.add(const Duration(days: 1));
              });
            },
          ),
        ],
      ),
    );
  }

  // Widget hiển thị tùy chọn lọc theo tuần
  Widget _buildWeekFilterOptions() {
    return Padding(
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
    );
  }

  // Widget hiển thị tùy chọn lọc theo tháng
  Widget _buildMonthFilterOptions() {
    return Padding(
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
    );
  }

  // Widget hiển thị tùy chọn lọc theo năm
  Widget _buildYearFilterOptions() {
    return Padding(
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
    );
  }

  // Widget hiển thị tùy chọn lọc theo khoảng thời gian
  Widget _buildRangeFilterOptions() {
    return Padding(
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
              if (pickedRange != null) {
                setState(() {
                  _selectedRange = pickedRange;
                  _selectedDate = _selectedRange!.start; // Cập nhật _selectedDate
                });
              }
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
              if (pickedRange != null) {
                setState(() {
                  _selectedRange = pickedRange;
                  _selectedDate = _selectedRange!.start; // Cập nhật _selectedDate
                });
              }
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
              if (pickedRange != null) {
                setState(() {
                  _selectedRange = pickedRange;
                  _selectedDate = _selectedRange!.start; // Cập nhật _selectedDate
                });
              }
            },
          ),
        ],
      ),
    );
  }

  // Hàm lọc danh sách giao dịch dựa trên bộ lọc thời gian đã chọn
  List<MyTransaction> getFilteredTransactions(TransactionProvider transactionProvider) {
    List<MyTransaction> transactions = transactionProvider.transactions; // Lấy tất cả giao dịch

    switch (_selectedFilter) {
      case TimeFilter.all:
        break;
      case TimeFilter.day:
        transactions = filterByDay(transactions, _selectedDate);
        break;
      case TimeFilter.week:
        transactions = filterByWeek(transactions, _selectedDate);
        break;
      case TimeFilter.month:
        transactions = filterByMonth(transactions, _selectedDate);
        break;
      case TimeFilter.year:
        transactions = filterByYear(transactions, _selectedDate);
        break;
      case TimeFilter.range:
        transactions = filterByRange(transactions, _selectedRange);
        break;
      default:
        break;
    }

    return transactions;
  }

  // Hàm tính tổng thu nhập sau khi lọc
  double _calculateTotalIncomeByFilter(TransactionProvider transactionProvider) {
    List<MyTransaction> filteredTransactions = getFilteredTransactions(transactionProvider);
    return filteredTransactions
        .where((tx) => tx.type == TransactionType.income)
        .fold(0.0, (sum, tx) => sum + tx.amount);
  }

  // Hàm tính tổng chi phí sau khi lọc
  double _calculateTotalExpenseByFilter(TransactionProvider transactionProvider) {
    List<MyTransaction> filteredTransactions = getFilteredTransactions(transactionProvider);
    return filteredTransactions
        .where((tx) => tx.type == TransactionType.expense)
        .fold(0.0, (sum, tx) => sum + tx.amount);
  }

  // Các hàm lọc dữ liệu (giữ nguyên từ code gốc)
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

  // Các hàm tính toán ngày (giữ nguyên từ code gốc)
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

// Mở rộng TransactionProvider để lấy tất cả giao dịch
extension on TransactionProvider {
  List<MyTransaction> get transactions => expenseTransactions + incomeTransactions;
  Future<void> loadTransactions(String uid) async {
    await loadExpenseTransactions(uid);
    await loadIncomeTransactions(uid);
  }
}

// Định nghĩa enum TimeFilter
enum TimeFilter {
  all,
  day,
  week,
  month,
  year,
  range,
}