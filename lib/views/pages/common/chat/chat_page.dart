import 'package:flutter/material.dart';
import 'package:inspiry_learning/globals/colors.dart';
import 'package:inspiry_learning/globals/strings.dart';
import 'package:inspiry_learning/globals/app_style.dart';
import 'package:inspiry_learning/globals/app_router.dart';
import 'package:inspiry_learning/views/widgets/message_widget.dart';
import 'package:inspiry_learning/views/widgets/custom_text_field.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.16,
            child: SafeArea(
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_outlined,
                      color: AppColors.white,
                    ),
                    onPressed: () => AppRouter.pop(context),
                  ),
                  const Spacer(),
                  Text(
                    AppStrings.chatWithProfessionals,
                    style: AppStyle.textstyleinterbold23.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  const Spacer(flex: 3),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.gray100,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.19),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(40),
                  topLeft: Radius.circular(40),
                ),
              ),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: 50,
                itemBuilder: (context, index) {
                  return MessageWidget(
                    isMe: [true, false][index % 2],
                    message: [
                      "I need proper assignment according to my requirements which i have added bellow in aattched document. What type of requirements from me you need in this assignment?",
                      "Hello Marley, everything is ok? What type of help you needin this assignment? \n\nClick Here to make the payment"
                    ][index % 2],
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: _buildFloatingActionButton(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildFloatingActionButton() => Container(
        height: 48,
        margin: const EdgeInsets.symmetric(horizontal: 18),
        padding: const EdgeInsets.only(left: 16, right: 10),
        decoration: BoxDecoration(
          color: AppColors.teal400,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.camera_alt_outlined,
              size: 22,
              color: AppColors.teal100,
            ),
            const Expanded(
              child: InputTextField(
                AppStrings.typeYourMessage,
                textColor: AppColors.white,
                cursorColor: AppColors.gray800,
              ),
            ),
            const SizedBox(width: 2),
            Transform.rotate(
              angle: 0.2 * 3.14,
              child: const Icon(
                Icons.attach_file_outlined,
                size: 22,
                color: AppColors.white,
              ),
            ),
            const SizedBox(width: 12),
            InkWell(
              onTap: () {},
              child: Container(
                width: 28,
                height: 25,
                padding: const EdgeInsets.only(left: 4, bottom: 4),
                decoration: BoxDecoration(
                  color: AppColors.teal100,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Transform.rotate(
                  angle: -0.23 * 3.14,
                  child: const Icon(
                    Icons.send_outlined,
                    size: 18,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
