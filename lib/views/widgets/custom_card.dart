import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inspiry_learning/globals/app_router.dart';
import 'package:inspiry_learning/globals/app_utils.dart';
import 'package:inspiry_learning/globals/app_colors.dart';
import 'package:inspiry_learning/globals/app_strings.dart';
import 'package:inspiry_learning/globals/app_style.dart';
import 'package:inspiry_learning/globals/app_assets.dart';
import 'package:inspiry_learning/models/assignment_model.dart';
import 'package:inspiry_learning/views/widgets/custom_text_field.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({Key? key, required this.assignment, this.onPressed})
      : super(key: key);

  final VoidCallback? onPressed;
  final Assignment assignment;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 100.h,
        margin: EdgeInsets.only(bottom: 20.h, left: 20.w, right: 20.w),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.teal40065.withOpacity(0.12),
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              blurRadius: 12.r,
              offset: const Offset(0, 4),
              color: AppColors.teal900.withOpacity(0.08),
            ),
          ],
        ),
        child: Row(
          children: [
            Column(
              children: [
                Text(
                  AppStrings.dueDate,
                  style: AppStyle.textstylepoppinsbold10t,
                ),
                SizedBox(height: 3.h),
                Text(
                  Utils.convertDateToString(assignment.dueDate!),
                  style: AppStyle.textstylepoppinsregular10,
                ),
                const Spacer(),
                Text(
                  AppStrings.startingDate,
                  style: AppStyle.textstylepoppinsbold10,
                ),
                SizedBox(height: 3.h),
                Text(
                  Utils.convertDateToString(assignment.startDate!),
                  style: AppStyle.textstylepoppinsregular10,
                ),
              ],
            ),
            VerticalDivider(
              width: 26.w,
              thickness: 3,
              color: AppColors.white,
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.h, bottom: 6.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    assignment.title!,
                    style: AppStyle.textstylepoppinssemibold14,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.52,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Utils.getStatus(assignment.workStatus),
                          style: AppStyle.textstylepoppinsmedium10,
                        ),
                        Icon(
                          assignment.workStatus == WorkStatus.compleated
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: AppColors.teal400,
                        ),
                        if (assignment.workStatus == WorkStatus.compleated)
                          GestureDetector(
                            onTap: () {},
                            child: Image.asset(
                              AppAssets.askRevision,
                              scale: 4,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomCard2 extends StatelessWidget {
  const CustomCard2({
    Key? key,
    this.onPressed,
    required this.assignment,
    required this.onSelected,
  }) : super(key: key);

  static final items = [
    'New Request',
    'Under Review',
    'Pending Payment',
    'Work in Progress',
    'Work Completed',
  ];

  final Function onSelected;
  final VoidCallback? onPressed;
  final Assignment assignment;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 100,
        margin: EdgeInsets.only(bottom: 20.h, left: 12.w, right: 12.w),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.teal40065.withOpacity(0.12),
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              blurRadius: 12.r,
              offset: const Offset(0, 4),
              color: AppColors.teal900.withOpacity(0.08),
            ),
          ],
        ),
        child: Row(
          children: [
            Column(
              children: [
                Text(
                  AppStrings.dueDate,
                  style: AppStyle.textstylepoppinsbold10t,
                ),
                SizedBox(height: 3.h),
                Text(
                  Utils.convertDateToString(assignment.dueDate!),
                  style: AppStyle.textstylepoppinsregular10,
                ),
                const Spacer(),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.075,
                  width: MediaQuery.of(context).size.width * 0.17,
                  child: InkWell(
                    onTap: () => _showTextInputDialog(context),
                    child: Container(
                      height: 20.h,
                      width: 55.w,
                      decoration: BoxDecoration(
                        color: AppColors.greenA700,
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: Center(
                        child: Text(
                          AppStrings.marley,
                          style: AppStyle.textstylepoppinsregular7,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            VerticalDivider(
              width: 26.w,
              thickness: 3,
              color: AppColors.white,
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.h, bottom: 6.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          assignment.title!,
                          style: AppStyle.textstylepoppinssemibold14,
                        ),
                        Icon(
                          assignment.workStatus == WorkStatus.compleated
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: AppColors.teal400,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Utils.getStatus(assignment.workStatus),
                          style: AppStyle.textstylepoppinsmedium10,
                        ),
                        InkWell(
                          onTap: () => _showAlertDialog(context),
                          child: Container(
                            height: 25.h,
                            width: 60.w,
                            decoration: BoxDecoration(
                              color: AppColors.yellow701,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Text(
                                AppStrings.status + AppStrings.triangleDown,
                                style: AppStyle.textstylepoppinssemibold10,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTextInputDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
          width: 30.w,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            InputTextField(
              "",
              controller: TextEditingController(text: AppStrings.marley),
            ),
          ]),
        ),
        actions: [
          MaterialButton(
            child: Text(
              AppStrings.done,
              style: AppStyle.textstylepoppinsbold14
                  .copyWith(color: AppColors.white),
            ),
            color: AppColors.greenA700,
            onPressed: () => AppRouter.pop(context),
          ),
        ],
      ),
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
          width: 30.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: items
                .map((e) => Column(
                      children: [
                        InkWell(
                            child: Text(e),
                            onTap: () {
                              onSelected(e);
                              Navigator.pop(context);
                            }),
                        const Divider(),
                      ],
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}
