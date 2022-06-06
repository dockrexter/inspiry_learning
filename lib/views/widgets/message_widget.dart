import 'package:flutter/material.dart';
import 'package:inspiry_learning/globals/app_style.dart';
import 'package:inspiry_learning/globals/colors.dart';

class MessageWidget extends StatelessWidget {
  final bool isMe;
  final String message;

  const MessageWidget({
    Key? key,
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
            borderRadius: BorderRadius.circular(5),
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
          style: AppStyle.textstylepoppinsmedium10,
        ),
      ],
    );
  }
}
