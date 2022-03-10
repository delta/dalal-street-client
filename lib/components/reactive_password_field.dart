import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ReactivePasswordField extends StatefulWidget {
  final String formControlName;
  final Map<String, String> validation;
  final String? label;
  final Iterable<String>? autofillHints;
  final TextInputAction? textInputAction;
  final void Function()? onSubmitted;

  const ReactivePasswordField({
    Key? key,
    required this.formControlName,
    required this.validation,
    this.label,
    this.autofillHints,
    this.textInputAction,
    this.onSubmitted,
  }) : super(key: key);

  @override
  State<ReactivePasswordField> createState() => _ReactivePasswordFieldState();
}

class _ReactivePasswordFieldState extends State<ReactivePasswordField> {
  var _passwordVisible = false;

  @override
  Widget build(BuildContext context) => ReactiveTextField(
        formControlName: widget.formControlName,
        obscureText: !_passwordVisible,
        decoration: InputDecoration(
          labelText: widget.label ?? 'Password',
          prefixIcon: const Icon(Icons.password),
          suffixIcon: IconButton(
            onPressed: _toggleVisibility,
            icon: Icon(
                _passwordVisible ? Icons.visibility : Icons.visibility_off),
          ),
        ),
        keyboardType: TextInputType.visiblePassword,
        validationMessages: (control) => widget.validation,
        autofillHints: widget.autofillHints,
        textInputAction: widget.textInputAction,
        onSubmitted: widget.onSubmitted,
      );

  void _toggleVisibility() =>
      setState(() => _passwordVisible = !_passwordVisible);
}
