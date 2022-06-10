import 'package:flutter/material.dart';
import 'package:inspiry_learning/globals/app_colors.dart';
import 'package:inspiry_learning/globals/app_strings.dart';
import 'package:inspiry_learning/globals/user_type.dart';
import 'package:inspiry_learning/globals/app_style.dart';
import 'package:inspiry_learning/globals/app_router.dart';
import 'package:inspiry_learning/views/widgets/custom_button.dart';
import 'package:inspiry_learning/views/widgets/message_widget.dart';
import 'package:inspiry_learning/views/widgets/custom_text_field.dart';
import 'package:inspiry_learning/views/pages/admin/details/assignment_details_page.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool isAdmin = UserTypeHelper.isAdmin();

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
                    isAdmin
                        ? AppStrings.chatWithUser
                        : AppStrings.chatWithProfessionals,
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
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 6),
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
              child: Column(
                children: [
                  if (isAdmin)
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 16, left: 16, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () => AppRouter.push(
                                context, const AssignmentDetailsPage()),
                            child: Text(
                              AppStrings.assignmentDetails,
                              textAlign: TextAlign.center,
                              style:
                                  AppStyle.textstylepoppinssemibold12.copyWith(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: _showBottomQuatationSheet,
                            child: Text(
                              AppStrings.sendQuatation,
                              textAlign: TextAlign.center,
                              style:
                                  AppStyle.textstylepoppinssemibold12.copyWith(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (isAdmin)
                    const Divider(color: AppColors.teal400, height: 12),
                  Expanded(
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
                ],
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

  void _showBottomQuatationSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppStrings.priceQuatation,
              style: AppStyle.textstylepoppinssemibold12.copyWith(
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 20),
            const InputTextField(
              AppStrings.price,
              controller: null,
            ),
            const SizedBox(height: 10),
            const InputTextField(
              AppStrings.discription,
              maxLines: 6,
              controller: null,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: CustomButton(
                AppStrings.done,
                onPressed: () => Navigator.pop(context),
                color: AppColors.teal400,
              ),
            ),
          ],
        ),
      ),
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
