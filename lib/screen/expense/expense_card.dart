import 'package:expense_book/crud/notes_services.dart';
import 'package:expense_book/style_resources/colors.dart';
import 'package:expense_book/style_resources/text_style.dart';
import 'package:flutter/material.dart';

import '../../custom_widget/delete_dialogue.dart';

class ExpenseCard extends StatelessWidget {
  final int id;
  final String category;
  final int cost;
  final String selectedDate;
  final String selectedTime;
  final Function() onTap;
  final Function() onDelete; // Add an onDelete callback

  const ExpenseCard({
    super.key,
    required this.id,
    required this.category,
    required this.cost,
    required this.selectedDate,
    required this.selectedTime,
    required this.onTap,
    required this.onDelete, // Pass the onDelete function
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Dismissible(
        key: ValueKey(id),
        background: Container(
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(5),
              bottomRight: Radius.circular(5),
            ),
            color: kErrorToastTextColor,
          ),
          margin: const EdgeInsets.only(top: 5, bottom: 5),
          child: const Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(
              Icons.delete_outline_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
        ),
        direction: DismissDirection.endToStart,
        confirmDismiss: (d) async {
          final confirm = await showDeleteDialogue(context);
          if (confirm == true) {
            onDelete(); // Call the onDelete callback
            await EntryService().deleteNote(id: id);
          }
          return confirm;
        },
        onDismissed: (d) {}, // No need to handle the dismissal here
        child: Card(
          elevation: 1,
          color: cardBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: ListTile(
            title: Text(category, style: kMediumTextStyle),
            subtitle: Text('$selectedTime  $selectedDate'),
            subtitleTextStyle: subtitleTextStyle,
            trailing: Text(
              '$cost ৳',
              style: const TextStyle(
                color: kPrimaryColor,
                fontSize: 20,
                fontFamily: 'NotoSans',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

