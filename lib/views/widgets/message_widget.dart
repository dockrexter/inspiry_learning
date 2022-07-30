import 'package:flutter/material.dart';
import 'package:inspiry_learning/globals/app_style.dart';
import 'package:inspiry_learning/globals/app_utils.dart';
import 'package:inspiry_learning/globals/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageWidget extends StatelessWidget {
  final bool isMe;
  final String message;
  final String? linkUrl;
  final String? linktext;

  const MessageWidget({
    Key? key,
    this.linkUrl,
    this.linktext,
    required this.isMe,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(16),
          constraints: const BoxConstraints(maxWidth: 250),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.r),
            color: isMe ? AppColors.teal100 : AppColors.white,
          ),
          child: buildMessage(),
        ),
      ],
    );
  }

  Widget buildMessage() {
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          message,
          style: AppStyle.textstylepoppinsmedium12.copyWith(
            color: AppColors.gray80099,
          ),
        ),
        if (linktext != null) SizedBox(height: 8.h),
        if (linktext != null)
          GestureDetector(
            onTap: linkUrl == null
                ? null
                : () async => await Utils.launchURL(linkUrl!),
            child: Text(
              linktext!,
              style: AppStyle.textstylepoppinssemibold13.copyWith(
                fontSize: 12.sp,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
      ],
    );
  }
}
