import 'package:flutter/material.dart';

class EditTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  const EditTextFormField(
      {super.key, required this.controller, required this.labelText});

  @override
  State<EditTextFormField> createState() => _EditTextFormFieldState();
}

class _EditTextFormFieldState extends State<EditTextFormField> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: widget.labelText,
      ),
      validator: (value) => value!.isEmpty ? '* Required' : null,
    );
  }
}
