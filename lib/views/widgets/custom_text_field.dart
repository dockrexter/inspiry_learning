import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputTextField extends StatefulWidget {
  const InputTextField(
    this.lable, {
    Key? key,
    this.icon,
    this.controller,
    this.inputFormatters,
    this.obscureText = false,
  }) : super(key: key);

  final String lable;
  final Widget? icon;
  final bool obscureText;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<InputTextField> createState() => _InputTextFieldState();
}

class _InputTextFieldState extends State<InputTextField> {
  bool isShow = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Material(
        borderRadius: BorderRadius.circular(8.0),
        color: const Color(0xFF38A585).withOpacity(0.12),
        child: TextFormField(
          autofocus: false,
          controller: widget.controller,
          obscureText: widget.obscureText && !isShow,
          inputFormatters: widget.inputFormatters,
          validator: (String? val) =>
              val!.isEmpty ? '${widget.lable} Cannot be Empty' : null,
          decoration: InputDecoration(
            icon: widget.icon != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: widget.icon,
                  )
                : null,
            hintText: widget.lable,
            border: InputBorder.none,
            contentPadding: EdgeInsets.fromLTRB(
                (widget.icon == null ? 15.0 : 0.0), 6.0, 10.0, 6.0),
            suffixIcon: widget.obscureText
                ? IconButton(
                    onPressed: () => setState(() => isShow = !isShow),
                    icon:
                        Icon(isShow ? Icons.visibility : Icons.visibility_off),
                    color: Colors.grey,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
