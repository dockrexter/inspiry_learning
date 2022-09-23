import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inspiry_learning/globals/global_exports.dart';
import 'package:inspiry_learning/models/assignment_model.dart';
import 'package:inspiry_learning/views/widgets/custom_dropdown.dart';
import 'package:inspiry_learning/views/widgets/custom_text_field.dart';
import 'package:inspiry_learning/repositories/assignment_repositories.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({Key? key, required this.assignment, this.onPressed})
      : super(key: key);

  final Assignment assignment;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 100.h,
        margin: EdgeInsets.only(bottom: 20.h, left: 16.w, right: 16.w),
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
                  Utils.convertDateToString(assignment.deadline!),
                  style: AppStyle.textstylepoppinsregular10,
                ),
                const Spacer(),
                Text(
                  AppStrings.startingDate,
                  style: AppStyle.textstylepoppinsbold10,
                ),
                SizedBox(height: 3.h),
                Text(
                  Utils.convertDateToString(assignment.createdDate!),
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
                    assignment.subject!.length > 20
                        ? assignment.subject!.substring(0, 16) + '...'
                        : assignment.subject!,
                    style: AppStyle.textstylepoppinssemibold14,
                  ),
                  SizedBox(
                    width: ScreenSize.width * 0.57,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Utils.getStatus(assignment.status),
                          style: AppStyle.textstylepoppinsmedium10,
                        ),
                        Icon(
                          assignment.status == WorkStatus.compleated
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: AppColors.teal400,
                        ),
                        if (assignment.status == WorkStatus.compleated)
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

  final Function onSelected;
  final VoidCallback? onPressed;
  final Assignment? assignment;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 100,
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        margin: EdgeInsets.only(bottom: 20.h, left: 10.w, right: 10.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: AppColors.teal40065.withOpacity(0.12),
          boxShadow: [
            BoxShadow(
              blurRadius: 12.r,
              offset: const Offset(0, 4),
              color: AppColors.teal900.withOpacity(0.08),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(
                  AppStrings.dueDate,
                  style: AppStyle.textstylepoppinsbold10t,
                ),
                SizedBox(height: 3.h),
                Text(
                  Utils.convertDateToString(assignment!.deadline!),
                  style: AppStyle.textstylepoppinsregular10,
                ),
                const Spacer(),
                SizedBox(
                  width: ScreenSize.width * 0.17,
                  height: ScreenSize.width * 0.075,
                  child: InkWell(
                    onTap: () =>
                        _showTextInputDialog(context, assignment!.assignTo),
                    child: Container(
                      width: 55.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        color: AppColors.greenA700,
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: Center(
                        child: Text(
                          assignment!.assignTo ?? AppStrings.marley,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: ScreenSize.width * 0.6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          assignment!.subject!.length > 20 ? assignment!.subject!.substring(0, 22) + '...' : assignment!.subject!,
                          style: AppStyle.textstylepoppinssemibold14,
                        ),
                        Icon(
                          assignment!.status == WorkStatus.compleated
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: AppColors.teal400,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: ScreenSize.width * 0.6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Utils.getStatus(assignment!.status),
                          style: AppStyle.textstylepoppinsmedium10,
                        ),
                        CustomDropdown(
                          items: AppStrings.items
                              .map((item) =>
                                  DropdownItem(value: item, child: Text(item)))
                              .toList(),
                          child: Text(AppStrings.status,
                              style: AppStyle.textstylepoppinssemibold10),
                          onChange: (s, i) {
                            onSelected(Utils.getWorkStatus(s as String).index);
                          },
                          icon: const Icon(Icons.arrow_drop_down, size: 18),
                          dropdownStyle: DropdownStyle(
                            width: 136.w,
                            borderRadius: BorderRadius.circular(8.r),
                            padding: EdgeInsets.symmetric(
                              vertical: 8.h,
                              horizontal: 8.w,
                            ),
                          ),
                          dropdownButtonStyle: DropdownButtonStyle(
                            width: 70.w,
                            height: 25.h,
                            mainAxisAlignment: MainAxisAlignment.center,
                            padding: EdgeInsets.zero,
                            primaryColor: AppColors.black,
                            backgroundColor: AppColors.yellow701,
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

  void _showTextInputDialog(BuildContext context, String? assignTo) {
    final assigneeController =
        TextEditingController(text: assignTo ?? AppStrings.marley);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
          width: 30.w,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            InputTextField(
              "",
              controller: assigneeController,
              keyboardType: TextInputType.name,
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
            onPressed: () async {
              if (assigneeController.text.isNotEmpty) {
                await AssignmentRepository()
                    .updateAssignee(assignment!.id, assigneeController.text);
              }
              assigneeController.dispose();
              AppRouter.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
