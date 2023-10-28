import 'package:email_validator/email_validator.dart' show EmailValidator;
import 'package:flutter/material.dart';

// SECTION: AUTH PAGE Components
/* -------------------------------------------------------------------------- */

// Component: Email Text Form Field
class EmailTextFormField extends StatefulWidget {
  const EmailTextFormField({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  State<EmailTextFormField> createState() => _EmailTextFormFieldState();
}

class _EmailTextFormFieldState extends State<EmailTextFormField> {
  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      controller: widget.controller,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.email_outlined),
        labelText: 'Email',
        hintText: 'Enter your email',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      autofillHints: const [AutofillHints.email],
      onFieldSubmitted: (_) => null,
      validator: (email) => email != null && !EmailValidator.validate(email)
          ? 'Please enter a valid email address'
          : null,
    );
  }
}

// Component: Password Text Form Field
class PassWordTextFormField extends StatefulWidget {
  const PassWordTextFormField({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  State<PassWordTextFormField> createState() => _PassWordTextFormFieldState();
}

class _PassWordTextFormFieldState extends State<PassWordTextFormField> {
  bool _isPasswordVisible = false;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autocorrect: false,
      textInputAction: TextInputAction.done,
      controller: widget.controller,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible
                ? Icons.visibility_off_outlined
                : Icons.remove_red_eye_outlined,
          ),
          onPressed: () => _togglePasswordVisibility(),
        ),
        labelText: 'Password',
        hintText: 'Enter your password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      obscureText: !_isPasswordVisible,
      validator: (password) {
        if (password == null || password.isEmpty) {
          return 'Please enter a password';
        }
        if (password.length < 8) {
          return 'Password must be at least 8 characters long';
        }
        return null;
      },
    );
  }
}

// Component: Normal Text Form Field
class NormalTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final String errorText;
  final Icon? prefixIcon;
  final bool needsValidation;
  const NormalTextFormField({
    Key? key,
    required this.controller,
    required this.needsValidation,
    required this.labelText,
    required this.hintText,
    required this.errorText,
    this.prefixIcon,
  }) : super(key: key);

  @override
  State<NormalTextFormField> createState() => _NormalTextFormFieldState();
}

class _NormalTextFormFieldState extends State<NormalTextFormField> {
  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textCapitalization: TextCapitalization.words,
      autocorrect: false,
      textInputAction: TextInputAction.next,
      controller: widget.controller,
      decoration: InputDecoration(
        prefixIcon: widget.prefixIcon,
        labelText: widget.labelText,
        hintText: widget.hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: widget.needsValidation
          ? (value) {
              if (value == null || value.isEmpty) {
                return widget.errorText;
              }
              return null;
            }
          : null,
    );
  }
}

// Utilities
class Utils {
  static void showSnackBar(BuildContext context, String message,
      [Color color = Colors.red]) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}

/* -------------------------------------------------------------------------- */
// !SECTION: Components
