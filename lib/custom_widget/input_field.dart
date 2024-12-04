import 'package:expense_book/style_resources/colors.dart';
import 'package:expense_book/style_resources/text_style.dart';
import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final int? maxLength;
  final String? hinText;
  final TextEditingController? inputController;
  final bool isNumberInput;

  const InputField(this.inputController, this.maxLength, this.hinText, {super.key, this.isNumberInput = false});
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return SizedBox(
      height: 40,
      child: TextField(
        controller: inputController,
        keyboardType: isNumberInput == true ? TextInputType.number : TextInputType.text,
        maxLength: maxLength,
        textAlign: TextAlign.center,
        inputFormatters: [

        ],
        decoration: InputDecoration(
          counterText: "",
          hintText: hinText,
          hintStyle: kHintTextStyle,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0), // Rounded corners
            borderSide: const BorderSide(
              color: Colors.blue, // Border color
              width: 2.0,        // Border width
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(
              color: Colors.grey, // Border color when not focused
              width: 1.5,        // Border width when not focused
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(
              color: Colors.blue, // Border color when focused
              width: 2.0,        // Border width when focused
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 8.0,
          ),
        ),
      ),

    );
  }
}
