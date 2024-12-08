import 'package:expense_book/crud/database_entry.dart';
import 'package:expense_book/crud/notes_services.dart';
import 'package:expense_book/custom_widget/methods.dart';
import 'package:expense_book/screen/expense/expense_card.dart';
import 'package:expense_book/custom_widget/input_field.dart';
import 'package:expense_book/custom_widget/dashboard_bottom_sheet.dart';
import 'package:expense_book/providers/expense_providers.dart';
import 'package:expense_book/screen/expense/expense_edit_card.dart';
import 'package:expense_book/style_resources/colors.dart';
import 'package:expense_book/style_resources/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final EntryService _entryService = EntryService();
  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final categoryController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void dispose() {
    amountController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  Future<void> selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1920, 1),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() => selectedTime = picked);
    }
  }

  Future<void> _addExpense() async {
    if (formKey.currentState!.validate()) {

      formKey.currentState!.save();

      await _entryService.createEntry(
        remark: categoryController.text,
        amount: int.tryParse(amountController.text) ?? 0,
        type: 'cashOut',
        date: DateFormat("dd/MM/yyyy").format(selectedDate),
        time: selectedTime.format(context),
      );

      amountController.clear();
      categoryController.clear();

      toastMessage('Entry Created!');
    }
  }


  @override
  Widget build(BuildContext context) {
    final allEntriesAsync = ref.watch(allEntriesProvider);
    final balanceAsync = ref.watch(balanceProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: buttonColor,
        title: const Text(
          'Expense Tracker',
          style: TextStyle(
            fontFamily: 'NotoSans',
            fontSize: 24.5,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateTimePickers(context),
            Form(key: formKey, child: _buildInputFields(context)),
            _buildAddExpenseButton(context),
            const SizedBox(height: 10),
            //_buildExpenseSortedList(allEntriesAsync),
            _buildExpenseList(allEntriesAsync),
          ],
        ),
      ),
      bottomNavigationBar: balanceAsync.when(
        data: (balance) => DashboardBottomSheet(
          totalBalance: balance[0],
          totalIncome: balance[1],
          totalExpense: balance[2],
        ),
        loading: () => const CircularProgressIndicator(),
        error: (e, _) => Center(
          child: Text(
            'Error: $e',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimePickers(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 400;
    final textSize = isSmallScreen ? 12.0 : 14.0;

    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: Icon(Icons.date_range, size: textSize + 4),
            label: Text(
              DateFormat("dd/MM/yyyy").format(selectedDate),
              style: TextStyle(fontSize: textSize),
            ),
            onPressed: () => selectDate(context),
            style: StyleProperty().elevatedIconStyle(),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton.icon(
            icon: Icon(Icons.access_time, size: textSize + 4),
            label: Text(
              selectedTime.format(context),
              style: TextStyle(fontSize: textSize),
            ),
            onPressed: () => selectTime(context),
            style: StyleProperty().elevatedIconStyle(),
          ),
        ),
      ],
    );
  }

  Widget _buildInputFields(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InputField(
            inputController: amountController,
            maxLength: 5,
            hinText: 'Amount',
            isNumberInput: true,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: InputField(
            inputController: categoryController,
            maxLength: 20,
            hinText: 'Category',
          ),
        ),
      ],
    );
  }

  Widget _buildAddExpenseButton(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 400;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _addExpense,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(
            vertical: isSmallScreen ? 10 : 14,
          ),
        ),
        child: Text(
          'Add Expense',
          style: TextStyle(
            color: Colors.white,
            fontSize: isSmallScreen ? 14 : 16,
          ),
        ),
      ),
    );
  }

  Widget _buildExpenseList(AsyncValue<List<DatabaseEntry>> allEntriesAsync) {
    return allEntriesAsync.when(
      data: (entries) {
        if (entries.isEmpty) {
          return const Center(
            child: Text('You have not entered any entries yet!'),
          );
        }
        return Expanded(
          child: ListView.builder(
            itemCount: entries.length,
            itemBuilder: (ctx, i) {
              return ExpenseCard(
                id: entries[i].id,
                category: entries[i].remark,
                cost: entries[i].amount,
                selectedDate: entries[i].date,
                selectedTime: entries[i].time,
                onTap: () => showModalBottomSheet(
                  context: ctx,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  builder: (ctx) => ExpenseEditCard(
                    id: entries[i].id.toString(),
                    oldAmount: entries[i].amount,
                    oldRemark: entries[i].remark,
                    oldDate: entries[i].date,
                    oldType: entries[i].type,
                    oldTime: entries[i].time,
                  ),
                ),
                onDelete: () {
                  setState(() {
                    entries.removeAt(i); // Remove the entry from the list
                  });
                },
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Text(
          'Error: $e',
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildExpenseSortedList(AsyncValue<List<DatabaseEntry>> allEntriesAsync) {
    return allEntriesAsync.when(
      data: (entries) {
        if (entries.isEmpty) {
          return const Center(
            child: Text('You have not entered any entries yet!'),
          );
        }

        final sortedEntries = List.of(entries)
          ..sort((a, b) {
            // Parse date strings into DateTime
            final dateA = DateFormat("dd/MM/yyyy").parse(a.date.trim());
            final dateB = DateFormat("dd/MM/yyyy").parse(b.date.trim());

            if (dateA != dateB) {
              return dateB.compareTo(dateA); // Latest date first
            }

            // Parse time strings into TimeOfDay
            TimeOfDay parseTime(String time) {
              final parts = time.trim().split(':');
              final hour = int.parse(parts[0]);
              final minute = int.parse(parts[1].split(' ')[0]);
              final period = parts[1].split(' ')[1];
              return TimeOfDay(
                hour: period == "PM" && hour < 12 ? hour + 12 : hour % 24,
                minute: minute,
              );
            }

            final timeA = parseTime(a.time);
            final timeB = parseTime(b.time);

            // Compare times
            if (timeA.hour != timeB.hour) {
              return timeB.hour.compareTo(timeA.hour); // Latest hour first
            }

            return timeB.minute.compareTo(timeA.minute); // Latest minute first
          });



        return Expanded(
          child: ListView.builder(
            itemCount: sortedEntries.length,
            itemBuilder: (ctx, i) {
              return ExpenseCard(
                id: sortedEntries[i].id,
                category: sortedEntries[i].remark,
                cost: sortedEntries[i].amount,
                selectedDate: sortedEntries[i].date,
                selectedTime: sortedEntries[i].time,
                onDelete: () {
                  // Handle deletion and update state
                  EntryService().deleteNote(id: sortedEntries[i].id);
                  setState(() {
                    entries.removeAt(i);
                  });
                },
                onTap: () => showModalBottomSheet(
                  context: ctx,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  builder: (ctx) => ExpenseEditCard(
                    id: sortedEntries[i].id.toString(),
                    oldAmount: sortedEntries[i].amount,
                    oldRemark: sortedEntries[i].remark,
                    oldDate: sortedEntries[i].date,
                    oldType: sortedEntries[i].type,
                    oldTime: sortedEntries[i].time,
                  ),
                ),
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }


}
