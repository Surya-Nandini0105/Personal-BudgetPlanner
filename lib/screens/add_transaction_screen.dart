import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';
import '../models/transaction_model.dart';
import '../utils/constants.dart';
import '../utils/app_theme.dart';

class AddTransactionScreen extends StatefulWidget {
  final TransactionType type;
  final TransactionModel? transaction;

  const AddTransactionScreen({
    super.key,
    required this.type,
    this.transaction,
  });

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late TextEditingController _noteController;
  late String _selectedCategory;
  late DateTime _selectedDate;
  late TransactionType _type;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _type = widget.type;
    _isEditing = widget.transaction != null;

    if (_isEditing) {
      final t = widget.transaction!;
      _titleController = TextEditingController(text: t.title);
      _amountController = TextEditingController(text: t.amount.toStringAsFixed(0));
      _noteController = TextEditingController(text: t.note ?? '');
      _selectedCategory = t.category;
      _selectedDate = t.date;
      _type = t.type;
    } else {
      _titleController = TextEditingController();
      _amountController = TextEditingController();
      _noteController = TextEditingController();
      _selectedCategory = _type == TransactionType.income
          ? AppConstants.incomeCategories.first
          : AppConstants.expenseCategories.first;
      _selectedDate = DateTime.now();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  List<String> get _categories => _type == TransactionType.income
      ? AppConstants.incomeCategories
      : AppConstants.expenseCategories;

  @override
  Widget build(BuildContext context) {
    final isIncome = _type == TransactionType.income;
    final themeColor = isIncome ? AppTheme.incomeColor : AppTheme.expenseColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing
              ? 'Edit ${isIncome ? 'Income' : 'Expense'}'
              : 'Add ${isIncome ? 'Income' : 'Expense'}',
        ),
        backgroundColor: themeColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Type Toggle (only when adding new)
              if (!_isEditing) ..._buildTypeToggle(isIncome),

              const SizedBox(height: 20),

              // Amount Field
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: themeColor,
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: '0',
                  hintStyle: TextStyle(
                    fontSize: 32,
                    color: Colors.grey.shade400,
                  ),
                  prefixText: '${AppConstants.currencySymbol} ',
                  prefixStyle: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: themeColor,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: themeColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: themeColor, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an amount';
                  }
                  final amount = double.tryParse(value.trim());
                  if (amount == null || amount <= 0) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  hintText: isIncome ? 'e.g., Monthly Salary' : 'e.g., Grocery Shopping',
                  prefixIcon: const Icon(Icons.title),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Category Dropdown
              DropdownButtonFormField<String>(
                initialValue: _categories.contains(_selectedCategory)
                    ? _selectedCategory
                    : _categories.first,
                decoration: InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(
                    AppConstants.categoryIcons[_selectedCategory] ??
                        Icons.category,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Row(
                      children: [
                        Icon(
                          AppConstants.categoryIcons[category],
                          size: 20,
                          color: AppConstants.categoryColors[category],
                        ),
                        const SizedBox(width: 10),
                        Text(category),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedCategory = value);
                  }
                },
              ),

              const SizedBox(height: 16),

              // Date Picker
              InkWell(
                onTap: () => _pickDate(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Date',
                    prefixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    DateFormat('dd MMMM yyyy').format(_selectedDate),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Note Field
              TextFormField(
                controller: _noteController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Note (Optional)',
                  hintText: 'Add a note...',
                  prefixIcon: const Icon(Icons.note),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _saveTransaction,
                  icon: Icon(_isEditing ? Icons.check : Icons.add),
                  label: Text(
                    _isEditing ? 'Update Transaction' : 'Save Transaction',
                    style: const TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTypeToggle(bool isIncome) {
    return [
      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _type = TransactionType.income;
                    _selectedCategory = AppConstants.incomeCategories.first;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: _type == TransactionType.income
                        ? AppTheme.incomeColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Income',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _type == TransactionType.income
                          ? Colors.white
                          : Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _type = TransactionType.expense;
                    _selectedCategory = AppConstants.expenseCategories.first;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: _type == TransactionType.expense
                        ? AppTheme.expenseColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Expense',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _type == TransactionType.expense
                          ? Colors.white
                          : Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _saveTransaction() {
    if (!_formKey.currentState!.validate()) return;

    final transaction = TransactionModel(
      id: widget.transaction?.id,
      title: _titleController.text.trim(),
      amount: double.parse(_amountController.text.trim()),
      type: _type,
      category: _selectedCategory,
      date: _selectedDate,
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
    );

    final provider = context.read<AppProvider>();

    if (_isEditing) {
      provider.updateTransaction(transaction);
    } else {
      provider.addTransaction(transaction);
    }

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isEditing
              ? 'Transaction updated successfully!'
              : 'Transaction added successfully!',
        ),
        backgroundColor: _type == TransactionType.income
            ? AppTheme.incomeColor
            : AppTheme.expenseColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
