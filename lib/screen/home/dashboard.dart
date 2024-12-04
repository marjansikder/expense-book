import 'package:expense_book/crud/database_entry.dart';
import 'package:expense_book/crud/notes_services.dart';
import 'package:expense_book/custom_widget/account_card.dart';
import 'package:expense_book/custom_widget/input_field.dart';
import 'package:expense_book/custom_widget/dashboard_bottom_sheet.dart';
import 'package:expense_book/providers/expense_providers.dart';
import 'package:expense_book/screen/cash_in_out_card.dart';
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
  DateTime time = DateTime.now();

  String? formattedTime;
  int? rwTime;
  int? amount;
  String? remark;
  late EntryType type;

  final amountController = TextEditingController();
  final categoryController = TextEditingController();
  DateTime selectedFromDate = DateTime.now();

  Future<void> selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1920, 1),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedFromDate) {
      setState(() {});
    }
  }

  Widget bottomBoard = DashboardBottomSheet(
    totalBalance: 56,
    totalIncome: 56,
    totalExpense: 56,
  );

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    String selectedToDate = DateFormat("dd/MM/yyyy").format(selectedFromDate ?? DateTime.now());

    final allEntriesAsync = ref.watch(allEntriesProvider);
    final balanceAsync = ref.watch(balanceProvider);

    // Handle Loading or Error States
    if (allEntriesAsync.isLoading || balanceAsync.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (allEntriesAsync.hasError || balanceAsync.hasError) {
      return Scaffold(
        body: Center(
          child: Text(
            'Error: ${allEntriesAsync.error ?? balanceAsync.error}',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    // Data Available
    final entries = allEntriesAsync.value ?? [];
    final balance = balanceAsync.value ?? [0, 0, 0];

    // Sort Entries by Date
    entries.sort((a, b) {
      return DateTime.fromMillisecondsSinceEpoch(a.rwTime)
          .compareTo(DateTime.fromMillisecondsSinceEpoch(b.rwTime));
    });

    int totalBalance = 0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: buttonColor,
        title: const Text(
          'Expense Tracker',
          style: TextStyle(
              fontFamily: 'NotoSans',
              fontSize: 24.5,
              fontWeight: FontWeight.w900,
              color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Toggle Buttons for Daily, Monthly, Yearly
            /* Center(
              child: SizedBox(
                width: double.infinity, // Ensures it fills the entire width
                child: ToggleButtons(
                  isSelected: const [true, false, false],
                  onPressed: (index) {
                    // Handle toggle button click
                  },
                  borderRadius: BorderRadius.circular(8),
                  fillColor: Colors.blue,
                  selectedColor: Colors.white,
                  constraints: BoxConstraints.expand(
                    width: (MediaQuery.of(context).size.width - 28) /
                        3, // Divide width evenly
                    height: 30, // Set height for the buttons
                  ),
                  children: const [
                    Text('Today', textAlign: TextAlign.center),
                    Text('Monthly', textAlign: TextAlign.center),
                    Text('Yearly', textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),*/

            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => const CashCard(
                    text: 'Cash Out',
                    style: kMediumTextStyle,
                  ),
                ).whenComplete(() => setState(() {}));
              },
              child: Text('Create'),
            ),
            // Add Expense Section
            LayoutBuilder(
              builder: (context, constraints) {
                final screenWidth = MediaQuery.of(context).size.width;
                final textSize = screenWidth < 400 ? 12.0 : 14.0;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                            child: InputField(amountController, 5, 'Amount',
                                isNumberInput: true)),
                        const SizedBox(width: 8),
                        Expanded(
                            child:
                                InputField(categoryController, 20, 'Category')),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: buttonColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                            ),
                            icon: const Icon(Icons.calendar_month_sharp,
                                color: kWhiteColor, size: 16),
                            label: Text(
                              selectedToDate,
                              style: const TextStyle(
                                  color: kWhiteColor,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12),
                            ),
                            onPressed: () => selectFromDate(context),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await _entryService.createEntry(
                            remark: categoryController.text,
                            amount: int.tryParse(amountController.text) ?? 0,
                            type: 'cashOut',
                            time: '22/12/2024',
                            rwTime: 45,
                          );
                          toastMessage('Entry Created!');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Add Expense',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: textSize,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 10),

            // Expense List Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Expense List',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'IBMPlexSans'),
                  ),
                ),
                const SizedBox(height: 10),
                entries.isEmpty
                    ? const Center(
                        child: Text('You have not entered any entries yet !!'))
                    : Container(
                        height: 300,
                        child: ListView.builder(
                          itemCount: entries.length,
                          itemBuilder: (ctx, i) {
                            return ExpenseCard(
                              category: entries[i].remark,
                              cost: entries[i].amount,
                            );
                            ExpenseCard(
                              category: entries[i].remark,
                              cost: entries[i].amount,
                            );

                            AccountCard(
                              id: entries[i].id,
                              amount: entries[i].amount,
                              remark: entries[i].remark,
                              type: entries[i].type,
                              dateAndTime: entries[i].time,
                              balance: totalBalance,
                              onTap: () => showModalBottomSheet(
                                  context: ctx,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  builder: (ctx) => Container()),
                            );
                          },
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: balanceAsync.hasValue
          ? DashboardBottomSheet(
        totalBalance: balanceAsync.value![0],
        totalIncome: balanceAsync.value![1],
        totalExpense: balanceAsync.value![2],
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

class ExpenseCard extends StatelessWidget {
  final String category;
  final int cost;
  const ExpenseCard({
    super.key,
    required this.category,
    required this.cost,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: cardBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: ListTile(
        title: Text(category, style: kMediumTextStyle),
        subtitle: Text('03/12/2024'),
        trailing: Text(
          '৳ $cost',
          style: TextStyle(
              color: kPrimaryColor, fontSize: 20, fontFamily: 'NotoSans'),
        ),
      ),
    );
  }
}
