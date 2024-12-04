import 'package:expense_book/style_resources/colors.dart';
import 'package:flutter/material.dart';

class DashboardBottomSheet extends StatelessWidget {
  const DashboardBottomSheet(
      {super.key,
        required this.totalBalance,
        required this.totalIncome,
        required this.totalExpense});

  final int totalBalance;
  final int totalIncome;
  final int totalExpense;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        //color: Color(0xFF142850),
        color: buttonColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(8),
          topLeft: Radius.circular(8),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.account_balance_wallet_outlined,
            color: Colors.white,
          ),
          const SizedBox(width: 10),
          const Text(
            'Total Expenses :',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '$totalExpense ৳',
            style: TextStyle(
              color:  kPoultryTagBgColor,
              fontSize: 22,
              fontFamily: 'NotoSans'
            ),
          ),
        ],
      ),
    );
  }
}