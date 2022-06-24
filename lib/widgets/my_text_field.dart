import 'package:flutter/material.dart';
import 'package:gas_provider/constants.dart';

class MyTextField extends StatelessWidget {
  const MyTextField(
      {Key? key,
      this.onChanged,
      this.labelText,
      this.prefixIcon,
      this.textInputAction,
      this.hintText})
      : super(key: key);

  final String? labelText;
  final String? hintText;
  final Function(String val)? onChanged;
  final IconData? prefixIcon;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (val) {
        if (onChanged != null) {
          onChanged!(val);
        }
      },
      cursorColor: kPrimaryColor,
      textInputAction: textInputAction,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        border: InputBorder.none,
        floatingLabelStyle: const TextStyle(
          color: Colors.black,
          fontSize: 18.0,
        ),
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                size: 20,
              )
            : null,
        fillColor: Colors.grey[200],
        filled: true,
      ),
    );
  }
}
