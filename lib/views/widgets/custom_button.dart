import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(this.name, {Key? key, this.color, this.onPressed})
      : super(key: key);

  final String name;
  final Color? color;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      padding: const EdgeInsets.all(0),
      child: Container(
        alignment: Alignment.center,
        height: 48.0,
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          name,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontWeight: FontWeight.w700, fontSize: 16.0, color: Colors.white),
        ),
      ),
    );
  }
}
