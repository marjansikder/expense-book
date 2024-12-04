import 'package:expense_book/crud/database_entry.dart';
import 'package:expense_book/crud/notes_services.dart';
import 'package:expense_book/style_resources/text_style.dart';
import 'package:flutter/material.dart';


class CashCard extends StatefulWidget {
  const CashCard({super.key, required this.text, required this.style});

  final String text;
  final TextStyle style;

  @override
  State<CashCard> createState() => _CashCardState();
}

class _CashCardState extends State<CashCard> {
  final EntryService _entryService = EntryService();
  final formKey = GlobalKey<FormState>();
  DateTime time = DateTime.now();

  String? formattedTime;
  int? rwTime;
  int? amount;
  String? remark;
  late EntryType type;

  @override
  void initState() {
    super.initState();
    type = widget.text == 'Cash In' ? EntryType.cashIn : EntryType.cashOut;
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final isWideScreen = mq.size.width >= 400;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: mq.size.width * 0.8,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF27496D),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, isWideScreen),
                const Divider(color: Colors.white, thickness: 2),
                const SizedBox(height: 10),
                _buildAmountField(),
                const SizedBox(height: 10),
                _buildRemarkField(isWideScreen),
                const SizedBox(height: 20),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isWideScreen) {
    return GestureDetector(
      onTap: () {

      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFF3b6fa5),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_month, size: 26, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              '22/12/2024',
              style: TextStyle(
                fontSize: isWideScreen ? 15 : 12,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Amount'),
        TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) return 'Enter some amount';
            if (int.tryParse(value) == null) return 'Enter a valid number';
            return null;
          },
          onSaved: (value) => amount = int.tryParse(value!),
          keyboardType: TextInputType.number,
          style: kMediumTextStyle,
          textInputAction: TextInputAction.next,
        ),
      ],
    );
  }

  Widget _buildRemarkField(bool isWideScreen) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) return 'Enter some remark';
        return null;
      },
      onSaved: (value) => remark = value,
      maxLines: isWideScreen ? 4 : 3,
      style: kMediumTextStyle,
      textInputAction: TextInputAction.done,
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              formKey.currentState!.save();
              await _entryService.createEntry(
                remark: remark!,
                amount: amount!,
                type: type.name,
                time: '22/12/2024',
                rwTime: 45,
              );
              toastMessage('Entry Created!');
              Navigator.pop(context);
            },
            child: Text('Create'),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: const CancelButton(),
        ),
      ],
    );
  }
}

class CancelButton extends StatelessWidget {
  const CancelButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Material(
        elevation: 5,
        color: Colors.red,
        borderRadius: BorderRadius.circular(30),
        child: MaterialButton(
          height: 40,
          minWidth: 10,
          onPressed: () => Navigator.pop(context),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: const Icon(Icons.close, size: 18),
        ),
      ),
    );
  }
}

