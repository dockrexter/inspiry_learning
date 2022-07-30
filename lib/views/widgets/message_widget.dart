import 'package:flutter/material.dart';
import 'package:inspiry_learning/globals/app_style.dart';
import 'package:inspiry_learning/globals/app_utils.dart';
import 'package:inspiry_learning/globals/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inspiry_learning/models/message_model.dart';

class MessageWidget extends StatelessWidget {
  final Message message;

  const MessageWidget({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(16),
          constraints: const BoxConstraints(maxWidth: 250),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.r),
            color: message.isMe ? AppColors.teal100 : AppColors.white,
          ),
          child: buildMessage(),
        ),
      ],
    );
  }

  Widget buildMessage() {
    return Column(
      crossAxisAlignment:
          message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          message.message!,
          style: AppStyle.textstylepoppinsmedium12.copyWith(
            color: AppColors.gray80099,
          ),
        ),
        if (message.linktext != null) SizedBox(height: 8.h),
        if (message.linktext != null)
          GestureDetector(
            onTap: message.linkUrl == null
                ? null
                : () async => await Utils.launchURL(message.linkUrl!),
            child: Text(
              message.linktext!,
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
