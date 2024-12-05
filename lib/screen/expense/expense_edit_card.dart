import 'package:expense_book/crud/database_entry.dart';
import 'package:expense_book/crud/notes_services.dart';
import 'package:expense_book/custom_widget/input_field.dart';
import 'package:expense_book/style_resources/colors.dart';
import 'package:expense_book/style_resources/text_style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseEditCard extends StatefulWidget {
  const ExpenseEditCard({
    super.key,
    required this.oldAmount,
    required this.oldRemark,
    required this.oldDate,
    required this.oldType,
    required this.oldTime,
    required this.id,
  });

  final int oldAmount;
  final String oldRemark;
  final String oldDate;
  final EntryType oldType;
  final String oldTime;
  final String id;

  @override
  State<ExpenseEditCard> createState() => _ExpenseEditCardState();
}

class _ExpenseEditCardState extends State<ExpenseEditCard> {
  final formKey = GlobalKey<FormState>();

  String? newDate;
  String? newTime;
  EntryType? newType;
  DatabaseEntry? editableEntry;
  bool valid = false;
  bool _isInit = true;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void didChangeDependencies() {
    if (_isInit) {
      newDate = widget.oldDate;
      newTime = widget.oldTime;
      newType = widget.oldType;
      editableEntry = DatabaseEntry(
        date: '',
        amount: widget.oldAmount,
        id: int.parse(widget.id),
        remark: widget.oldRemark,
        type: widget.oldType,
        time: widget.oldTime,
      );
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1920, 1),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final screenWidth = mq.size.width;
    String formattedDate = DateFormat("dd/MM/yyyy").format(selectedDate);
    String formattedTime = selectedTime.format(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: screenWidth * 0.9,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Update Entry',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: kBlackColor,
                      fontFamily: 'Jost'
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: InputField(
                          initialValue: widget.oldAmount.toString(),
                          hinText: 'Amount',
                          isNumberInput: true,
                          onSaved: (v) {
                            editableEntry = DatabaseEntry(
                              date: editableEntry!.date,
                              amount: int.parse(v),
                              id: editableEntry!.id,
                              remark: editableEntry!.remark,
                              type: editableEntry!.type,
                              time: editableEntry!.time,
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: InputField(
                          initialValue: widget.oldRemark,
                          hinText: 'Category',
                          onSaved: (v) {
                            editableEntry = DatabaseEntry(
                              id: editableEntry!.id,
                              amount: editableEntry!.amount,
                              remark: v,
                              type: editableEntry!.type,
                              date: editableEntry!.date,
                              time: editableEntry!.time,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.date_range, size: 16),
                          label: Text(formattedDate),
                          onPressed: () => selectDate(context),
                          style: StyleProperty().elevatedIconStyle(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.access_time, size: 16),
                          label: Text(formattedTime),
                          onPressed: () => selectTime(context),
                          style: StyleProperty().elevatedIconStyle(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Text('CANCEL',
                              style: TextStyle(color: kWhiteColor)),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (!formKey.currentState!.validate()) return;
                          formKey.currentState!.save();
                          await EntryService()
                              .updateEntry(
                                id: int.parse(widget.id),
                                amount: editableEntry!.amount,
                                remark: editableEntry!.remark,
                                type: newType!.name,
                                date: formattedDate,
                                time: formattedTime,
                              )
                              .whenComplete(() => Navigator.pop(context));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Text('UPDATE',
                              style: TextStyle(color: kWhiteColor)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
