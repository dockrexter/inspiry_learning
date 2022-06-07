import 'package:flutter/material.dart';
import 'package:inspiry_learning/globals/utils.dart';
import 'package:inspiry_learning/globals/colors.dart';
import 'package:inspiry_learning/globals/strings.dart';
import 'package:inspiry_learning/globals/app_style.dart';
import 'package:inspiry_learning/globals/app_router.dart';
import 'package:inspiry_learning/globals/assets_path.dart';
import 'package:inspiry_learning/models/assignment_model.dart';
import 'package:inspiry_learning/views/widgets/custom_card.dart';
import 'package:inspiry_learning/views/pages/common/chat/chat_page.dart';
import 'package:inspiry_learning/views/pages/common/setting/account_setting_page.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  static final assignments = getAssingments();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.teal400,
      body: Column(
        children: [
          SafeArea(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 20.0, left: 22.0, right: 22.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          AppStrings.hello,
                          style: AppStyle.textstylepoppinsbold24.copyWith(
                            color: AppColors.yellow701,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          AppStrings.marley,
                          style: AppStyle.textstylepoppinsbold24.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Image.asset(
                          AppAssets.bellIcon,
                          color: AppColors.white,
                          scale: 4,
                        ),
                        const SizedBox(width: 18),
                        InkWell(
                          onTap: () {
                            AppRouter.push(
                                context, const AccountSettingsPage());
                          },
                          child: Image.asset(
                            AppAssets.settingIcon,
                            color: AppColors.white,
                            scale: 4,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Divider(
            color: AppColors.black.withOpacity(0.08),
            thickness: 1,
          ),
          Expanded(
            child: Container(
              color: AppColors.white,
              child: ListView.builder(
                itemCount: assignments.length,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => CustomCard2(
                  assignment: assignments[index],
                  onSelected: (String status) {
                    assignments[index].workStatus = getWorkStatus(status);
                    setState(() {});
                  },
                  onPressed: () => AppRouter.push(context, const ChatPage()),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
