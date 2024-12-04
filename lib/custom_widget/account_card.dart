import 'package:expense_book/crud/database_entry.dart';
import 'package:expense_book/crud/notes_services.dart';
import 'package:expense_book/style_resources/text_style.dart';
import 'package:flutter/material.dart';

import 'delete_dialogue.dart';


// import 'dart:developer' as devtools show log;

class AccountCard extends StatelessWidget {
  const AccountCard({
    super.key,
    required this.id,
    required this.amount,
    required this.remark,
    required this.balance,
    required this.dateAndTime,
    required this.type,
    required this.onTap,
  });

  final int amount;
  final int balance;
  final String remark;
  final int id;
  final String dateAndTime;
  final EntryType type;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Dismissible(
        key: ValueKey(id),
        background: Container(
          color: Theme.of(context).colorScheme.error,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 15),
          margin: const EdgeInsets.only(top: 15),
          child: const Icon(
            Icons.delete_outline_rounded,
            color: Colors.white,
            size: 30,
          ),
        ),
        direction: DismissDirection.endToStart,
        confirmDismiss: (d) async => await showDeleteDialogue(context),
        onDismissed: (d) async => await EntryService().deleteNote(id: id),
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFF27496D),
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  child: Text(
                    dateAndTime,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                Divider( color: Colors.white),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            remark,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: kMediumTextStyle,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      flex: 1,
                      child: Text(
                        '$amount',
                        style: type == EntryType.cashIn
                            ? kCreditTextStyle
                            : kDebitTextStyle,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        // '2000',
                        balance.toString(),
                        style: balance == 0
                            ? kMediumTextStyle
                            : balance > 0
                                ? kCreditTextStyle
                                : kDebitTextStyle,
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
