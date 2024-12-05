import 'package:expense_book/style_resources/colors.dart';
import 'package:expense_book/style_resources/text_style.dart';
import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final int? maxLength;
  final String? hinText;
  final String? initialValue;
  final TextEditingController? inputController;
  final bool isNumberInput;
  final Function(String)? onSaved;

  const InputField({
    super.key,
    this.maxLength,
    this.hinText,
    this.initialValue,
    this.inputController,
    this.isNumberInput = false,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: width * 0.9,
        height: 40,
        child: TextFormField(
          controller: inputController,
          keyboardType:
              isNumberInput ? TextInputType.number : TextInputType.text,
          maxLength: maxLength,
          textAlign: TextAlign.center,
          initialValue: initialValue,
          autofocus: false,
          onSaved: (value) {
            onSaved?.call(value ?? "");
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            return (value == null || value.isEmpty) ? "" : null;
          },
          decoration: InputDecoration(
            counterText: "",
            hintText: hinText,
            hintStyle: kHintTextStyle,
            errorStyle: TextStyle(height: 0.001),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(
                color: Colors.blue,
                width: 2.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(
                color: Colors.blue,
                width: 2.0,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 8.0,
            ),
          ),
        ),
      ),
    );
  }
}
