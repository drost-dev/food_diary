import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputTextField extends StatelessWidget {
  const InputTextField({
    super.key,
    required this.onChanged,
    this.label = '',
    this.numeric = false,
    this.text,
  });

  final void Function(String) onChanged;
  final String label;
  final bool numeric;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          numeric ? RegExp(r'^[0-9,.]+') : RegExp(r'^[a-zA-Zа-яА-Я ]+'),
        ),
      ],
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      onChanged: onChanged,
      initialValue: text,
    );
  }
}
