import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inspiry_learning/globals/app_colors.dart';
import 'package:inspiry_learning/globals/app_style.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
    this.name, {
    Key? key,
    this.onPressed,
    this.outlineBoarder = false,
    this.color = AppColors.yellow701,
  }) : super(key: key);

  final String name;
  final Color? color;
  final bool outlineBoarder;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      padding: const EdgeInsets.all(0),
      child: Container(
        alignment: Alignment.center,
        height: 48.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: outlineBoarder ? AppColors.white : color!,
            width: outlineBoarder ? 1 : 0,
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          name,
          textAlign: TextAlign.center,
          style: AppStyle.textstylepoppinsbold16,
        ),
      ),
    );
  }
}
