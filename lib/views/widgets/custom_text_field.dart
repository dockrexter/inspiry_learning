import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inspiry_learning/globals/app_colors.dart';
import 'package:inspiry_learning/globals/app_style.dart';

class InputTextField extends StatefulWidget {
  const InputTextField(
    this.lable, {
    Key? key,
    this.icon,
    this.textColor,
    this.controller,
    this.cursorColor,
    this.maxLines = 1,
    this.initialValue,
    this.enabled = true,
    this.inputFormatters,
    this.obscureText = false,
  }) : super(key: key);

  final String lable;
  final Widget? icon;
  final bool enabled;
  final int? maxLines;
  final bool obscureText;
  final Color? textColor;
  final Color? cursorColor;
  final String? initialValue;
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
        color: AppColors.teal400.withOpacity(0.12),
        child: TextFormField(
          autofocus: false,
          enabled: widget.enabled,
          maxLines: widget.maxLines,
          controller: widget.controller,
          cursorColor: widget.cursorColor,
          initialValue: widget.initialValue,
          inputFormatters: widget.inputFormatters,
          style: TextStyle(color: widget.textColor),
          obscureText: widget.obscureText && !isShow,
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
            hintStyle: AppStyle.textstylerobotoromanregular13.copyWith(
              color: widget.textColor ?? AppColors.gray9007a,
            ),
            border: InputBorder.none,
            contentPadding:
                widget.icon == null ? const EdgeInsets.only(left: 10) : null,
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
